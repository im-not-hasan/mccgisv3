<template>
  <div class="p-6 bg-whitebg">
    <!-- Info Section -->
    <div class="grid grid-cols-3 gap-6 mb-6">
      <!-- Subject Code -->
      <div class="bg-blue-100 text-mcclightblue rounded-md p-4 shadow-md flex flex-col justify-between">
        <div class="text-xl text-mccblue font-bold">Subject Code: {{ subject }}</div>
        <div class="text-md font-bold">Description here</div>
      </div>

      <!-- Course-Year -->
      <div class="bg-blue-100 text-mcclightblue rounded-md p-4 shadow-md flex flex-col justify-between">
        <div class="text-xl text-mccblue font-bold">Course & Year: {{ course }} - {{ year }}</div>
        <div class="text-md font-bold">Section: {{ section }}</div>
      </div>

      <!-- Semester/Academic Year -->
      <div class="bg-blue-100 text-mcclightblue rounded-md p-4 shadow-md flex flex-col justify-between">
        <div class="text-xl text-mccblue font-bold">
          Semester: {{
            ay.semester === '1'
              ? 'First Semester'
              : ay.semester === '2'
              ? 'Second Semester'
              : ay.semester === '3'
              ? 'Summer'
              : 'Loading...'
          }}
        </div>
        <div class="text-md font-bold">Academic Year: {{ ay.academicyear }}</div>
      </div>
    </div>

    
    <div class="overflow-auto border rounded-lg max-h-[535px]" ref="gradesTable">
      <!-- MIDTERM TABLE -->
      <table  v-if="activeTab === 'midterm'" class="min-w-full border-collapse text-xs" >
        <thead>
          <!-- Header Row -->
          <tr>
            <th rowspan="3" class="bg-gray-300 border p-2">No.</th>
            <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-0 top-0 z-40 w-36">LASTNAME</th>
            <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-20  top-0 z-40 w-36">FIRSTNAME</th>
            <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-40 top-0 z-40 w-36 ">MIDDLENAME</th>

            <!-- Quizzes -->
            <th :colspan="quizCount + 3" class="bg-gray-300 border p-2">
              QUIZZES
              <button
                @click="addQuizColumn"
                class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs"
                title="Add Quiz Column"
              >
                +
              </button>
              <button
                @click="removeQuizColumn"
                class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded text-xs"
                title="Remove Quiz Column"
                :disabled="quizCount <= 1"
              >
                -
              </button>
            </th>

            <!-- Attendance -->
            <th :colspan="attendanceCount + 3" class="bg-gray-300 border p-2">
              ATTENDANCE
              <button
                @click="addAttendanceColumn"
                class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs"
                title="Add Attendance Column"
              >
                +
              </button>
              <button
                @click="removeAttendanceColumn"
                class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded text-xs"
                title="Remove Attendance Column"
                :disabled="attendanceCount <= 1"
              >
                -
              </button>
            </th>

            <th colspan="3" class="bg-gray-300 border p-2">PERFORMANCE</th>
            <th colspan="5" class="bg-gray-300 border p-2">MAJOR EXAM</th>
            <th colspan="3" class="bg-gray-300 border p-2">PRELIM</th>
          </tr>

          <!-- Column Labels -->
          <tr>
            <th
              v-for="n in quizCount"
              :key="'q-label-'+n"
              class="bg-blue-200 border p-1 text-center sticky top-0 z-30"
            >
              Q{{ n }}
            </th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">30%</th>

            <th
              v-for="n in attendanceCount"
              :key="'a-label-'+n"
              class="bg-blue-200 border p-1 text-center sticky top-0 z-30"
            >
              A{{ n }}
            </th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30">100</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30">PRELIM SCORE</th>
            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30">MIDTERM SCORE</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">40%</th>

            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">MIDTERM GRADE</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIVALENT</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">REMARKS</th>
          </tr>

          <!-- HPS Row -->
          <tr>
            <!-- Quizzes HPS inputs -->
            <td
              v-for="(hps, i) in hpsQuizzes"
              :key="'hps-quiz-'+i"
              class="border p-1 bg-blue-200 sticky top-8 z-30"
            >
              <input
                v-model.number="hpsQuizzes[i]"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
              />
            </td>

            <!-- Quizzes total, equiv, 30% cells -->
            <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">
              {{ totalQuizHPS.toFixed(0) }}
            </td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">30</td>

            <!-- Attendance HPS inputs -->
            <td
              v-for="(hps, i) in hpsAttendance"
              :key="'hps-attendance-'+i"
              class="border p-1 bg-blue-200 sticky top-8 z-30"
            >
              <input
                v-model.number="hpsAttendance[i]"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
              />
            </td>

            <!-- Attendance total, equiv, 15% cells -->
            <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">
              {{ totalAttendanceHPS.toFixed(0) }}
            </td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

            <!-- Performance HPS input -->
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30">
              <input
                v-model.number="hpsPerformance"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
              />
            </td>
            <!-- Performance equiv and 15% cells -->
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

            <!-- Major Exam HPS inputs -->
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30">
              <input
                v-model.number="hpsPrelimScore"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
              />
            </td>
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30">
              <input
                v-model.number="hpsMidtermScore"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 sticky top-8 z-30 score-input"
              />
            </td>
            <!-- Major Exam total, equiv, 40% cells -->
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">
              {{ totalExamHPS.toFixed(0) }}
            </td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">40</td>

            <!-- Prelim blank columns -->
            <td colspan="2" class="border p-1 bg-gray-300 sticky top-8 z-30"></td>
            <td colspan="1" class="border p-1 bg-gray-300 sticky top-8 z-30"></td>
          </tr>
        </thead>

        <!-- Inputs -->
        <tbody>
          <tr v-if="loading">
            <td :colspan="totalColumns" class="text-center p-4">Loading student data...</td>
          </tr>
          <tr v-for="(student, index) in students" :key="student.id">
            <!-- No. and student name -->
            <td class="border-none p-1 text-center bg-white">{{ index + 1 }}</td>
            <td class="border-none p-1 sticky left-0 bg-white z-40 w-36">{{ student.lname }}</td>
            <td class="border-none p-1 sticky left-20 bg-white z-40 w-3">{{ student.fname }}</td>
            <td class="border-none p-1 sticky left-40 bg-white z-40 w-36">{{ student.mname }}</td>

            <!-- Quizzes inputs -->
            <td
              v-for="(score, i) in student.quizzes"
              :key="'quiz-'+index+'-'+i"
              class="border p-1 bg-blue-100 "
            >
              <input
                v-model.number="student.quizzes[i]"
                type="number"
                min="0"
                :max="hpsQuizzes[i] || 100"
                class="w-12 border px-1 text-center bg-blue-100 score-input"
              />
            </td>
            <!-- Quizzes totals -->
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.totals.quiz.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.equivs.quiz.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.percents.quiz.toFixed(0) }}
            </td>

            <!-- Attendance inputs -->
            <td
              v-for="(score, i) in student.attendance"
              :key="'att-'+index+'-'+i"
              class="border p-1 bg-blue-100"
            >
              <input
                v-model.number="student.attendance[i]"
                type="number"
                min="0"
                max="1"
                class="w-12 border px-1 text-center bg-blue-100 score-input"
              />
            </td>
            <!-- Attendance totals -->
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.totals.attendance.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.equivs.attendance.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.percents.attendance.toFixed(0) }}
            </td>

            <!-- Performance input and equiv/15% -->
            <td class="border p-1 text-center bg-blue-100">
              <input
                v-model.number="student.performance"
                type="number"
                min="0"
                :max="hpsPerformance"
                class="w-12 border px-1 text-center bg-blue-100 score-input"
              />
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.equivs.performance.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.percents.performance.toFixed(0) }}
            </td>

            <!-- Major exam inputs -->
            <td class="border p-1 text-center bg-blue-100">
              <input
                v-model.number="student.prelimScore"
                type="number"
                min="0"
                :max="hpsPrelimScore"
                class="w-12 border px-1 text-center bg-blue-100 score-input"
              />
            </td>
            <td class="border p-1 text-center bg-blue-100">
              <input
                v-model.number="student.midtermScore"
                type="number"
                min="0"
                :max="hpsMidtermScore"
                class="w-12 border px-1 text-center bg-blue-100 score-input"
              />
            </td>
            <!-- Major exam totals -->
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.totals.exam.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.equivs.exam.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.percents.exam.toFixed(0) }}
            </td>

            <!-- Midterm grade, equivalent, remarks -->
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.midtermGrade.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.equivalent.toFixed(1) }}
            </td>
            <td
              class="border p-1 text-center font-semibold"
              :class="{
                'text-green-700 bg-green-100': student.remarks === 'Passed',
                'text-red-700 bg-red-100': student.remarks === 'Failed'
              }"
            >
              {{ student.remarks }}
            </td>
          </tr>
        </tbody>
      </table>
    <!-- FINALS TABLE -->
           <table v-if="activeTab === 'finals'" class="min-w-full border-collapse text-xs">
        <thead>
          <!-- Header Row -->
          <tr>
            <th rowspan="3" class="bg-gray-300 border p-2">No.</th>
            <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-0 top-0 z-40 w-36">LASTNAME</th>
            <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-20 top-0 z-40 w-36">FIRSTNAME</th>
            <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-40 top-0 z-40 w-36">MIDDLENAME</th>

            <!-- Quizzes -->
            <th :colspan="quizCount + 3" class="bg-gray-300 border p-2">
              QUIZZES
              <button @click="addQuizColumn" class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs" title="Add Quiz Column">+</button>
              <button @click="removeQuizColumn" class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded text-xs" title="Remove Quiz Column" :disabled="quizCount <= 1">-</button>
            </th>

            <!-- Attendance -->
            <th :colspan="attendanceCount + 3" class="bg-gray-300 border p-2">
              ATTENDANCE
              <button @click="addAttendanceColumn" class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs" title="Add Attendance Column">+</button>
              <button @click="removeAttendanceColumn" class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded text-xs" title="Remove Attendance Column" :disabled="attendanceCount <= 1">-</button>
            </th>

            <th colspan="3" class="bg-gray-300 border p-2">PERFORMANCE</th>
            <th colspan="4" class="bg-gray-300 border p-2">FINAL EXAM / SCORE</th>
            <th colspan="3" class="bg-gray-300 border p-2">FINAL SUMMARY</th>
            <th colspan="3" class="bg-gray-300 border p-2">MIDTERM REFERENCE</th>
          </tr>

          <!-- Column Labels -->
          <tr>
            <!-- Quizzes labels -->
            <th v-for="n in quizCount" :key="'fq-label-'+n" class="bg-blue-200 border p-1 text-center sticky top-0 z-30">Q{{ n }}</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">30%</th>

            <!-- Attendance labels -->
            <th v-for="n in attendanceCount" :key="'fa-label-'+n" class="bg-blue-200 border p-1 text-center sticky top-0 z-30">A{{ n }}</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

            <!-- Performance -->
            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30">SCORE</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

            <!-- Final Exam -->
            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30">SCORE</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">40%</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">FINAL SCORE</th>

            <!-- Final Summary -->
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">FINAL GRADE</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIVALENT</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">REMARKS</th>

            <!-- Midterm reference -->
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">MIDTERM GRADE</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIVALENT</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">REMARKS</th>
          </tr>

          <!-- HPS Row -->
          <tr>
            <!-- Quizzes HPS -->
            <td v-for="(hps, i) in hpsQuizzes" :key="'fhps-quiz-'+i" class="border p-1 bg-blue-200 sticky top-8 z-30">
              <input v-model.number="hpsQuizzes[i]" type="number" min="0" class="w-12 border px-1 text-center bg-blue-200 score-input" />
            </td>
            <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">{{ totalQuizHPS.toFixed(0) }}</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">30</td>

            <!-- Attendance HPS -->
            <td v-for="(hps, i) in hpsAttendance" :key="'fhps-att-'+i" class="border p-1 bg-blue-200 sticky top-8 z-30">
              <input v-model.number="hpsAttendance[i]" type="number" min="0" class="w-12 border px-1 text-center bg-blue-200 score-input" />
            </td>
            <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">{{ totalAttendanceHPS.toFixed(0) }}</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

            <!-- Performance HPS -->
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30">
              <input v-model.number="hpsPerformance" type="number" min="0" class="w-12 border px-1 text-center bg-blue-200 score-input" />
            </td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

            <!-- Final Exam HPS -->
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30">
              <input v-model.number="hpsFinalExam" type="number" min="0" class="w-12 border px-1 text-center bg-blue-200 score-input" />
            </td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">40</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30"></td>

            <!-- Final Summary / Midterm blank -->
            <td colspan="3" class="border p-1 bg-gray-300 sticky top-8 z-30"></td>
            <td colspan="3" class="border p-1 bg-gray-300 sticky top-8 z-30"></td>
          </tr>
        </thead>

        <tbody>
          <tr v-if="loading">
            <td :colspan="totalColumns" class="text-center p-4">Loading student data...</td>
          </tr>
          <tr v-for="(student, index) in students" :key="student.id">
            <!-- No. and student name -->
            <td class="border-none p-1 text-center bg-white">{{ index + 1 }}</td>
            <td class="border-none p-1 sticky left-0 bg-white z-40 w-36">{{ student.lname }}</td>
            <td class="border-none p-1 sticky left-20 bg-white z-40 w-36">{{ student.fname }}</td>
            <td class="border-none p-1 sticky left-40 bg-white z-40 w-36">{{ student.mname }}</td>

            <!-- Quizzes -->
            <td v-for="(score, i) in student.quizzes" :key="'fquiz-'+index+'-'+i" class="border p-1 bg-blue-100">
              <input v-model.number="student.quizzes[i]" type="number" min="0" :max="hpsQuizzes[i] || 100" class="w-12 border px-1 text-center bg-blue-100 score-input" />
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>

            <!-- Attendance -->
            <td v-for="(score, i) in student.attendance" :key="'fatt-'+index+'-'+i" class="border p-1 bg-blue-100">
              <input v-model.number="student.attendance[i]" type="number" min="0" max="1" class="w-12 border px-1 text-center bg-blue-100 score-input" />
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>

            <!-- Performance -->
            <td class="border p-1 text-center bg-blue-100">
              <input v-model.number="student.performance" type="number" min="0" :max="hpsPerformance" class="w-12 border px-1 text-center bg-blue-100 score-input" />
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>

            <!-- Final Exam -->
            <td class="border p-1 text-center bg-blue-100">
              <input v-model.number="student.finalExam" type="number" min="0" :max="hpsFinalExam" class="w-12 border px-1 text-center bg-blue-100 score-input" />
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>
            <td class="border p-1 text-center font-semibold bg-gray-200"></td>

            <!-- Final Summary -->
            <td class="border p-1 text-center font-semibold bg-gray-200"> </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"> </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"> </td>

            <!-- Midterm reference -->
            <td class="border p-1 text-center font-semibold bg-gray-200"> </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"> </td>
            <td class="border p-1 text-center font-semibold bg-gray-200"> </td>
          </tr>
        </tbody>
      </table>



    </div>

    <!-- Save / Fullscreen Buttons -->
    <div class="mt-4 text-right">
      <button @click="toggleFullscreen" class="fullscreen-btn mr-5 px-2 py-2">
        ⛶ Fullscreen
      </button>

      <button
        @click="saveGrades"
        :disabled="loading"
        class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded transition"
      >
        Save Grades
      </button>
    </div>

    <!-- Tabs at bottom-left -->
    <div class="absolute bottom-2 left-2 flex space-x-2">
      <button
        @click="activeTab = 'midterm'"
        :class="{
          'bg-gray-300 text-black': activeTab === 'midterm',
          'bg-gray-100 text-gray-600': activeTab !== 'midterm'
        }"
        class="px-3 py-1 rounded border"
      >
        Prelim-Midterm
      </button>
      <button
        @click="activeTab = 'finals'"
        :class="{
          'bg-gray-300 text-black': activeTab === 'finals',
          'bg-gray-100 text-gray-600': activeTab !== 'finals'
        }"
        class="px-3 py-1 rounded border"
      >
        Finals
      </button>
    </div>
  </div>
