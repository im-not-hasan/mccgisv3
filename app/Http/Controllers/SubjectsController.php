<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class SubjectsController extends Controller
{
    public function getSubjectCountsByCourse(Request $request)
    {
        $mode = $request->query('mode', 'active');

        // Fetch active semesters for "active" counts
        $activeSemesters = DB::table('ay')
            ->where('display', 1)
            ->pluck('semester')
            ->map(fn($s) => $s == 3 ? 'summer' : (string) $s)
            ->toArray();

        $baseQuery = DB::table('subject')->select('course', DB::raw('count(*) as total'));

        if ($mode === 'active') {
            $baseQuery->whereIn('semester', $activeSemesters);
        }

        $counts = $baseQuery->groupBy('course')->pluck('total', 'course');

        // Total vs Active overall count
        $totalCount = DB::table('subject')->count();
        $activeCount = DB::table('subject')->whereIn('semester', $activeSemesters)->count();

        return response()->json([
            'byCourse' => $counts,
            'totals' => [
                'total' => $totalCount,
                'active' => $activeCount,
            ],
        ]);
    }


    public function getSubjectsByCourse($course)
    {
        // Fetch active semesters from `ay` table
        $activeSemesters = DB::table('ay')
            ->where('display', 1)
            ->pluck('semester')
            ->map(function ($s) {
                return $s == 3 ? 'summer' : (string) $s;
            });

        // Fetch subjects of this course that match active semesters
        $subjects = DB::table('subject')
            ->where('course', $course)
            ->whereIn('semester', $activeSemesters)
            ->select('id', 'code', 'title', 'lecunit', 'labunit', 'totalunit', 'pre', 'year', 'semester')
            ->get();

        return response()->json($subjects);
    }

    public function getAllSubjectsByCourse($course)
    {
        $subjects = DB::table('subject')
            ->where('course', $course)
            ->select('id', 'code', 'title', 'lecunit', 'labunit', 'totalunit', 'pre', 'year', 'semester')
            ->get();

        return response()->json($subjects);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'code'      => 'required|string|max:20',
            'title'     => 'required|string|max:255',
            'lecunit'   => 'required|numeric|min:0',
            'labunit'   => 'required|numeric|min:0',
            'pre'       => 'nullable|string|max:255',
            'year'      => 'required|integer|between:1,4',
            'semester'  => 'required|string|max:10',
            'course'    => 'required|string|max:50',
        ]);

        $validated['totalunit'] = $validated['lecunit'] + $validated['labunit'];

        try {
            DB::table('subject')->insert([
                'code'      => $validated['code'],
                'title'     => $validated['title'],
                'lecunit'   => $validated['lecunit'],
                'labunit'   => $validated['labunit'],
                'totalunit' => $validated['totalunit'],
                'pre'       => $validated['pre'],
                'year'      => $validated['year'],
                'semester'  => $validated['semester'],
                'course'    => $validated['course'],
            ]);

            Log::info("Subject added successfully", ['code' => $validated['code']]);

            return response()->json(['message' => 'Subject added successfully'], 201);
        } catch (\Exception $e) {
            Log::error("Error adding subject", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to add subject'], 500);
        }
    }
    public function destroy($id)
    {
        \Log::info("Deleting subject", ['id' => $id]);
        DB::table('subject')->where('id', $id)->delete();
        return response()->json(['message' => 'Deleted']);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'code'      => 'required|string|max:20',
            'title'     => 'required|string|max:255',
            'lecunit'   => 'required|numeric|min:0',
            'labunit'   => 'required|numeric|min:0',
            'pre'       => 'nullable|string|max:255',
            'year'      => 'required|integer|between:1,4',
            'semester'  => 'required|string|max:10',
            'course'    => 'required|string|max:50',
        ]);

        $validated['totalunit'] = $validated['lecunit'] + $validated['labunit'];

        try {
            DB::table('subject')
                ->where('id', $id)
                ->update($validated);

            Log::info("Subject updated", ['id' => $id, 'code' => $validated['code']]);
            return response()->json(['message' => 'Subject updated successfully']);
        } catch (\Exception $e) {
            Log::error("Failed to update subject", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to update subject'], 500);
        }
    }
}
