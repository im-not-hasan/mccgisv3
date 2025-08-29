<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\WithMultipleSheets;
use Maatwebsite\Excel\Concerns\ToCollection;
use PhpOffice\PhpSpreadsheet\RichText\RichText;

class InstructorLoadsImport implements WithMultipleSheets, ToCollection
{
    public int $inserted = 0;
    public int $updated  = 0;
    public int $skipped  = 0;
    public array $errors = [];

    protected ?int $ay_id = null;
    protected int $sheetCount = 1;

    public function __construct(int $sheetCount = 1)
    {
        $this->sheetCount = max(1, $sheetCount);

        $active = DB::table('ay')->where('display', 1)->first();
        $this->ay_id = $active ? (int) $active->id : null;
    }

    /** Register handlers for sheet indexes 0..(sheetCount-1). */
    public function sheets(): array
    {
        $handlers = [];
        for ($i = 0; $i < $this->sheetCount; $i++) {
            $handlers[$i] = $this;
        }
        return $handlers;
    }

    /** Called once per registered sheet. */
    public function collection(Collection $rows)
    {
        $curriculum = DB::table('curriculums')
            ->where('display',1)
            ->first();
        \Log::info('[IL] sheet start', ['rows_raw_count' => $rows->count()]);

        if (!$this->ay_id) {
            $this->errors[] = "No active Academic Year (ay.display = 1).";
            $this->skipped += $rows->count();
            \Log::warning('[IL] abort: no active AY');
            return;
        }

        // Normalize rows
        $rows = $rows->map(function ($row) {
            $arr = is_array($row) ? $row : (array) $row;
            $arr = array_values($arr);
            return $this->normRow($arr);
        });

        \Log::info('[IL] sheet normalized', ['rows_norm_count' => $rows->count()]);
        foreach ($rows->take(40) as $idx => $r) {
            \Log::debug('[IL] row snapshot', ['row' => $idx + 1, 'data' => implode(' | ', $r)]);
        }

        // Empty sheet quick check
        $hasData = false;
        foreach ($rows->take(30) as $r) {
            foreach ($r as $cell) {
                if ($cell !== '') { $hasData = true; break 2; }
            }
        }
        if (!$hasData) {
            \Log::info('[IL] sheet empty → skip');
            return;
        }

        $n = $rows->count();
        $i = 0;
        \Log::info('[IL] iterate rows', ['n' => $n]);

        while ($i < $n) {
            $cells = $rows[$i] ?? [];
            \Log::debug('[IL] loop row', ['row' => $i + 1, 'data' => implode(' | ', $cells)]);

            $hasBoth = $this->rowHasBothLabels($cells, 'Family Name', 'First Name');
            \Log::debug('[IL] check name-row', ['row' => $i + 1, 'hasBoth' => $hasBoth]);

            if ($hasBoth) {
                \Log::info('[IL] candidate name row', ['row' => $i + 1, 'cells' => implode(' | ', $cells)]);

                [$lname, $fname] = $this->extractNamePair($cells);

                \Log::info('[IL] extracted names', [
                    'row'   => $i + 1,
                    'lname' => $lname,
                    'fname' => $fname,
                ]);

                if (!$lname || !$fname) {
                    $this->errors[] = "Row ".($i+1).": can't read instructor name.";
                    \Log::warning('[IL] name parse failed', ['row' => $i + 1]);
                    $i++;
                    continue;
                }

                // Teacher lookup
                $teacher = DB::table('teacher')
                    ->whereRaw('LOWER(fname)=LOWER(?)', [$fname])
                    ->whereRaw('LOWER(lname)=LOWER(?)', [$lname])
                    ->first();

                \Log::info('[IL] teacher lookup', [
                    'row'   => $i + 1,
                    'fname' => $fname,
                    'lname' => $lname,
                    'found' => (bool)$teacher,
                    'id'    => $teacher->id ?? null,
                ]);

                if (!$teacher) {
                    $this->errors[] = "Row ".($i+1).": teacher not found for {$fname} {$lname}.";
                }

                // Seek "A. Basic Load"
                $i = $this->seekDown($rows, $i, fn($r) => $this->rowHasText($r, 'A. Basic Load'));
                \Log::info('[IL] seek Basic Load', ['row' => $i + 1]);
                if ($i >= $n) break;

                // Seek header line with "Code" and "Section"
                $i = $this->seekDown($rows, $i, function ($r) {
                    return $this->rowHasText($r, 'Code') && $this->rowHasText($r, 'Section');
                });
                if ($i >= $n) break;

                $header = $rows[$i];
                $codeCol    = $this->findCol($header, 'Code');
                $sectionCol = $this->findCol($header, 'Section');
                $useLineMode = ($codeCol === null || $sectionCol === null || $codeCol === $sectionCol);

                \Log::info('[IL] header found', [
                    'row'        => $i + 1,
                    'header'     => implode(' | ', $header),
                    'codeCol'    => $codeCol,
                    'sectionCol' => $sectionCol,
                    'lineMode'   => $useLineMode,
                ]);

                // First data row
                $i++;

                while ($i < $n) {
                    $r = $rows[$i];

                    // End of table on blank row
                    $rowBlank = true;
                    foreach ($r as $cell) {
                        if ($cell !== '') { $rowBlank = false; break; }
                    }
                    if ($rowBlank) {
                        \Log::debug('[IL] blank row → end of table', ['row' => $i + 1]);
                        break;
                    }

                    \Log::debug('[IL] data row', ['row' => $i + 1, 'raw' => implode(' | ', $r)]);

                    $code = '';
                    $sectionText = '';

                    if (!$useLineMode) {
                        $code = $this->sanitizeCode($this->safeCell($r, $codeCol));
                        $sectionText = $this->safeCell($r, $sectionCol);

                        $spill = stripos($sectionText, '(lec)') !== false || stripos(implode(' ', $r), '(lec)') !== false;
                        if ($spill) {
                            \Log::debug('[IL] header spill detected → stop table', ['row' => $i + 1]);
                            break;
                        }
                    } else {
                        [$code, $sectionText] = $this->parseLineForCodeAndSection($r);
                        if ($code === null && $sectionText === null) {
                            \Log::debug('[IL] line-mode parse miss → next row', ['row' => $i + 1]);
                            $i++;
                            continue;
                        }
                    }

                    \Log::debug('[IL] parsed code/section', [
                        'row'         => $i + 1,
                        'code'        => $code,
                        'sectionText' => $sectionText,
                        'lineMode'    => $useLineMode,
                    ]);

                    if ($code === '' && $sectionText === '') {
                        \Log::debug('[IL] empty code & section → end table', ['row' => $i + 1]);
                        break;
                    }

                    if ($code !== '' && $sectionText !== '') {
                        [$course, $year, $section] = $this->parseSection($sectionText);

                        \Log::debug('[IL] parsed course/year/section', [
                            'row'     => $i + 1,
                            'course'  => $course,
                            'year'    => $year,
                            'section' => $section,
                        ]);

                        if (!$course || !$year || !$section) {
                            $this->skipped++;
                            $msg = "Row ".($i+1).": bad section '".implode(' ', $r)."'.";
                            $this->errors[] = $msg;
                            \Log::warning('[IL] skip: bad section', ['row' => $i + 1, 'raw' => implode(' | ', $r)]);
                            $i++;
                            continue;
                        }

                        // Subject lookup ignoring spaces
                        $subject = DB::table('subject')
                            ->where('curriculum', $curriculum->curriculum)
                            ->whereRaw("REPLACE(LOWER(code), ' ', '') = ?", [strtolower($code)])
                            ->first();

                        \Log::debug('[IL] subject lookup', [
                            'row'     => $i + 1,
                            'code'    => $code,
                            'found'   => (bool)$subject,
                            'subject' => $subject ? ['id' => $subject->id, 'code' => $subject->code] : null,
                        ]);

                        if (!$subject) {
                            $this->skipped++;
                            $this->errors[] = "Row ".($i+1).": subject not found '{$code}'.";
                            $i++;
                            continue;
                        }
                        if (!$teacher) {
                            $this->skipped++;
                            $this->errors[] = "Row ".($i+1).": no teacher matched.";
                            $i++;
                            continue;
                        }
                        
                        $keys = [
                            'teacher_id' => (int) $teacher->id,
                            'subject_id' => (int) $subject->id,
                            'course'     => $course,
                            'year'       => (string) $year,
                            'section'    => $section,
                            'ay_id'      => $this->ay_id,
                        ];

                        try {
                            $exists = DB::table('assignments')->where($keys)->first();
                            if ($exists) {
                                \Log::info('[IL] assignment update', ['row' => $i + 1, 'id' => $exists->id, 'keys' => $keys]);
                                DB::table('assignments')->where('id', $exists->id)->update($keys);
                                $this->updated++;
                            } else {
                                \Log::info('[IL] assignment insert', ['row' => $i + 1, 'keys' => $keys]);
                                DB::table('assignments')->insert($keys);
                                $this->inserted++;
                            }
                        } catch (\Throwable $e) {
                            $this->skipped++;
                            $this->errors[] = "Row ".($i+1).": ".$e->getMessage();
                            \Log::error('[IL] assignment error', ['row' => $i + 1, 'error' => $e->getMessage(), 'keys' => $keys]);
                        }
                    }

                    $i++;
                }

                // Continue scanning for next instructor block
                continue;
            }

            $i++;
        }

        \Log::info('[IL] sheet done', [
            'inserted' => $this->inserted,
            'updated'  => $this->updated,
            'skipped'  => $this->skipped,
            'errors'   => $this->errors,
        ]);
    }

