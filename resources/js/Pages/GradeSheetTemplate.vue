<template>
  <div class="p-4 text-xs font-sans print:text-[9px]">
    <!-- Header Image -->
    <div class="flex justify-center mb-2">
      <img src="/header.png" alt="MCC Header" class="w-full max-h-32 object-contain" />
    </div>

    <!-- Title -->
    <div class="mt-[-2px] font-bold text-lg text-center uppercase">
      COLLEGE GRADE SHEET
    </div>

    <!-- Instruction -->
    <div class="mb-2 text-[10px] text-justify leading-tight">
      <strong>INSTRUCTION:</strong> This should be accomplished in duplicate duly approved by the Dean. 
      One copy should be submitted to the Registrar’s Office while the other copy should be forwarded to the Dean.
    </div>

    <!-- Subject Info (Excel-style 1×3 tables) -->
    <div class="grid grid-cols-2 gap-4 text-[10px] mb-3">
      <!-- Left table: Subject Code / Description / Course -->
      <table class="w-[90%]  whitespace-nowrap overflow-hidden text-ellipsis border-spacing-0 align-top">
        <tbody>
          <tr class="leading-tight">
            <td class="pr-2 font-bold whitespace-nowrap align-middle w-[110px]">Subject Code:</td>
            <td class="border border-black px-1 py-[2px] font-bold uppercase">
              {{ subject?.code }}
            </td>
          </tr>
          <tr class="leading-tight">
            <td class="pr-2 font-bold whitespace-nowrap align-middle">Description:</td>
            <td class="border border-black px-1 py-[2px] font-bold uppercase">
              {{ subject?.title }}
            </td>
          </tr>
          <tr class="leading-tight">
            <td class="pr-2 font-bold whitespace-nowrap align-middle">Course:</td>
            <td class="border border-black px-1 py-[2px] font-bold uppercase">
              {{ course }}-{{ year }}
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Right table: Section / Semester / Academic Year -->
      <table class="w-[90%] border-spacing-0 align-top ml-8">
        <tbody>
          <tr class="leading-tight">
            <td class="pr-2 font-bold whitespace-nowrap align-middle w-[95px]">Section:</td>
            <td class="border border-black px-1 py-[2px] font-bold uppercase">
              {{ section }}
            </td>
          </tr>
          <tr class="leading-tight">
            <td class="pr-2 font-bold whitespace-nowrap align-middle">Semester:</td>
            <td class="border border-black px-1 py-[2px] font-bold uppercase">
              {{ subject?.semester_display }}
            </td>
          </tr>
          <tr class="leading-tight">
            <td class="pr-2 font-bold whitespace-nowrap align-middle">Academic Year:</td>
            <td class="border border-black px-1 py-[2px] font-bold uppercase">
              {{ ay }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>



    <!-- === Grade Sheet Table === -->
    <table class="w-full table-fixed border-[2px] border-black border-collapse text-[9px]">
      <!-- Column model (widths) -->
      <colgroup>
        <col class="col-idx" />     <!-- 1) Row # -->
        <col class="col-name" />    <!-- 2) Student name -->
        <col class="col-sub" />     <!-- 3) Absences Midterm -->
        <col class="col-sub" />     <!-- 4) Absences Final -->
        <col class="col-sub" />     <!-- 5) Ratings Midterm -->
        <col class="col-sub" />     <!-- 6) Ratings Final -->
        <col class="col-sub" />     <!-- 7) Ratings Final Ratings -->
        <col class="col-units" />   <!-- 8) Units -->
        <col class="col-sub" />     <!-- 9) Remarks Midterm -->
        <col class="col-sub" />     <!-- 10) Remarks Final -->
        <col class="col-sub" />     <!-- 11) Remarks Final Ratings -->
      </colgroup>

      <thead>
        <!-- Row 1: group headers; Name spans idx+name; Units spans 2 rows -->
        <tr class="text-center font-bold">
          <th rowspan="2" colspan="2" class="border-[2px] border-black align-middle px-1 text-[10px]">
            NAME OF STUDENT
            (ARRANGE ALPHABETICALLY BY COURSE, YEAR AND SEX)
          </th>

          <th colspan="2" class="border-[2px] border-black px-1 text-[8px] h-[30px]">ABSENCES</th>
          <th colspan="3" class="border-[2px] border-black px-1 text-[8px] h-[30px]">RATINGS</th>

          <th rowspan="2" class="border-[2px] border-black align-middle text-[8px]">
            UNITS
          </th>

          <th colspan="3" class="border-[2px] border-black px-1 text-[8px] h-[30px]">REMARKS</th>
        </tr>

        <!-- Row 2: subheaders -->
        <tr class="text-center italic">
          <!-- ABSENCES -->
          <th class="border-[2px] border-black px-1 text-[8px] h-[30px]">MIDTERM</th>
          <th class="border-[2px] border-black px-1 text-[8px] h-[30px]">FINAL</th>
          <!-- RATINGS -->
          <th class="border-[2px] border-black px-1 text-[8px] h-[30px]">MIDTERM</th>
          <th class="border-[2px] border-black px-1 text-[8px] h-[30px]">FINAL</th>
          <th class="border-[2px] border-black px-1 text-[8px] leading-tight h-[30px]">FINAL RATINGS</th>
          <!-- REMARKS -->
          <th class="border-[2px] border-black px-1 text-[8px] h-[30px]">MIDTERM</th>
          <th class="border-[2px] border-black px-1 text-[8px] h-[30px]">FINAL</th>
          <th class="border-[2px] border-black px-1 text-[8px] leading-tight h-[30px]">FINAL RATINGS</th>
        </tr>
      </thead>

      <tbody>
        <tr v-for="(student, i) in rows" :key="i" class="text-center leading-none h-[12px]">

          <!-- LAYOUT WITH BLACK BG ROW AFTER MALES 
          
          <!-- Normal rows 
          <template v-if="student.gender !== 'Spacer'">
            <td class="col-idx border-[2px] border-black px-1">{{ i + 1 }}</td>
            <td class="col-name border-[2px] border-black text-left px-2">
              {{ student.name }}
            </td>
            <td class="col-sub border-[2px] border-black">{{ student.midterm_absences }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.final_absences }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.midterm }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.final }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.final_rating }}</td>
            <td class="col-units border-[2px] border-black">{{ student.units }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.midterm_remarks }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.final_remarks }}</td>
            <td class="col-sub border-[2px] border-black">{{ student.final_rating_remarks }}</td>
          </template>

          <!-- Spacer row 
          <template v-else>
            <td class="col-idx border-[2px] border-black">{{ i + 1 }}</td>
            <td class="col-name border-[2px] border-black bg-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-units border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
            <td class="col-sub border-[2px] border-black"></td>
          </template> -->


          

          <!-- numbers and name are two real columns under same header group -->
          <td class="border-[1px] border-black px-1">{{ i + 1 }}</td>
          <td class="border-[1px] border-black text-left px-2">
            {{ student.name }}
          </td>

          <!-- ABSENCES -->
          <td class="border-[1px] border-black">{{ student.midterm_absences }}</td>
          <td class="border-[1px] border-black">{{ student.final_absences }}</td>

          <!-- RATINGS -->
          <td class="border-[1px] border-black">{{ isNaN(Number(student.midterm)) || student.midterm == null || student.midterm === '' ? '' : Number(student.midterm).toFixed(1) }}</td>
          <td class="border-[1px] border-black">{{ isNaN(Number(student.final)) || student.final == null || student.final === '' ? '' : Number(student.final).toFixed(1) }}</td>
          <td class="border-[1px] border-black">{{ isNaN(Number(student.overall)) || student.overall == null || student.overall === '' ? '' : Number(student.overall).toFixed(1) }}</td>

          <!-- UNITS -->
          <td class="border-[1px] border-black">{{ student.gender === 'Spacer' ? '' : subject?.units }}</td>

          <!-- REMARKS -->
          <td class="border-[1px] border-black" :class="remarkClass(student.midterm)">{{ passFailLabel(student.midterm) }}</td>
          <td class="border-[1px] border-black" :class="remarkClass(student.final)">{{ passFailLabel(student.final) }}</td>
          <td class="border-[1px] border-black" :class="remarkClass(student.overall)">{{ passFailLabel(student.overall) }}</td>
        </tr>
      </tbody>
      <tfoot>
        <!-- gray separator bar between main table and footer -->
        <tr>
          <td colspan="11"
              class="h-[7px]  border-[2px] border-black p-0" 
              style="background-color:#b6b6b6;"
              ></td>
        </tr>
      </tfoot>
    </table>


        
    <!-- Footer as one table with 3 columns -->
    <table class="w-full table-fixed border-[2px] border-black border-collapse text-[9px] mt-[-2px]">
      <colgroup>
        <col />  <!-- For Midterm Ratings -->
        <col />  <!-- Grading System -->
        <col />  <!-- For Final Ratings -->
      </colgroup>
      <tbody>
        <tr class="align-top">
          <!-- FOR MIDTERM RATINGS -->
          <td class="border-[2px] border-black p-0">
            <div class="text-center font-bold uppercase py-1 text-[12px] mt-[-4px]">
              FOR MIDTERM RATINGS
            </div>

            <div class="px-2 py-2">
              <div class="mb-2">
                <div class="text-center mb-1 mt-[-2px]">Submitted by:</div>
                <div class="text-center font-bold underline mt-2 uppercase">{{ teacher_name }}</div>
                <div class="text-center mt-[-2px]">Instructor</div>
              </div>

              <!-- thin internal divider -->
              <div class="border-t-[2px] border-black"></div>

              <div class="mb-2">
                <div class="mb-1 text-center mt-[-2px]">Certified Correct:</div>
                <div class="text-center font-bold underline mt-2">CHARO MAE F. ORBETA</div>
                <div class="text-center mt-[-2px]">Registrar</div>
              </div>

              <div class="flex items-center mt-2">
                <span class="mr-2 whitespace-nowrap">Date Submitted:</span>
                <span class="inline-block border-b border-black h-[0px] w-[140px]"></span>
              </div>
            </div>
          </td>

          <!-- GRADING SYSTEM -->
          <td class="border-[2px] border-black p-0 align-top">
  <!-- band header -->
  <div class="text-center font-bold uppercase py-1 border-b-[2px] border-black text-[12px] leading-none">
    GRADING SYSTEM
  </div>

  <!-- 4-column matrix -->
  <div class="px-6 pt-2 pb-1 grid grid-cols-4 gap-x-6 text-center leading-none">
    <!-- Grade point -->
    <div class="space-y-[3px] font-bold">
      <div class="mt-3"></div><div>1.5</div><div>2.0</div>
      <div>2.5</div><div>3.0</div><div>3.5</div>
    </div>
    <!-- Equivalent cut -->
    <div class="space-y-[3px]">
      <div>1.0</div><div>1.1</div><div>1.6</div>
      <div>2.1</div><div>2.6</div><div>3.1</div>
    </div>
    <!-- Low % -->
    <div class="space-y-[3px]">
      <div>95</div><div>90</div><div>85</div>
      <div>80</div><div>75</div><div>70</div>
    </div>
    <!-- High % -->
    <div class="space-y-[3px]">
      <div>100</div><div>94</div><div>89</div>
      <div>84</div><div>79</div><div>74</div>
    </div>
  </div>

  <!-- Legend (NG/NC/W/DR/5.0) -->
  <div class="px-8 mt-5  grid grid-cols-2  leading-none">
    <div>NG</div><div>No Grade</div>
    <div>NC</div><div>No Credit</div>
    <div>W</div><div>Withdrawn</div>
    <div>DR</div><div>Dropped</div>
    <div>5.0</div><div class="w-[100px]">Failure ( Must Repeat )</div>
  </div>