</template>








































<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { usePage } from '@inertiajs/vue3'
import axios from 'axios'
const activeTab = ref('midterm') // default active tab

const totalColumns = computed(() => {
  // Fixed columns: 4 (No, Lastname, Firstname, Middlename)
  // Quiz columns: quizCount + 3 (Total, Equiv, 30%)
  // Attendance columns: attendanceCount + 3 (Total, Equiv, 15%)
  // Performance columns: 3
  // Major exam columns: 5
  // Prelim columns: 3

  return (
    4 +
    (quizCount.value + 3) +
    (attendanceCount.value + 3) +
    3 +
    5 +
    3
  )
})

// Extract query params
const { url } = usePage()
const queryParams = new URLSearchParams(url.split('?')[1])

const subject = queryParams.get('subject') || ''
const course = queryParams.get('course') || ''
const year = queryParams.get('year') || ''
const section = queryParams.get('section') || ''

// State
const loading = ref(true)
const quizCount = ref(5)
const attendanceCount = ref(10)

const hpsQuizzes = ref(Array(quizCount.value).fill(0))
const hpsAttendance = ref(Array(attendanceCount.value).fill(0))
const hpsPerformance = ref(100)
const hpsPrelimScore = ref(100)
const hpsMidtermScore = ref(100)