    // ----------------- helpers -----------------

    /** Convert a row to clean strings (handles RichText, arrays, DateTimes, scalars). */
    protected function normRow(array $row): array
    {
        return array_map(function ($v) {
            if ($v === null) return '';

            if ($v instanceof RichText) {
                $v = $v->getPlainText();
            }

            if ($v instanceof \DateTimeInterface) {
                $v = $v->format('Y-m-d H:i:s');
            }

            if (is_array($v)) {
                $v = implode(' ', array_map(function ($x) {
                    if ($x instanceof RichText) return $x->getPlainText();
                    if ($x instanceof \DateTimeInterface) return $x->format('Y-m-d H:i:s');
                    return is_scalar($x) ? (string) $x : '';
                }, $v));
            }

            if (!is_scalar($v)) {
                $v = method_exists($v, '__toString') ? (string) $v : '';
            }

            // normalize unicode spaces/colons
            $v = str_replace("\xC2\xA0", ' ', (string)$v); // NBSP
            $v = str_replace(['：','﹕','ː','꞉'], ':', $v); // unicode colons

            $s = trim((string) $v);
            return preg_replace('/\s+/', ' ', $s);
        }, $row);
    }

    /** Row contains substring (case-insensitive). */
    protected function rowHasText(array $cells, string $needle): bool
    {
        $needle = strtolower($needle);
        foreach ($cells as $c) {
            if ($c !== '' && str_contains(strtolower($c), $needle)) {
                return true;
            }
        }
        return false;
    }