</td>


          <!-- FOR FINAL RATINGS -->
          <td class="border-[2px] border-black p-0">
            <div class="text-center font-bold uppercase py-1 text-[12px] mt-[-4px]">
              FOR FINAL RATINGS
            </div>

            <div class="px-2 py-2">
              <div class="mb-2">
                <div class="mb-1 text-center mt-[-2px]" >Submitted by:</div>
                <div class="text-center font-bold underline mt-2 uppercase">{{ teacher_name }}</div>
                <div class="text-center mt-[-2px]">Instructor</div>
              </div>

              <div class="border-t-[2px] border-black"></div>

              <div class="mb-2">
                <div class="mb-1 text-center mt-[-2px]">Certified Correct:</div>
                <div class="text-center font-bold underline mt-2">CHARO MAE F. ORBETA</div>
                <div class="text-center mt-[-2px]">Registrar</div>
              </div>

              <div class="flex items-center mt-2">
                <span class="mr-2 whitespace-nowrap">Date Submitted:</span>
                <span class="inline-block border-b border-black h-[0px] w-[140px]"></span>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style>
@media print {
  @page {
    size: 8.5in 13in; /* Long bond paper (folio) */
    margin: 10mm;
  }
}
</style>
<!-- Put this CSS in the same SFC (scoped) or a global stylesheet -->
<style scoped>
/* Tailwind doesn't target <col>, so use plain CSS */
col.col-idx   { width: 28px; }   /* slim number column */
col.col-units { width: 37px; }   /* a bit narrower than sub-columns */
col.col-sub   { width: 50px; }   /* all sub-columns equal width */