const students = ref([])

// Computed total HPS for quizzes and attendance and exams
const totalQuizHPS = computed(() => hpsQuizzes.value.reduce((a, b) => a + (Number(b) || 0), 0))
const totalAttendanceHPS = computed(() => hpsAttendance.value.reduce((a, b) => a + (Number(b) || 0), 0))
const totalExamHPS = computed(() => (Number(hpsPrelimScore.value) || 0) + (Number(hpsMidtermScore.value) || 0))

// Add and Remove columns functions
const addQuizColumn = () => {
  quizCount.value++
  hpsQuizzes.value.push(0)
  students.value.forEach(student => {
    student.quizzes.push('')
  })
}


const addAttendanceColumn = () => {
  attendanceCount.value++
  hpsAttendance.value.push(0)
  students.value.forEach(student => {
    student.attendance.push('')
  })
}

const removeQuizColumn = () => {
  if (quizCount.value > 1) {
    quizCount.value--
    hpsQuizzes.value.pop()
    students.value.forEach(student => {
      student.quizzes.pop()
    })
  }
}

const removeAttendanceColumn = () => {
  if (attendanceCount.value > 1) {
    attendanceCount.value--
    hpsAttendance.value.pop()
    students.value.forEach(student => {
      student.attendance.pop()
    })
  }
}
function cleanDecimals(obj) {
  for (const key in obj) {
    if (Array.isArray(obj[key])) {
      obj[key] = obj[key].map(val => {
        if (val === '' || val === null) return val;
        const num = Number(val);
        return Number.isInteger(num) ? parseInt(num) : num;
      });
    } else if (typeof obj[key] === 'object' && obj[key] !== null) {
      cleanDecimals(obj[key]); // recurse for nested objects
    } else {
      if (obj[key] !== '' && obj[key] !== null) {
        const num = Number(obj[key]);
        if (!isNaN(num)) {
          obj[key] = Number.isInteger(num) ? parseInt(num) : num;
        }
      }
    }
  }
}