    /** Robust: row has BOTH labels using strict label-cell matching. */
    protected function rowHasBothLabels(array $cells, string $labelA, string $labelB): bool
    {
        return $this->findLabelIndex($cells, $labelA) !== null
            && $this->findLabelIndex($cells, $labelB) !== null;
    }

    /** Normalize label-like text for comparisons. */
    protected function normalizeLabel(string $s): string
    {
        $s = str_replace("\xC2\xA0", ' ', $s);           // NBSP to space
        $s = str_replace(['：','﹕','ː','꞉'], ':', $s);   // unicode colons → ASCII
        $s = strtolower(trim($s));
        $s = preg_replace('/\s+/', ' ', $s);            // collapse spaces
        if (substr($s, -1) === ':') $s = substr($s, 0, -1); // drop trailing colon
        return $s;
    }

    /** Find exact label cell index (handles “Family Name:”, “Family Name :”, NBSP, unicode colon). */
    protected function findLabelIndex(array $cells, string $label): ?int
    {
        $needle = $this->normalizeLabel($label);
        foreach ($cells as $idx => $raw) {
            $norm = $this->normalizeLabel((string)$raw);
            if ($norm === $needle || str_starts_with($norm, $needle.' ')) {
                return $idx;
            }
        }
        // fallback: substring match
        foreach ($cells as $idx => $raw) {
            $norm = $this->normalizeLabel((string)$raw);
            if (str_contains($norm, $needle)) {
                return $idx;
            }
        }
        return null;
    }