/* Let the name column take the remaining space cleanly */
col.col-name  { width: auto; }
</style>



<script setup>
import { onMounted } from 'vue'
import { usePage } from '@inertiajs/vue3'

const page = usePage()
const students = page.props.students
const subject = page.props.subject
const course = page.props.course
const year = page.props.year
const section = page.props.section

onMounted(() => {
  // Auto print then close
  setTimeout(() => window.print(), 1)
  setTimeout(() => window.close(), 500)
})

import { computed } from 'vue'

// Props from controller
defineProps({
  students: Array,
  subject: Object,
  course: String,
  year: String,
  section: String,
  ay_id: String,
  teacher_id: String,
  teacher_name: String,
  ay: String,
})

// Fill remaining rows to 55
const rows = computed(() => {
  const filled = [...(students || [])]
  while (filled.length < 55) {
    filled.push({ name: '', midterm_absences: '', final_absences: '', midterm: '', final: '', final_rating: '', units: '', remarks: '' })
  }
  return filled
})

const asNum = (v) => (v === '' || v == null ? null : Number(v));

const isFailed = (v) => {
  const n = asNum(v);
  if (n == null || Number.isNaN(n)) return null; // no data → no label
  return n > 3.0; // FAIL if > 3.0
};

const passFailLabel = (v) => {
  const failed = isFailed(v);
  if (failed == null) return ' ';      // show blank when no data
  return failed ? 'FAILED' : 'PASSED';
};

const remarkClass = (v) => {
  const failed = isFailed(v);
  return failed ? 'text-red-700 bg-red-100' : ''; // PASSED = no special color
};

</script>