const fetchGrades = async () => {
  try {
    // Fetch session info
    const res = await axios.get('/session?source=gradeentry')
    fullname.value = res.data.fullname
    userLevel.value = res.data.level
    username.value = res.data.username
    if (!fullname.value || !userLevel.value || userLevel.value !== 'teacher') {
      window.location.href = '/'
      return
    }
  } catch {
    window.location.href = '/'
    return
  }

  try {
    loading.value = true

    const endpoint = `/grades/${encodeURIComponent(subject)}/${encodeURIComponent(course)}/${encodeURIComponent(year)}/${encodeURIComponent(section)}`
    console.log(`Fetching grades from: ${endpoint}?teacher_username=${username.value}&ay_id=${ay.value.id}`)

    const res = await axios.get(endpoint, {
      params: {
        teacher_username: username.value,
        ay_id: ay.value.id,
      },
    })

    const data = res.data
    cleanDecimals(data.gradesData);
    cleanDecimals(data.gradeComponents);

    // Set quizCount and attendanceCount from backend or fallback
    quizCount.value = data.quizCount ?? 5
    attendanceCount.value = data.attendanceCount ?? 10

    // Set HPS arrays (handle possible missing keys)
    const quizzesHpsObj = data.gradeComponents?.quiz || {}
    hpsQuizzes.value = Array(quizCount.value)
      .fill(0)
      .map((_, idx) => quizzesHpsObj[idx + 1] ?? 0)

    const attendanceHpsObj = data.gradeComponents?.attendance || {}
    hpsAttendance.value = Array(attendanceCount.value)
      .fill(0)
      .map((_, idx) => attendanceHpsObj[idx + 1] ?? 0)

    hpsPerformance.value = data.gradeComponents?.performance?.[1] ?? 0
    hpsPrelimScore.value = data.gradeComponents?.exam?.[1] ?? 0
    hpsMidtermScore.value = data.gradeComponents?.exam?.[2] ?? 0

    // Map students and prefill their scores & summary grades with exact lengths
    students.value = data.students.map((s) => {
      // Fix: gradesData keys use student_id (studid)
      const scores = data.gradesData?.[s.studid] || {
        quizzes: [],
        attendance: [],
        performance: '',
        exams: [],
      }
      // summaryGrades is an object keyed by student_id
      const summary = data.summaryGrades?.[s.studid] || {}

      // Ensure quizzes and attendance arrays are the correct length, fill missing with ''
      const quizzes = Array(quizCount.value)
        .fill('')
        .map((_, i) => (scores.quizzes?.[i] !== undefined ? scores.quizzes[i] : ''))

      const attendance = Array(attendanceCount.value)
        .fill('')
        .map((_, i) => (scores.attendance?.[i] !== undefined ? scores.attendance[i] : ''))

      return {
        ...s,
        quizzes,
        attendance,
        performance: scores.performance ?? '',
        prelimScore: scores.exams?.[0] ?? '',
        midtermScore: scores.exams?.[1] ?? '',

        // Summary grades
        midterm: summary.midterm ?? '',
        final: summary.final ?? '',
        overall: summary.overall ?? '',
        submitted: summary.submitted ?? 0,

        // Calculation placeholders
        totals: { quiz: 0, attendance: 0, exam: 0 },
        equivs: { quiz: 0, attendance: 0, performance: 0, exam: 0 },
        percents: { quiz: 0, attendance: 0, performance: 0, exam: 0 },
        midtermGrade: 0,
        equivalent: 0,
        remarks: '',
      }
    })
  } catch (error) {
    console.error('Failed to fetch grades:', error)
  } finally {
    loading.value = false
  }
}



