    /** Extract [lname, fname] using scan-right; fallback to parsing inside same cell if needed. */
    protected function extractNamePair(array $cells): array
    {
        $idxL = $this->findLabelIndex($cells, 'Family Name');
        $idxF = $this->findLabelIndex($cells, 'First Name');

        \Log::debug('[IL] label indexes', [
            'idxL' => $idxL,
            'idxF' => $idxF,
            'row'  => implode(' | ', $cells),
        ]);

        $lname = $idxL !== null ? $this->valueRightOfLabelAtIndex($cells, $idxL, 12) : null;
        $fname = $idxF !== null ? $this->valueRightOfLabelAtIndex($cells, $idxF, 12) : null;

        // Fallback: labels + values are all inside one cell (your current case)
        if ($lname === null && $idxL !== null) {
            $lname = $this->valueInsideSameCell($cells[$idxL] ?? '', 'Family Name', ['First Name', 'Middle Initial', 'Employment Status']);
        }
        if ($fname === null && $idxF !== null) {
            $fname = $this->valueInsideSameCell($cells[$idxF] ?? '', 'First Name', ['Middle Initial', 'Employment Status', 'Family Name']);
        }

        \Log::debug('[IL] name values scan-right+inside', ['lnameRaw' => $lname, 'fnameRaw' => $fname]);

        $lname = $this->dedupeWords($lname);
        $fname = $this->dedupeWords($fname);

        return [$lname, $fname];
    }

    /**
     * From a known label index on the row, return the first non-empty, non-label cell to the right.
     */
    protected function valueRightOfLabelAtIndex(array $cells, int $idx, int $lookahead = 12): ?string
    {
        $n = count($cells);

        for ($j = $idx + 1; $j < min($n, $idx + 1 + $lookahead); $j++) {
            $candidate = trim((string)($cells[$j] ?? ''));
            if ($candidate === '') continue;

            $c = strtolower($candidate);
            $looksLikeLabel =
                str_contains($c, 'family name') ||
                str_contains($c, 'first name')  ||
                str_contains($c, 'middle initial') ||
                str_contains($c, 'employment status');

            if ($looksLikeLabel) continue;

            \Log::debug('[IL] valueRightOfLabel pick', ['fromIdx' => $idx, 'pickIdx' => $j, 'picked' => $candidate]);
            return preg_replace('/\s+/', ' ', $candidate);
        }

        \Log::debug('[IL] valueRightOfLabel none', ['fromIdx' => $idx]);
        return null;
    }

    /**
     * Parse value for a label **inside the same cell**:
     * e.g. "Family Name: BRACERO First Name: RICHARD Middle Initial: M."
     * Extract after "Family Name" up to the next stop label.
     */
    protected function valueInsideSameCell(string $cellText, string $label, array $stopLabels): ?string
    {
        $src = $this->normalizeInline($cellText);
        $labelRx = preg_quote($this->normalizeInline($label), '/');

        // Build a stop pattern like: (?:First Name|Middle Initial|Employment Status)\b
        $stops = array_map(fn($s) => preg_quote($this->normalizeInline($s), '/'), $stopLabels);
        $stopAlt = $stops ? '(?:' . implode('|', $stops) . ')\\b' : '$';

        // Regex: capture text after label (optional colon/spaces) until next stop label or end
        $re = '/'.$labelRx.'\s*:?\s*(.*?)\s*(?='.$stopAlt.'|$)/i';

        if (preg_match($re, $src, $m)) {
            $val = trim($m[1]);
            $val = preg_replace('/\s+/', ' ', $val);
            \Log::debug('[IL] valueInsideSameCell hit', [
                'label' => $label,
                'src'   => $src,
                'val'   => $val,
            ]);
            return $val !== '' ? $val : null;
        }

        \Log::debug('[IL] valueInsideSameCell miss', [
            'label' => $label,
            'src'   => $src,
        ]);
        return null;
    }

