<template>
  <div class="relative p-4 text-[11px] font-[Times_New_Roman,serif] print:text-[10px]">
    <!-- Watermark (behind everything) -->
    <div class="absolute inset-0 flex items-center justify-center z-0">
      <img
        src="/watermark.png"
        alt="Watermark"
        class="w-full"
      />
    </div>

    <!-- Foreground content -->
    <div class="relative z-10">
      <!-- Header image -->
      <div class="flex justify-center mb-2 relative mt-[-200px]">
        <img src="/header.png" alt="MCC Header" class="w-full max-h-32 object-contain" />
      </div>

      <!-- Title -->
      <div class="mt-2 text-lg uppercase text-center" style="font-weight: 1000">Official Transcript of Records</div>

      <!-- Bio table -->
      <table class="w-full border border-black text-[11px] border-collapse" style="margin-bottom: -10px;">
           <colgroup>
            <col style="width:65%;">
            <col style="width:10%;">
            <col style="width:25%;">
          </colgroup>
        <tbody>
          <!-- Row 1 -->
          <tr>
            <td class="border border-black px-2 py-1 w-[40%]">
              <div class="flex justify-between">
                <div class="flex-1 text-center">
                  <div class="uppercase  text-sm">SURNAME</div>
                  <div class="font-bold uppercase text-base">{{ studentInfo.surname }}</div>
                </div>
                <div class="flex-1 text-center">
                  <div class="uppercase  text-sm">FIRST NAME</div>
                  <div class="font-bold uppercase text-base">{{ studentInfo.firstname }}</div>
                </div>
                <div class="flex-1 text-center">
                  <div class="uppercase  text-sm">MIDDLE NAME</div>
                  <div class="font-bold uppercase text-base">{{ studentInfo.middlename }}</div>
                </div>
              </div>
            </td>
            <td class="border border-black px-2 py-1 w-[15%] text-center ">
              <div class="uppercase  text-sm">COURSE</div>
              <div class="font-bold uppercase text-base">{{ studentInfo.course }}</div>
            </td>
            <td class="border border-black px-0 py-0 w-[20%] align-top">
              <table class="w-full border-collapse text-[11px]">
                <thead>
                  <tr>
                    <th colspan="3" class="text-center border-b border-black p-0">Date of Birth</th>
                  </tr>
                  <tr class="text-center">
                    <th class="border-r border-black text-sm">Month</th>
                    <th class="border-r border-black text-sm">Day</th>
                    <th class=" text-sm">Year</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="text-center">
                    <td class="border-r border-black text-sm font-bold">{{ studentInfo.dob_month }}</td>
                    <td class="border-r border-black text-sm font-bold">{{ studentInfo.dob_day }}</td>
                    <td class="text-sm font-bold">{{ studentInfo.dob_year }}</td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>
        </tbody>
      </table>



        <!-- Row 2 -->
      <table class="w-full border border-black text-[11px] border-collapse" style="margin-top: 9.5px">
            <!-- tune widths if needed -->
            <col style="width:15%;">  <!-- left content (names / left labels) -->
            <col style="width:9%;">  <!-- course / small label cells -->
            <col style="width:10%;">  <!-- DOB / right block -->
            <col style="width:32%;">
            <col style="width:22%;">  <!-- photo column -->
        <tbody>
          <tr>
            <td class="border border-black px-2 py-0"  colspan="2">
              <div class="text-sm leading-tight" style="margin-top: -20px;">Place of Birth</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.place_of_birth }}</div>
            </td>
            <td class="border border-black px-2 py-0">
              <div class="leading-tight" style="font-size: 13px; margin-top: -20px;">Civil Status</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.civil_status }}</div>
            </td>
            <td class="border border-black px-2 py-0" colspan="1">
              <div class="text-sm text-right leading-tight"  style="margin-top: -20px;">Intermediate S.Y.      {{ studentInfo.intermediate_sy }}</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.intermediate_school }}</div>
            </td>
            <!-- PHOTO (rowspan=5) -->
            <td class="border border-black w-[120px] text-center align-top" rowspan="4">
              <div class="w-full overflow-hidden z-30" style="max-height: 170px; max-width: 344px;">
                <img
                  v-if="studentInfo.picture"
                  :src="'data:image/jpeg;base64,' + studentInfo.picture"
                  class="w-full h-full object-cover"
                />
              </div>
            </td>
          </tr>

          <!-- Row 3 -->
          <tr>
            <td class="border border-black px-2 py-0">
              <div class="text-sm leading-tight" style="margin-top: -20px;">Citizenship</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.citizenship }}</div>
            </td>
            <td class="border border-black px-2 py-0">
              <div class="text-sm leading-tight" style="margin-top: -20px;">Religion</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.religion }}</div>
            </td>
            <td class="border border-black px-2 py-0">
              <div class="text-sm leading-tight" style="margin-top: -20px;">Sex</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.sex }}</div>
            </td>
            <td class="border border-black px-2 py-0">
              <div class="text-sm text-right" style="margin-top: -20px;">High School S.Y. {{ studentInfo.highschool_sy }}</div>
              <div class="text-sm" style="margin-bottom: -10px;">{{ studentInfo.highschool_school }}</div>
            </td>
          </tr>

          <!-- Row 4 -->
          <tr>
            <td class="border border-black px-2 py-0" colspan="3">
              <div class="text-sm leading-tight" style="margin-top: -15px;">Parent or Guardian</div>
              <div class="leading-tight text-center" style="margin-bottom: -15px;">{{ studentInfo.guardian_name }}</div>
            </td>
            <td class="border border-black px-2 py-0" colspan="1" >
              <div class="text-sm leading-tight text-right" style="margin-top: -15px;">Student's ID Number: {{ studentInfo.student_number }}</div>
              <hr class="border-black" style="width: 108%; margin-left: -9px;"></hr>
              <div class="text-sm leading-tight text-right" style="margin-bottom: -15px;">Date Enrolled: {{ studentInfo.date_enrolled }}</div>
            </td>
          </tr>

          <!-- Row 5 -->
          <tr>
            <td class="border border-black px-2 py-0" colspan="4">
              <div class="text-sm leading-tight" style="line-height: 3px;">Home Address: {{ studentInfo.home_address }}</div>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Main grades table (your original unchanged) -->
      <div class="mt-3">
        <table class="w-full border-[2px] border-black border-collapse">
          <thead class="text-center">
            <tr class="uppercase">
              <th class="border-[2px] border-black px-2 py-1 w-[10%]">Code</th>
              <th class="border-[2px] border-black px-2 py-1 text-left">Course and Descriptive Title</th>
              <th class="border-[2px] border-black px-2 py-1 w-[10%]">Rating</th>
              <th class="border-[2px] border-black px-2 py-1 w-[12%]">Re-exam</th>
              <th class="border-[2px] border-black px-2 py-1 w-[8%]">Units</th>
              <th class="border-[2px] border-black px-2 py-1 w-[14%]">Remarks</th>
            </tr>
          </thead>
          <tbody>
            <template v-for="(rows, block) in grouped" :key="block">
              <tr>
                <td colspan="6" class="border-[2px] border-black px-2 py-[6px]">
                  {{ block }}
                </td>
              </tr>
              <tr v-for="(r, idx) in rows" :key="block + '-' + idx" class="align-top">
                <td class="border-[1px] border-black px-2 py-1">{{ r.code }}</td>
                <td class="border-[1px] border-black px-2 py-1">{{ r.title }}</td>
                <td class="border-[1px] border-black px-2 py-1 text-center">{{ formatRating(r.rating) }}</td>
                <td class="border-[1px] border-black px-2 py-1 text-center">{{ r.reexam }}</td>
                <td class="border-[1px] border-black px-2 py-1 text-center">{{ r.units }}</td>
                <td class="border-[1px] border-black px-2 py-1 text-center">{{ r.remarks }}</td>
              </tr>
            </template>
          </tbody>
        </table>
      </div>

      <!-- Remarks box -->
      <div class="mt-3">
        <table class="w-full border border-black">
          <tr>
            <td class="w-[110px] border-r border-black px-2 py-1 font-bold uppercase">Remarks:</td>
            <td class="px-2 py-1">for employment</td>
          </tr>
        </table>
      </div>

      <!-- Footer line and signatories -->
      <div class="mt-2 border-t-2 border-black"></div>

      <div class="mt-2 grid grid-cols-3 gap-6">
        <!-- Prepared by -->
        <div>
          <div class="text-center mt-8 font-bold underline uppercase">{{ footer.prepared_by }}</div>
          <div class="text-center -mt-1">Prepared by</div>
        </div>

        <!-- (Empty center cell for spacing / legend left edge) -->
        <div></div>

        <!-- Registrar -->
        <div>
          <div class="text-center mt-8 font-bold underline uppercase">{{ footer.registrar }}</div>
          <div class="text-center -mt-1">{{ footer.registrar_title }}</div>
        </div>
      </div>

      <!-- Grading System legend -->
      <div class="mt-3 grid grid-cols-2 gap-8 text-[10px]">
        <div>
          <div>Credits: One college unit of credit is one hour lecture or recitation or three hours of laboratory, drafting, or shop work each week for a period of a complete semester.</div>
          <div class="mt-2">
            <span class="font-bold">Note:</span> This copy is an exact reproduction of the transcript on file with the Office of the Registrar and is considered as an original copy when it bears the dry seal of the College and original signature in ink of the Registrar. Any erasure or alteration made on this copy renders the whole transcript invalid.
          </div>
        </div>

        <div>
          <div class="uppercase font-bold text-center">Grading System</div>
          <table class="w-full mt-1">
            <tbody>
              <tr><td>1.0</td><td>96–100%</td></tr>
              <tr><td>1.1–1.4</td><td>94–95%</td></tr>
              <tr><td>1.5–1.9</td><td>90–93%</td></tr>
              <tr><td>2.0–2.4</td><td>85–89%</td></tr>
              <tr><td>2.5–2.9</td><td>80–84%</td></tr>
              <tr><td>3.0</td><td>75–79%</td></tr>
              <tr><td>5.0</td><td>Failure</td></tr>
              <tr><td>NG</td><td>No Grade</td></tr>
              <tr><td>NC</td><td>No Credit</td></tr>
              <tr><td>W/DR</td><td>Withdrawn/Dropped</td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Seal note + page number -->
      <div class="mt-8 flex justify-between text-[10px]">
        <div>Not valid without School Seal</div>
        <div>Page {{ pageNo }} of 1</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { usePage } from '@inertiajs/vue3'

const page = usePage()
const studentInfo = page.props.studentInfo
const grouped = page.props.grouped || {}
const college = page.props.college
const footer = page.props.footer
const pageNo = page.props.pageNo || 1

const formatRating = (v) => {
  if (v === null || v === '' || isNaN(Number(v))) return ''
  return Number(v).toFixed(1)
}

onMounted(() => {
  setTimeout(() => window.print(), 50)
  setTimeout(() => window.close(), 500)
})
</script>

<style>
@media print {
  @page {
    /* Folio (8.5 x 13) like your sample; change to letter if needed */
    size: 8.5in 13in;
    margin: 3mm;
  }
  body {
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
}
</style>