// Grade equivalent mapping function
function gradeEquivalent(grade) {
  if (grade > 94.45) return 1.0
  if (grade > 93.45) return 1.1
  if (grade > 92.45) return 1.2
  if (grade > 91.45) return 1.3
  if (grade > 90.45) return 1.4
  if (grade > 89.45) return 1.5
  if (grade > 88.45) return 1.6
  if (grade > 87.45) return 1.7
  if (grade > 86.45) return 1.8
  if (grade > 85.45) return 1.9
  if (grade > 84.45) return 2.0
  if (grade > 83.45) return 2.1
  if (grade > 82.45) return 2.2
  if (grade > 81.45) return 2.3
  if (grade > 80.45) return 2.4
  if (grade > 79.45) return 2.5
  if (grade > 78.45) return 2.6
  if (grade > 77.45) return 2.7
  if (grade > 76.45) return 2.8
  if (grade > 75.45) return 2.9
  if (grade > 74.45) return 3.0
  if (grade > 73.45) return 3.1
  if (grade > 72.45) return 3.2
  if (grade > 71.45) return 3.3
  if (grade > 70.45) return 3.4
  if (grade > 69.45) return 3.5
  return 3.5
}


// Calculation function
const calculateGrades = () => {
  students.value.forEach(student => {
    // QUIZZES
    const totalQuizScore = student.quizzes.reduce((a, b) => a + (Number(b) || 0), 0)
    student.totals.quiz = totalQuizScore
    student.equivs.quiz = totalQuizHPS.value
      ? (totalQuizScore * 40) / totalQuizHPS.value + 60
      : 0
    student.percents.quiz = student.equivs.quiz * 0.3

    // ATTENDANCE
    const totalAttScore = student.attendance.reduce((a, b) => a + (Number(b) || 0), 0)
    student.totals.attendance = totalAttScore
    student.equivs.attendance = totalAttendanceHPS.value
      ? (totalAttScore * 100) / totalAttendanceHPS.value
      : 0
    student.percents.attendance = student.equivs.attendance * 0.15

    // PERFORMANCE
    student.totals.performance = Number(student.performance) || 0
    student.equivs.performance = hpsPerformance.value
      ? (student.totals.performance * 50) / hpsPerformance.value + 50
      : 0
    student.percents.performance = student.equivs.performance * 0.15

    // EXAMS (PRELIM + MIDTERM)
    const examPrelim = Number(student.prelimScore) || 0
    const examMidterm = Number(student.midtermScore) || 0
    const examTotal = examPrelim + examMidterm
    student.totals.exam = examTotal
    student.equivs.exam = totalExamHPS.value
      ? (examTotal * 40) / totalExamHPS.value + 60
      : 0
    student.percents.exam = student.equivs.exam * 0.4

    // MIDTERM GRADE (sum of weighted percentages)
    student.midtermGrade =
      (student.percents.quiz || 0) +
      (student.percents.attendance || 0) +
      (student.percents.performance || 0) +
      (student.percents.exam || 0)

    // EQUIVALENT GRADE — round to 1 decimal place
    student.equivalent = Number(gradeEquivalent(student.midtermGrade).toFixed(1))

    // REMARKS
    student.remarks = student.midtermGrade >= 75 ? 'Passed' : 'Failed'

  })
}