    /** Normalize inline text for regex (keep case-insensitive behavior in regex). */
    protected function normalizeInline(string $s): string
    {
        $s = str_replace("\xC2\xA0", ' ', $s);           // NBSP
        $s = str_replace(['：','﹕','ː','꞉'], ':', $s);   // unicode colons → ASCII
        $s = trim(preg_replace('/\s+/', ' ', $s));
        return $s;
    }

    /** Collapse duplicated adjacent words. */
    protected function dedupeWords(?string $s): ?string
    {
        if (!$s) return $s;
        $parts = preg_split('/\s+/', trim($s));
        $out = [];
        $prev = null;
        foreach ($parts as $p) {
            if ($prev === null || strcasecmp($p, $prev) !== 0) $out[] = $p;
            $prev = $p;
        }
        return implode(' ', $out);
    }

    /** Treat whole row as one line to extract code + section when headers are merged. */
    protected function parseLineForCodeAndSection(array $row): array
    {
        $line = trim(preg_replace('/\s+/', ' ', implode(' ', $row)));

        if ($line === '' || stripos($line, '(lec)') !== false) {
            return [null, null]; // likely header-ish
        }

        // CODE: ITE212 / ITE 212 / CS101 / etc.
        if (!preg_match('/\b([A-Z]{2,}\s?\d{3,})\b/', $line, $mCode)) {
            return [null, null];
        }
        $code = strtoupper(str_replace(' ', '', $mCode[1]));

        // Look for section after the code
        $afterCode = substr($line, strpos($line, $mCode[0]) + strlen($mCode[0]));

        // Abbrev forms: BSIT-2SW / BSIT2SW / BSIT-2 SW
        if (preg_match('/\b([A-Z]+-?\d+\s*[A-Z]+)\b/i', $afterCode, $mSec)) {
            return [$code, strtoupper(preg_replace('/\s+/', '', $mSec[1]))];
        }

        // Full-word forms: BSIT-3NORTH / BSIT-2SOUTHEAST etc.
        if (preg_match('/\b([A-Z]+-\d+\s*(NORTH|SOUTH|EAST|WEST|NORTHEAST|NORTHWEST|SOUTHEAST|SOUTHWEST))\b/i', $afterCode, $mSec2)) {
            return [$code, strtoupper(preg_replace('/\s+/', '', $mSec2[1]))];
        }

        return [$code, null];
    }

    protected function seekDown(Collection $rows, int $start, callable $pred): int
    {
        $n = $rows->count();
        for ($i = $start; $i < $n; $i++) {
            if ($pred($rows[$i])) return $i;
        }
        return $n;
    }

    /** Find a data column by header label (forgiving: exact or contains). */
    protected function findCol(array $header, string $label): ?int
    {
        $label = strtolower(trim($label));
        foreach ($header as $idx => $txt) {
            $t = strtolower(trim($txt));
            if ($t === $label) return $idx;
            if ($t !== '' && str_contains($t, $label)) {
                return $idx;
            }
        }
        return null;
    }

    protected function safeCell(array $row, int $col): string
    {
        return isset($row[$col]) ? trim((string) $row[$col]) : '';
    }

    protected function sanitizeCode(string $code): string
    {
        // Normalize "ITE 212" -> "ITE212"
        return strtoupper(str_replace(' ', '', $code));
    }

    protected function expandDirection(string $abbr): ?string
    {
        $abbr = strtoupper(trim($abbr));
        $map = [
            'N'  => 'North',
            'S'  => 'South',
            'E'  => 'East',
            'W'  => 'West',
            'NE' => 'Northeast',
            'NW' => 'Northwest',
            'SE' => 'Southeast',
            'SW' => 'Southwest',
        ];
        return $map[$abbr] ?? null;
    }

    /** Parse "BSIT-2SW", "BSIT2SW", or "BSIT-2 SW" -> [course, year, section] */
    protected function parseSection(string $s): array
    {
        $s = strtoupper(trim($s));
        if (preg_match('/^([A-Z]+)-?(\d)\s*([A-Z]+)$/', $s, $m)) {
            $course = $m[1];
            $year   = (int) $m[2];
            $abbr   = $m[3];

            $full = $this->expandDirection($abbr) ?? $abbr;
            return [$course, $year, $full];
        }
        return [null, null, null];
    }
}