// Watch for changes to recalc grades
watch(
  [students, hpsQuizzes, hpsAttendance, hpsPerformance, hpsPrelimScore, hpsMidtermScore],
  calculateGrades,
  { deep: true, immediate: true }
)


















// --- NEW FUNCTION: Submit All Grades (mark as submitted) ---
const submitGrades = async () => {
  try {
    // Set all students as submitted = 1
    students.value.forEach(student => {
      student.submitted = 1
    })

    // Optionally send submission status to backend immediately
    // You can call saveGrades() or send a dedicated endpoint to mark submission
    await saveGrades()

    alert('Grades submitted successfully!')
  } catch (error) {
    console.error('Failed to submit grades:', error)
    alert('Failed to submit grades.')
  }
}















// Save grades to backend
const saveGrades = async () => {
  try {
    // Prepare gradeComponents array from your current HPS states
    const gradeComponents = [];

    // Quizzes
    hpsQuizzes.value.forEach((hps, idx) => {
      gradeComponents.push({
        component_type: 'quiz',
        component_index: idx + 1,
        hps: Number(hps) || 0,
      });
    });

    // Attendance
    hpsAttendance.value.forEach((hps, idx) => {
      gradeComponents.push({
        component_type: 'attendance',
        component_index: idx + 1,
        hps: Number(hps) || 0,
      });
    });

    // Performance (assumed 1 component)
    gradeComponents.push({
      component_type: 'performance',
      component_index: 1,
      hps: Number(hpsPerformance.value) || 0,
    });

    // Exams: prelim and midterm (2 components)
    gradeComponents.push({
      component_type: 'exam',
      component_index: 1,
      hps: Number(hpsPrelimScore.value) || 0,
    });
    gradeComponents.push({
      component_type: 'exam',
      component_index: 2,
      hps: Number(hpsMidtermScore.value) || 0,
    });

    // Prepare gradesData array (individual scores for each grade component)
    // We will flatten per student each component score using component_type + index
    // Here you must map quizzes, attendance, performance, exams to component ids on backend
    // For now, send scores with component_type and index, backend will map to grade_component_id

    // For this, we build a list of { student_id, component_type, component_index, score }
    const gradesData = [];

    students.value.forEach(student => {
      // Quizzes
      student.quizzes.forEach((score, idx) => {
        gradesData.push({
          student_id: student.studid,
          component_type: 'quiz',
          component_index: idx + 1,
          score: Number(score) || 0,
        });
      });
      // Attendance
      student.attendance.forEach((score, idx) => {
        gradesData.push({
          student_id: student.studid,
          component_type: 'attendance',
          component_index: idx + 1,
          score: Number(score) || 0,
        });
      });
      // Performance
      gradesData.push({
        student_id: student.studid,
        component_type: 'performance',
        component_index: 1,
        score: Number(student.performance) || 0,
      });
      // Exams: prelim and midterm
      gradesData.push({
        student_id: student.studid,
        component_type: 'exam',
        component_index: 1,
        score: Number(student.prelimScore) || 0,
      });
      gradesData.push({
        student_id: student.studid,
        component_type: 'exam',
        component_index: 2,
        score: Number(student.midtermScore) || 0,
      });
    });

    // Prepare gradesSummary array (midterm, final, overall)
    const gradesSummary = students.value.map(student => ({
      student_id: student.studid,
      midterm: Number(student.equivalent) || 0,
      final: Number(student.final) || 0,
      overall: Number(student.overall) || 0,
    }));

    // Send payload to backend
    const saveEndpoint = `/grades/save`;

    await axios.post(saveEndpoint, {
      teacher_username: username.value,
      subject_code: subject,
      course,
      year,
      section,
      ay_id: ay.value.id,
      gradeComponents,
      gradesData,
      gradesSummary,
    });

    alert('Grades saved successfully!');
  } catch (error) {
    console.error('Failed to save grades:', error);
    alert('Failed to save grades.');
  }
};






// Fullscreen Mode

const gradesTable = ref(null)
  
  function toggleFullscreen() {
    if (gradesTable.value) {
      if (!document.fullscreenElement) {
        gradesTable.value.requestFullscreen().catch(err => {
          console.error(`Error attempting fullscreen: ${err.message}`)
        })
      } else {
        document.exitFullscreen()
      }
    }
  }






const ay = ref({
  id: null,
  academicyear: '',
  semester: '',
})
const fullname = ref('')
const userLevel = ref('')
const username = ref('')

const fetchCurrentAY = async () => {
  try {
    const res = await axios.get('/api/active-ay')
    if (res.data) {
      ay.value = res.data
    }
  } catch (error) {
    console.error('Failed to fetch active academic year', error)
  }
}



onMounted(() => {
  fetchCurrentAY()
  if (subject && course && year && section) {
    fetchGrades()
  } else {
    loading.value = false
  }
})

</script>




























<style scoped>
input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

input[type=number] {
  -moz-appearance: textfield;
}

.score-input {
  width: 35px;      /* smaller width */
  font-size: 0.85rem;
  padding: 2px 4px;
  text-align: center;
}

</style>
