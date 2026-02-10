<template>
  <div class="p-6 bg-whitebg">
    
    
    <!-- Info Section -->
    <!-- <div class="mb-3 border rounded bg-blue-100  text-mccblue text-md px-4 py-2 flex flex-wrap gap-x-6 gap-y-1"> -->
    <div class="mb-3 border rounded bg-gray-100 px-4 py-2 flex items-center justify-between text-sm">

      <!-- LEFT: Class Info -->
      <div class="flex flex-wrap gap-x-6 gap-y-1">
        <div><strong>Subject:</strong> {{ subject }}</div>
        <div><strong>Course:</strong> {{ course }} {{ year }} – {{ section }}</div>
      </div>

      <!-- RIGHT: Actions -->
      <div class="flex items-center gap-2 relative">
        <!-- SAVE DROPDOWN -->
        <div class="flex items-center gap-2 relative" ref="toolbarRef">
          <div
            v-if="autosaveStatus !== 'idle'"
            class="flex items-center gap-2 px-3 py-1 rounded shadow text-sm transition"
            :class="{
              'bg-yellow-100 text-yellow-800': autosaveStatus === 'saving',
              'bg-green-100 text-green-700': autosaveStatus === 'saved',
              'bg-red-100 text-red-700': autosaveStatus === 'error',
            }"
          >
            <span v-if="autosaveStatus === 'waiting'">⌛ Waiting to save…</span>
            <span v-if="autosaveStatus === 'saving'">💾 Saving…</span>
            <span v-if="autosaveStatus === 'saved'">✅ Saved</span>
            <span v-if="autosaveStatus === 'error'">⚠ Save failed</span>
          </div>
          <div class="relative">
            <button
              @click="toggleSaveMenu"
              class="excel-btn flex items-center gap-1"
              :class="{
                'ring-2 ring-blue-400 animate-pulse':
                  activeTab === 'midterm'
                    ? !hasComponents.midterm || structureDirty.midterm
                    : !hasComponents.finals || structureDirty.finals
              }"
            >
              Save <span class="text-xs">▼</span>
            </button>


            <div
              v-if="showSaveMenu"
              class="absolute right-0 mt-1 w-36 bg-white border shadow z-50"
            >
              <button
                class="dropdown-item"
                @click="saveGrades"
              >
                Save Midterm
              </button>
              <button
                class="dropdown-item"
                @click="saveFinalGrades"
              >
                Save Finals
              </button>
            </div>
          </div>

          <!-- SUBMIT DROPDOWN -->
          <div class="relative">
            <button @click="toggleSubmitMenu" class="excel-btn flex items-center gap-1">
              Submit <span class="text-xs">▼</span>
            </button>

            <div
              v-if="showSubmitMenu"
              class="absolute right-0 mt-1 w-40 bg-white border shadow z-50"
            >
              <button
                class="dropdown-item"
                @click="submitMidterm"
              >
                Submit Midterm
              </button>
              <button
                class="dropdown-item"
                @click="submitGrades"
              >
                Submit Finals
              </button>
            </div>
          </div>
        </div>
        <!-- DIVIDER -->
        <div class="h-5 w-px bg-gray-300 mx-1"></div>

        <!-- TABS -->
        <button
          @click="activeTab='midterm'"
          :class="{
              'bg-gray-300 text-black': activeTab === 'midterm',
              'bg-gray-100 text-black hover:bg-gray-200 ': activeTab !== 'midterm'
            }"
          class="px-3 py-1 border text-md"
        >
          Midterm
        </button>

        <button
          @click="activeTab='finals'"
          :class="{
              'bg-gray-300 text-black': activeTab === 'finals',
              'bg-gray-100 text-black hover:bg-gray-200 ': activeTab !== 'finals'
            }"
          class="px-3 py-1 border text-md"
        >
          Finals
        </button>

        <!-- HELP -->
        <button
          class="excel-icon-btn border-gray-300"
          title="Help"
          @click="openHelpModal"
        >
          ?
        </button>

        <!-- FULLSCREEN -->
        <button
          class="excel-icon-btn border-gray-300"
          title="Fullscreen"
          @click="toggleFullscreen"
        >
          ⛶
        </button>

      </div>
    </div>


    
    <div class="overflow-auto border rounded-lg max-h-[630px] w-full" ref="gradesTable">
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
                v-if="!isSubmitted"
                @click="addQuizColumn"
                class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs"
                title="Add Quiz Column"
              >
                +
              </button>
              <button
                v-if="!isSubmitted"
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
                v-if="!isSubmitted"
                @click="addAttendanceColumn"
                class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs"
                title="Add Attendance Column"
              >
                +
              </button>
              <button
                v-if="!isSubmitted"
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
              class="bg-blue-200 border p-1 text-center sticky top-0 z-30"  :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }"
            >
              Q{{ n }}
            </th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">30%</th>

            <th
              v-for="n in attendanceCount"
              :key="'a-label-'+n"
              class="bg-blue-200 border p-1 text-center sticky top-0 z-30"  :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }"
            >
              A{{ n }}
            </th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30"  :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }">100</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
            <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }">PRELIM SCORE</th>
            <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }">MIDTERM SCORE</th>
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
              class="border p-1 bg-blue-200 sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }"
            >
              <input
                v-model.number="hpsQuizzes[i]"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
                :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-blue-200': !isSubmitted }"
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
              class="border p-1 bg-blue-200 sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }"
            >
              <input
                v-model.number="hpsAttendance[i]"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
                :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-blue-200': !isSubmitted }"
              />
            </td>

            <!-- Attendance total, equiv, 15% cells -->
            <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">
              {{ totalAttendanceHPS.toFixed(0) }}
            </td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

            <!-- Performance HPS input -->
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }">
              <input
                v-model.number="hpsPerformance"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
                :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-blue-200': !isSubmitted }"
              />
            </td>
            <!-- Performance equiv and 15% cells -->
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
            <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

            <!-- Major Exam HPS inputs -->
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30" :class="{ 'bg-gray-300 ': isSubmitted, 'bg-blue-200': !isSubmitted }"
            >
              <input
                v-model.number="hpsPrelimScore"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 score-input"
                :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-blue-200': !isSubmitted }"
              />
            </td>
            <td class="border p-1 bg-blue-200 text-center sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-blue-200': !isSubmitted }"
            >
              <input
                v-model.number="hpsMidtermScore"
                type="number"
                min="0"
                class="w-12 border px-1 text-center bg-blue-200 sticky top-8 z-30 score-input"
                :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-blue-200': !isSubmitted }"
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
            <td class="border-none p-1 sticky left-40 bg-white z-40 w-36">{{ student.mname }} <span
              v-if="student.is_irregular"
              class=" ml-1 px-1 text-xs bg-red-100 text-red-600 rounded"
            >
              IRREG
            </span></td>

            <!-- Quizzes inputs -->
            <td
              v-for="(score, i) in student.quizzes"
              :key="'quiz-'+index+'-'+i"
              class="border p-1"
              :class="{ 'bg-gray-200': isSubmitted, 'bg-blue-100': !isSubmitted }"
            >
              <input
                v-model.number="student.quizzes[i]"
                type="number"
                min="0"
                :max="hpsQuizzes[i] || 100"
                :disabled="isSubmitted"
                @input="queueAutosave(student, 'quiz', i + 1, 'midterm')"
                :data-section="'midterm'"
                :data-row="index"
                :data-col="i"
                @keydown.enter.prevent="
                  focusNextCell('down', 'midterm', index, i)
                "
                @keydown.shift.enter.prevent="
                  focusNextCell('up', 'midterm', index, i)
                "
                :class="[
                  'w-12 border px-1 text-center score-input',
                  isSubmitted
                    ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                    : 'bg-blue-100',
                  isQuizScoreInvalid(student, i)
                    ? 'bg-red-200 border-red-500 text-red-800'
                    : ''
                ]"
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
              :class="{ 'bg-gray-200': isSubmitted, 'bg-blue-100': !isSubmitted }"
            >
              <input
                v-model.number="student.attendance[i]"
                type="number"
                :disabled="isSubmitted"
                @input="queueAutosave(student, 'attendance', i + 1, 'midterm')"
                :data-section="'midterm'"
                :data-row="index"
                :data-col="quizCount + i" 
                @keydown.enter.prevent="focusNextCell('down', 'midterm', index, quizCount + i)"
                @keydown.shift.enter.prevent="focusNextCell('up', 'midterm', index, quizCount + i)"
                :class="[
                  'w-12 border px-1 text-center score-input',
                  isSubmitted
                    ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                    : 'bg-blue-100',
                  isAttendanceScoreInvalid(student, i)
                    ? 'bg-red-200 border-red-500 text-red-800'
                    : ''
                ]"
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
            <td class="border p-1 text-center bg-blue-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-blue-100': !isSubmitted }">
              <input
                v-model.number="student.performance"
                type="number"
                min="0"
                :max="hpsPerformance"
                :disabled="isSubmitted"
                @input="queueAutosave(student, 'performance', 1, 'midterm')"
                :data-section="'midterm'"
                :data-row="index"
                :data-col="quizCount + attendanceCount"
                @keydown.enter.prevent="focusNextCell('down', 'midterm', index, quizCount + attendanceCount)"
                @keydown.shift.enter.prevent="focusNextCell('up', 'midterm', index, quizCount + attendanceCount)"
                :class="[
                  'w-12 border px-1 text-center score-input',
                  isSubmitted
                    ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                    : 'bg-blue-100',
                  isPerformanceScoreInvalid(student)
                    ? 'bg-red-200 border-red-500 text-red-800'
                    : ''
                ]"
              />
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.equivs.performance.toFixed(0) }}
            </td>
            <td class="border p-1 text-center font-semibold bg-gray-200">
              {{ student.percents.performance.toFixed(0) }}
            </td>

            <!-- Major exam inputs -->
            <td class="border p-1 text-center bg-blue-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-blue-100': !isSubmitted }">
              <input
                v-model.number="student.prelimScore"
                type="number"
                min="0"
                :max="hpsPrelimScore"
                :disabled="isSubmitted"
                @input="queueAutosave(student, 'exam', 1, 'midterm')"
                :data-section="'midterm'"
                :data-row="index"
                :data-col="quizCount + attendanceCount + 1"
                @keydown.enter.prevent="focusNextCell('down', 'midterm', index, quizCount + attendanceCount + 1)"
                @keydown.shift.enter.prevent="focusNextCell('up', 'midterm', index, quizCount + attendanceCount + 1)"
                :class="[
                  'w-12 border px-1 text-center score-input',
                  isSubmitted
                    ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                    : 'bg-blue-100',
                  isPrelimScoreInvalid(student)
                    ? 'bg-red-200 border-red-500 text-red-800'
                    : ''
                ]"
              />
            </td>
            <td class="border p-1 text-center bg-blue-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-blue-100': !isSubmitted }">
              <input
                v-model.number="student.midtermScore"
                type="number"
                min="0"
                :max="hpsMidtermScore"
                :disabled="isSubmitted"
                @input="queueAutosave(student, 'exam', 2, 'midterm')"
                :data-section="'midterm'"
                :data-row="index"
                :data-col="quizCount + attendanceCount + 2"
                @keydown.enter.prevent="focusNextCell('down', 'midterm', index, quizCount + attendanceCount + 2)"
                @keydown.shift.enter.prevent="focusNextCell('up', 'midterm', index, quizCount + attendanceCount + 2)"
                :class="[
                  'w-12 border px-1 text-center score-input',
                  isSubmitted
                    ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                    : 'bg-blue-100',
                  isMidtermScoreInvalid(student)
                    ? 'bg-red-200 border-red-500 text-red-800'
                    : ''
                ]"
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





      <!------------ FINALS TABLE ------------>
      <table v-if="activeTab === 'finals'" class="min-w-full border-collapse text-xs">
      <thead>
        <tr>
          <th rowspan="3" class="bg-gray-300 border p-2">No.</th>
          <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-0 top-0 z-40 w-36">LASTNAME</th>
          <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-20 top-0 z-40 w-36">FIRSTNAME</th>
          <th rowspan="3" class="bg-gray-300 border-none p-2 sticky left-40 top-0 z-40 w-36">MIDDLENAME</th>

          <!-- Quizzes -->
          <th :colspan="finalQuizCount + 3" class="bg-gray-300 border p-2">
            QUIZZES
            <button v-if="!isSubmitted" @click="addFinalQuizColumn" class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs" title="Add Quiz Column">+</button>
            <button v-if="!isSubmitted" @click="removeFinalQuizColumn" class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded text-xs" title="Remove Quiz Column" :disabled="finalQuizCount <= 1">-</button>
          </th>

          <!-- Attendance -->
          <th :colspan="finalAttendanceCount + 3" class="bg-gray-300 border p-2">
            ATTENDANCE
            <button v-if="!isSubmitted" @click="addFinalAttendanceColumn" class="ml-2 bg-green-500 text-white px-2 py-0.5 rounded text-xs" title="Add Attendance Column">+</button>
            <button v-if="!isSubmitted" @click="removeFinalAttendanceColumn" class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded text-xs" title="Remove Attendance Column" :disabled="finalAttendanceCount <= 1">-</button>
          </th>

          <th colspan="3" class="bg-gray-300 border p-2">PERFORMANCE</th>
          <th colspan="3" class="bg-gray-300 border p-2">MAJOR EXAM</th>
          <th colspan="3" class="bg-gray-300 border p-2">FINAL SUMMARY</th>
          <th colspan="4" class="bg-gray-300 border p-2">MIDTERM REFERENCE</th>
        </tr>

        <!-- Column Labels -->
        <tr>
          <th v-for="n in finalQuizCount" :key="'fq-label-'+n" class="bg-blue-200 border p-1 text-center sticky top-0 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">Q{{ n }}</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">30%</th>

          <th v-for="n in finalAttendanceCount" :key="'fa-label-'+n" class="bg-blue-200 border p-1 text-center sticky top-0 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">A{{ n }}</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">TOTAL</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

          <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">100</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">15%</th>

          <th class="bg-blue-200 border p-1 text-center sticky top-0 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">FINAL SCORE</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIV</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">40%</th>

          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">FINAL GRADE</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIVALENT</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">REMARKS</th>

          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">MIDTERM GRADE</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">FINAL RATING</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">EQUIVALENT</th>
          <th class="bg-gray-300 border p-1 text-center sticky top-0 z-30">REMARKS</th>
        </tr>

        <!-- HPS Row -->
        <tr>
          <td v-for="(hps, i) in hpsFinalQuizzes" :key="'fhps-quiz-'+i" class="border p-1 bg-orange-200 sticky top-8 z-30"  :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">
            <input v-model.number="hpsFinalQuizzes[i]" type="number" min="0" class="w-12 border px-1 text-center bg-blue-200 score-input" :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-orange-200': !isSubmitted }"/>
          </td>
          <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">{{ totalFinalQuizHPS.toFixed(0) }}</td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">30</td>

          <td v-for="(hps, i) in hpsFinalAttendance" :key="'fhps-att-'+i" class="border p-1 bg-orange-200 sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">
            <input v-model.number="hpsFinalAttendance[i]" type="number" min="0" class="w-12 border px-1 text-center bg-blue-200 score-input" :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-orange-200': !isSubmitted }"/>
          </td>
          <td class="border p-1 bg-gray-300 text-center font-semibold sticky top-8 z-30">{{ totalFinalAttendanceHPS.toFixed(0) }}</td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

          <td class="border p-1 bg-orange-200 text-center sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">
            <input v-model.number="hpsFinalPerformance" type="number" min="0" class="w-12 border px-1 text-center bg-orange-200 score-input" :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-orange-200': !isSubmitted }"/>
          </td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">15</td>

          <td class="border p-1 bg-orange-200 text-center sticky top-8 z-30" :class="{ 'bg-gray-300': isSubmitted, 'bg-orange-200': !isSubmitted }">
            <input v-model.number="hpsFinalExam" type="number" min="0" class="w-12 border px-1 text-center bg-orange-200 score-input" :disabled="isSubmitted"
                :class="{ 'bg-gray-300 cursor-not-allowed border-none focus:border-none': isSubmitted, 'bg-orange-200': !isSubmitted }"/>
          </td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">100</td>
          <td class="border p-1 bg-gray-300 text-center sticky top-8 z-30">40</td>

          <td colspan="7" class="border p-1 bg-gray-300 sticky top-8 z-30"></td>
        </tr>
      </thead>

      <tbody>
        <tr v-if="loading">
          <td :colspan="totalColumns" class="text-center p-4">Loading student data...</td>
        </tr>

        <tr v-for="(student, index) in finalStudents" :key="student.id">
          <!-- Student Info -->
          <td class="border-none p-1 text-center bg-white">{{ index + 1 }}</td>
          <td class="border-none p-1 sticky left-0 bg-white z-40 w-36">{{ student.lname }}</td>
          <td class="border-none p-1 sticky left-20 bg-white z-40 w-36">{{ student.fname }}</td>
          <td class="border-none p-1 sticky left-40 bg-white z-40 w-36">{{ student.mname }}</td>

          <!-- Quizzes -->
          <td v-for="(score, i) in student.quizzes" :key="'fquiz-'+index+'-'+i" class="border p-1 bg-orange-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-orange-100': !isSubmitted }">
            <input
              v-model.number="student.quizzes[i]"
              type="number"
              min="0"
              :max="hpsFinalQuizzes[i] || 100"
              :disabled="isSubmitted"
              @input="queueAutosave(student, 'quiz', i + 1, 'final')"
              :data-section="'finals'"
              :data-row="index"
              :data-col="i"
              @keydown.enter.prevent="focusNextCell('down', 'finals', index, i)"
              @keydown.shift.enter.prevent="focusNextCell('up', 'finals', index, i)"
              :class="[
                'w-12 border px-1 text-center score-input',
                isSubmitted
                  ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                  : 'bg-orange-100',
                isFinalQuizScoreInvalid(student, i)
                  ? 'bg-red-200 border-red-500 text-red-800'
                  : ''
              ]"
            />
          </td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.totals.quiz.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.equivs.quiz.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.percents.quiz.toFixed(0) }}</td>

          <!-- Attendance -->
          <td v-for="(score, i) in student.attendance" :key="'fatt-'+index+'-'+i" class="border p-1 bg-orange-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-orange-100': !isSubmitted }">
            <input
              v-model.number="student.attendance[i]"
              type="number"
              min="0"
              :max="hpsFinalAttendance[i] || 1"
              :disabled="isSubmitted"
              @input="queueAutosave(student, 'attendance', i + 1, 'final')"
              :data-section="'finals'"
              :data-row="index"
              :data-col="finalQuizCount + i"
              @keydown.enter.prevent="focusNextCell('down', 'finals', index, finalQuizCount + i)"
              @keydown.shift.enter.prevent="focusNextCell('up', 'finals', index, finalQuizCount + i)"
              :class="[
                'w-12 border px-1 text-center score-input',
                isSubmitted
                  ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                  : 'bg-orange-100',
                isFinalAttendanceScoreInvalid(student, i)
                  ? 'bg-red-200 border-red-500 text-red-800'
                  : ''
              ]"
            />
          </td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.totals.attendance.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.equivs.attendance.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.percents.attendance.toFixed(0) }}</td>

          <!-- Performance -->
          <td class="border p-1 text-center bg-orange-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-orange-100': !isSubmitted }">
            <input
              v-model.number="student.performance"
              type="number"
              min="0"
              :max="hpsFinalPerformance"
              :disabled="isSubmitted"
              @input="queueAutosave(student, 'performance', 1, 'final')"
              :data-section="'finals'"
              :data-row="index"
              :data-col="finalQuizCount + finalAttendanceCount"
              @keydown.enter.prevent="focusNextCell('down', 'finals', index, finalQuizCount + finalAttendanceCount)"
              @keydown.shift.enter.prevent="focusNextCell('up', 'finals', index, finalQuizCount + finalAttendanceCount)"
              :class="[
                'w-12 border px-1 text-center score-input',
                isSubmitted
                  ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                  : 'bg-orange-100',
                isFinalPerformanceScoreInvalid(student)
                  ? 'bg-red-200 border-red-500 text-red-800'
                  : ''
              ]"
            />
          </td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.equivs.performance.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.percents.performance.toFixed(0) }}</td>

          <!-- Final Exam -->
          <td class="border p-1 text-center bg-orange-100" :class="{ 'bg-gray-200': isSubmitted, 'bg-orange-100': !isSubmitted }">
            <input
              v-model.number="student.finalExam"
              type="number"
              min="0"
              :max="hpsFinalExam"
              :disabled="isSubmitted"
              @input="queueAutosave(student, 'exam', 1, 'final')"
              :data-section="'finals'"
              :data-row="index"
              :data-col="finalQuizCount + finalAttendanceCount + 1"
              @keydown.enter.prevent="focusNextCell('down', 'finals', index, finalQuizCount + finalAttendanceCount + 1)"
              @keydown.shift.enter.prevent="focusNextCell('up', 'finals', index, finalQuizCount + finalAttendanceCount + 1)"  
              :class="[
                'w-12 border px-1 text-center score-input',
                isSubmitted
                  ? 'bg-gray-200 cursor-not-allowed border-none focus:border-none'
                  : 'bg-orange-100',
                isFinalExamScoreInvalid(student)
                  ? 'bg-red-200 border-red-500 text-red-800'
                  : ''
              ]"
            />
          </td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.equivs.exam.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.percents.exam.toFixed(0) }}</td>

          <!-- Final Summary -->
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.finalGrade.toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ student.equivalent.toFixed(1) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200"
              :class="{
                'text-green-700 bg-green-100': student.remarks === 'Passed',
                'text-red-700 bg-red-100': student.remarks === 'Failed'
              }">
            {{ student.remarks }}
          </td>

          <!-- Midterm Reference -->
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ getMidtermGrade(student.studid).toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ (((getMidtermGrade(student.studid) * 0.3) + (student.finalGrade * 0.7))).toFixed(0) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200">{{ ((gradeEquivalent(getMidtermGrade(student.studid)) * 0.3) + (gradeEquivalent(student.finalGrade) * 0.7)).toFixed(1) }}</td>
          <td class="border p-1 text-center font-semibold bg-gray-200"
              :class="{
                'text-green-700 bg-green-100': (((getMidtermGrade(student.studid) * 0.3) + (student.finalGrade * 0.7))) >= 75,
                'text-red-700 bg-red-100': (((getMidtermGrade(student.studid) * 0.3) + (student.finalGrade * 0.7))) < 75
              }">
            {{ (((getMidtermGrade(student.studid) * 0.3) + (student.finalGrade * 0.7))) >= 75 ? 'Passed' : 'Failed' }}
          </td>
        </tr>
      </tbody>
    </table>
    </div>
  </div>
</template>








































<script setup>
import { ref, computed, onMounted, watch, onBeforeUnmount, reactive } from 'vue'
import { usePage } from '@inertiajs/vue3'
import Swal from 'sweetalert2'
import axios from 'axios'
const activeTab = ref('midterm') // default active tab
const isSubmitted = ref(false)
const autosaveEnabled = ref(false)
const hasComponents = reactive({
  midterm: false,
  finals: false,
})
const structureDirty = reactive({
  midterm: false,
  finals: false,
})

const autosaveStatus = ref('idle')  // 'idle' | 'saving' | 'saved' | 'error'
const hasShownSaveHint = ref(false)

const autosaveBuffer = ref(new Map())
// key: `${term}-${student_id}-${component_type}-${component_index}`
// value: payload object
const autosaveTimer = ref(null)

const showSaveMenu = ref(false)
const showSubmitMenu = ref(false)
const toolbarRef = ref(null)

const closeMenus = () => {
  showSaveMenu.value = false
  showSubmitMenu.value = false
}

const handleClickOutside = (e) => {
  if (!toolbarRef.value) return

  if (!toolbarRef.value.contains(e.target)) {
    closeMenus()
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
const toggleSaveMenu = () => {
  showSaveMenu.value = !showSaveMenu.value
  showSubmitMenu.value = false
}

const toggleSubmitMenu = () => {
  showSubmitMenu.value = !showSubmitMenu.value
  showSaveMenu.value = false
}


const toggleAutosave = async (e) => {
  const wantsToEnable = e.target.checked

  // 🚫 Trying to enable autosave with no components yet
  if (wantsToEnable && !hasGradeComponents.value) {
    await Swal.fire({
      icon: 'info',
      title: 'Autosave not ready yet',
      html: `
        <p class="text-sm text-gray-700">
          Autosave requires existing grade components.<br><br>
          Please click <b>Save Midterm Grades</b> or <b>Save Final Grades</b>
          at least once to initialize the grading structure.
        </p>
      `,
      confirmButtonColor: '#2563eb',
    })

    autosaveEnabled.value = false
    return
  }

  autosaveEnabled.value = wantsToEnable
}

const queueAutosave = (student, componentType, componentIndex, term) => {
  const currentTerm = term === 'final' ? 'finals' : 'midterm'

  // ⛔ Autosave blocked until structure exists for THIS term
  if (!hasComponents[currentTerm] || structureDirty[currentTerm] || isSubmitted.value) {

    // 👀 This is NOT the debounce waiting — this is structural
    autosaveStatus.value = 'idle'

    if (!hasShownSaveHint[currentTerm]) {
      hasShownSaveHint[currentTerm] = true

      Swal.fire({
        toast: false,
        position: 'center',
        icon: 'info',
        title: `Autosave for ${currentTerm} will start after you click Save`,
        text: 'Please set number of quizzes and attendances, enter their highest scores, and then click Save to enable autosave.',
        showConfirmButton: true,
      })
    }

    return
  }




  // 1️⃣ Build a unique key per cell
  const key = `${term}-${student.studid}-${componentType}-${componentIndex}`

  // 2️⃣ Store / overwrite latest value in buffer
  autosaveBuffer.value.set(key, {
    teacher_username: username.value,
    subject_code: subject,
    course,
    year,
    section,
    ay_id: ay.value.id,
    term,
    student_id: student.studid,
    component_type: componentType,
    component_index: componentIndex,
    score:
      componentType === 'quiz'
        ? student.quizzes?.[componentIndex - 1]
        : componentType === 'attendance'
        ? student.attendance?.[componentIndex - 1]
        : componentType === 'performance'
        ? student.performance
        : componentType === 'exam'
        ? term === 'midterm'
          ? componentIndex === 1
            ? student.prelimScore
            : student.midtermScore
          : student.finalExam
        : null,
  })

  // 3️⃣ User has pending edits → waiting
  autosaveStatus.value = 'waiting'

  // 4️⃣ Reset debounce timer
  if (autosaveTimer.value) {
    clearTimeout(autosaveTimer.value)
  }

  autosaveTimer.value = setTimeout(runAutosave, 5000)
}
const runAutosave = async () => {
  if (autosaveBuffer.value.size === 0) return

  autosaveStatus.value = 'saving'

  try {
    // Convert Map → Array
    const payload = Array.from(autosaveBuffer.value.values())

    await axios.post('/grades/autosave', {
      teacher_username: username.value,
      subject_code: subject,
      course,
      year,
      section,
      ay_id: ay.value.id,

      changes: payload,
    })


    autosaveBuffer.value.clear()
    autosaveStatus.value = 'saved'

    setTimeout(() => {
      if (autosaveStatus.value === 'saved') {
        autosaveStatus.value = 'idle'
      }
    }, 2000)

  } catch (err) {
    console.error('Autosave failed', err)
    autosaveStatus.value = 'error'
  }
}


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


// ===== FINALS VARIABLES =====
const finalQuizCount = ref(5)
const finalAttendanceCount = ref(10)
const finalStudents = ref([])
const hpsFinalQuizzes = ref(Array(finalQuizCount.value).fill(0))
const hpsFinalAttendance = ref(Array(finalAttendanceCount.value).fill(0))
const hpsFinalPerformance = ref(100)
const hpsFinalExam = ref(100)

const totalFinalQuizHPS = computed(() =>
  hpsFinalQuizzes.value.reduce((a, b) => a + (Number(b) || 0), 0)
)
const totalFinalAttendanceHPS = computed(() =>
  hpsFinalAttendance.value.reduce((a, b) => a + (Number(b) || 0), 0)
)

const focusNextCell = (direction, section, rowIndex, colIndex) => {
  //console.log('focusNextCell called with:', { direction, section, rowIndex, colIndex })

  const list = section === 'midterm' ? students.value : finalStudents.value
  if (!list || !list.length) return

  const maxRow = list.length - 1
  let targetRow = direction === 'down' ? rowIndex + 1 : rowIndex - 1

  if (targetRow < 0 || targetRow > maxRow) {
    //console.log('hit boundary, nothing to focus')
    return
  }

  const selector = `input[data-section="${section}"][data-row="${targetRow}"][data-col="${colIndex}"]`
  //console.log('selector:', selector)

  const el = document.querySelector(selector)
  if (el) {
    el.focus()
    if (typeof el.select === 'function') el.select()
  } else {
    //console.log('no element found for selector')
  }
}

const isScoreExceeding = (score, hps) => {
  const s = Number(score)
  const h = Number(hps)
  if (!h || Number.isNaN(h)) return false
  if (score === '' || score === null || score === undefined) return false
  return !Number.isNaN(s) && s > h
}

// 🔴 cell invalid helpers (also used for red highlight later)
const isQuizScoreInvalid = (student, index) =>
  isScoreExceeding(student.quizzes?.[index], hpsQuizzes.value[index])

const isAttendanceScoreInvalid = (student, index) =>
  isScoreExceeding(student.attendance?.[index], hpsAttendance.value[index])

const isPerformanceScoreInvalid = (student) =>
  isScoreExceeding(student.performance, hpsPerformance.value)

const isPrelimScoreInvalid = (student) =>
  isScoreExceeding(student.prelimScore, hpsPrelimScore.value)

const isMidtermScoreInvalid = (student) =>
  isScoreExceeding(student.midtermScore, hpsMidtermScore.value)

// Finals
const isFinalQuizScoreInvalid = (student, index) =>
  isScoreExceeding(student.quizzes?.[index], hpsFinalQuizzes.value[index])

const isFinalAttendanceScoreInvalid = (student, index) =>
  isScoreExceeding(student.attendance?.[index], hpsFinalAttendance.value[index])

const isFinalPerformanceScoreInvalid = (student) =>
  isScoreExceeding(student.performance, hpsFinalPerformance.value)

const isFinalExamScoreInvalid = (student) =>
  isScoreExceeding(student.finalExam, hpsFinalExam.value)

const hasMidtermScoresExceedingHps = () => {
  for (const student of students.value) {
    for (let i = 0; i < quizCount.value; i++) {
      if (isQuizScoreInvalid(student, i)) return true
    }
    for (let i = 0; i < attendanceCount.value; i++) {
      if (isAttendanceScoreInvalid(student, i)) return true
    }
    if (isPerformanceScoreInvalid(student)) return true
    if (isPrelimScoreInvalid(student)) return true
    if (isMidtermScoreInvalid(student)) return true
  }
  return false
}

const hasFinalScoresExceedingHps = () => {
  for (const student of finalStudents.value) {
    for (let i = 0; i < finalQuizCount.value; i++) {
      if (isFinalQuizScoreInvalid(student, i)) return true
    }
    for (let i = 0; i < finalAttendanceCount.value; i++) {
      if (isFinalAttendanceScoreInvalid(student, i)) return true
    }
    if (isFinalPerformanceScoreInvalid(student)) return true
    if (isFinalExamScoreInvalid(student)) return true
  }
  return false
}

async function confirmColumnDeletion({ typeLabel, columnLabel, hasHps, hasScores }) {
  if (!hasHps && !hasScores) return true

  const parts = []
  if (hasHps) parts.push('an HPS value')
  if (hasScores) parts.push('scores entered for at least one student')
  const details = parts.join(' and ')

  const first = await Swal.fire({
    title: `Delete ${columnLabel}?`,
    html: `
      <p class="text-sm text-gray-700">
        This ${typeLabel.toLowerCase()} already has <b>${details}</b>.<br>
        Deleting it will permanently remove all data in this column.
      </p>
      <p class="mt-2 text-xs text-red-600">
        This action cannot be undone.
      </p>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete column',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#ef4444',
    cancelButtonColor: '#6b7280',
    reverseButtons: true,
  })

  if (!first.isConfirmed) return false

  const second = await Swal.fire({
    title: 'Are you absolutely sure?',
    html: `
      <p class="text-sm text-gray-700">
        All scores and the HPS for <b>${columnLabel}</b> will be lost for every student.
      </p>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete anyway',
    cancelButtonText: 'Go back',
    confirmButtonColor: '#b91c1c',
    cancelButtonColor: '#6b7280',
    reverseButtons: true,
  })

  return second.isConfirmed
}

// Add and Remove columns functions
const addQuizColumn = () => {
  quizCount.value++
  hpsQuizzes.value.push(0)
  students.value.forEach(student => {
    student.quizzes.push('')
  })

  structureDirty.midterm = true
  hasComponents.midterm = false
}


const addAttendanceColumn = () => {
  attendanceCount.value++
  hpsAttendance.value.push(0)
  students.value.forEach(student => {
    student.attendance.push('')
  })

  structureDirty.midterm = true
  hasComponents.midterm = false
}

const removeQuizColumn = async () => {
  if (quizCount.value <= 1) return

  const idx = quizCount.value - 1
  const hasHps = !!(Number(hpsQuizzes.value[idx]) || 0)
  const hasScores = students.value.some(s => {
    const v = s.quizzes?.[idx]
    return v !== '' && v !== null && v !== undefined && !Number.isNaN(Number(v))
  })

  const ok = await confirmColumnDeletion({
    typeLabel: 'Quiz column',
    columnLabel: `Q${quizCount.value}`,
    hasHps,
    hasScores,
  })
  if (!ok) return

  quizCount.value--
  hpsQuizzes.value.pop()
  students.value.forEach(s => {
    s.quizzes.pop()
  })

  structureDirty.midterm = true
  hasComponents.midterm = false
}


const removeAttendanceColumn = async () => {
  if (attendanceCount.value <= 1) return

  const idx = attendanceCount.value - 1
  const hasHps = !!(Number(hpsAttendance.value[idx]) || 0)
  const hasScores = students.value.some(s => {
    const v = s.attendance?.[idx]
    return v !== '' && v !== null && v !== undefined && !Number.isNaN(Number(v))
  })

  const ok = await confirmColumnDeletion({
    typeLabel: 'Attendance column',
    columnLabel: `A${attendanceCount.value}`,
    hasHps,
    hasScores,
  })
  if (!ok) return

  attendanceCount.value--
  hpsAttendance.value.pop()
  students.value.forEach(s => {
    s.attendance.pop()
  })

  structureDirty.midterm = true
  hasComponents.midterm = false
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

const addFinalQuizColumn = () => {
  finalQuizCount.value++
  hpsFinalQuizzes.value.push(0)
  finalStudents.value.forEach(student => {
    student.quizzes.push('')
  })

  structureDirty.finals = true
  hasComponents.finals = false
}


const addFinalAttendanceColumn = () => {
  finalAttendanceCount.value++
  hpsFinalAttendance.value.push(0)
  finalStudents.value.forEach(student => {
    student.attendance.push('')
  })

  structureDirty.finals = true
  hasComponents.finals = false
}

const removeFinalQuizColumn = async () => {
  if (finalQuizCount.value <= 1) return

  const idx = finalQuizCount.value - 1
  const hasHps = !!(Number(hpsFinalQuizzes.value[idx]) || 0)
  const hasScores = finalStudents.value.some(s => {
    const v = s.quizzes?.[idx]
    return v !== '' && v !== null && v !== undefined && !Number.isNaN(Number(v))
  })

  const ok = await confirmColumnDeletion({
    typeLabel: 'Final quiz column',
    columnLabel: `Q${finalQuizCount.value}`,
    hasHps,
    hasScores,
  })
  if (!ok) return

  finalQuizCount.value--
  hpsFinalQuizzes.value.pop()
  finalStudents.value.forEach(s => {
    s.quizzes.pop()
  })

  structureDirty.finals = true
  hasComponents.finals = false
}


const removeFinalAttendanceColumn = async () => {
  if (finalAttendanceCount.value <= 1) return

  const idx = finalAttendanceCount.value - 1
  const hasHps = !!(Number(hpsFinalAttendance.value[idx]) || 0)
  const hasScores = finalStudents.value.some(s => {
    const v = s.attendance?.[idx]
    return v !== '' && v !== null && v !== undefined && !Number.isNaN(Number(v))
  })

  const ok = await confirmColumnDeletion({
    typeLabel: 'Final attendance column',
    columnLabel: `A${finalAttendanceCount.value}`,
    hasHps,
    hasScores,
  })
  if (!ok) return

  finalAttendanceCount.value--
  hpsFinalAttendance.value.pop()
  finalStudents.value.forEach(s => {
    s.attendance.pop()
  })

  structureDirty.finals = true
  hasComponents.finals = false
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



    const endpoint = `/grades/${encodeURIComponent(subject)}/${encodeURIComponent(course)}/${encodeURIComponent(year)}/${encodeURIComponent(section)}`
    //console.log(`Fetching grades from: ${endpoint}?teacher_username=${username.value}&ay_id=${ay.value.id}`)

    const res = await axios.get(endpoint, {
      params: {
        teacher_username: username.value,
        ay_id: ay.value.id,
      },
    })

    isSubmitted.value = Boolean(res.data.submitted)
    hasComponents.midterm = Boolean(res.data.hasComponents)
    autosaveEnabled.value = hasComponents.midterm
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

  }
}




const fetchFinalGrades = async () => {
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


    const endpoint = `/finalgrades/${encodeURIComponent(subject)}/${encodeURIComponent(course)}/${encodeURIComponent(year)}/${encodeURIComponent(section)}`
    //console.log(`Fetching FINAL grades from: ${endpoint}?teacher_username=${username.value}&ay_id=${ay.value.id}`)

    const res = await axios.get(endpoint, {
      params: {
        teacher_username: username.value,
        ay_id: ay.value.id,
      },
    })
    hasComponents.finals = Object.keys(res.data.gradeComponents || {}).length > 0
    const data = res.data
    cleanDecimals(data.gradesData)
    cleanDecimals(data.gradeComponents)

    // Set counts
    finalQuizCount.value = data.quizCount ?? 5
    finalAttendanceCount.value = data.attendanceCount ?? 10

    // HPS
    const finalQuizHpsObj = data.gradeComponents?.quiz || {}
    hpsFinalQuizzes.value = Array(finalQuizCount.value)
      .fill(0)
      .map((_, idx) => finalQuizHpsObj[idx + 1] ?? 0)

    const finalAttHpsObj = data.gradeComponents?.attendance || {}
    hpsFinalAttendance.value = Array(finalAttendanceCount.value)
      .fill(0)
      .map((_, idx) => finalAttHpsObj[idx + 1] ?? 0)

    hpsFinalPerformance.value = data.gradeComponents?.performance?.[1] ?? 0
    hpsFinalExam.value = data.gradeComponents?.exam?.[1] ?? 0

    // Students + scores
    finalStudents.value = data.students.map(s => {
      const scores = data.gradesData?.[s.studid] || {
        quizzes: [],
        attendance: [],
        performance: '',
        exams: [],
      }

      const quizzes = Array(finalQuizCount.value)
        .fill('')
        .map((_, i) => (scores.quizzes?.[i] ?? ''))

      const attendance = Array(finalAttendanceCount.value)
        .fill('')
        .map((_, i) => (scores.attendance?.[i] ?? ''))

      return {
        ...s,
        quizzes,
        attendance,
        performance: scores.performance ?? '',
        finalExam: scores.exams?.[0] ?? '',
        
        // placeholders for computed data
        totals: { quiz: 0, attendance: 0, exam: 0 },
        equivs: { quiz: 0, attendance: 0, performance: 0, exam: 0 },
        percents: { quiz: 0, attendance: 0, performance: 0, exam: 0 },
        finalGrade: 0,
        equivalent: 0,
        remarks: 'Failed',
      }
    })
  } catch (err) {
    console.error('Failed to fetch final grades:', err)
  } finally {

  }
}
function getMidtermGrade(studid) {
  const mid = students.value.find(s => s.studid === studid)
  return mid ? mid.midtermGrade || 0 : 0
}
watch(activeTab, () => {
  autosaveStatus.value = 'idle'
})























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
const calculateFinalGrades = () => {
  finalStudents.value.forEach(student => {
    // QUIZZES
    const totalQuiz = student.quizzes.reduce((a, b) => a + (Number(b) || 0), 0)
    student.totals.quiz = totalQuiz
    student.equivs.quiz = totalFinalQuizHPS.value
      ? (totalQuiz * 40) / totalFinalQuizHPS.value + 60
      : 0
    student.percents.quiz = student.equivs.quiz * 0.3

    // ATTENDANCE
    const totalAtt = student.attendance.reduce((a, b) => a + (Number(b) || 0), 0)
    student.totals.attendance = totalAtt
    student.equivs.attendance = totalFinalAttendanceHPS.value
      ? (totalAtt * 100) / totalFinalAttendanceHPS.value
      : 0
    student.percents.attendance = student.equivs.attendance * 0.15

    // PERFORMANCE
    student.totals.performance = Number(student.performance) || 0
    student.equivs.performance = hpsFinalPerformance.value
      ? (student.totals.performance * 40) / hpsFinalPerformance.value + 60
      : 0
    student.percents.performance = student.equivs.performance * 0.15

    // FINAL EXAM
    const finalExam = Number(student.finalExam) || 0
    student.totals.exam = finalExam
    student.equivs.exam = hpsFinalExam.value
      ? (finalExam * 40) / hpsFinalExam.value + 60
      : 0
    student.percents.exam = student.equivs.exam * 0.4

    // FINAL GRADE
    student.finalGrade =
      (student.percents.quiz || 0) +
      (student.percents.attendance || 0) +
      (student.percents.performance || 0) +
      (student.percents.exam || 0)

    // EQUIVALENT & REMARKS
    student.equivalent = Number(gradeEquivalent(student.finalGrade).toFixed(1))
    student.remarks = student.finalGrade >= 75 ? 'Passed' : 'Failed'
  })
}













// Watch for changes to recalc grades
watch(
  [students, hpsQuizzes, hpsAttendance, hpsPerformance, hpsPrelimScore, hpsMidtermScore],
  calculateGrades,
  { deep: true, immediate: true }
)
watch(
  [finalStudents, hpsFinalQuizzes, hpsFinalAttendance, hpsFinalPerformance, hpsFinalExam],
  calculateFinalGrades,
  { deep: true, immediate: true }
)












///////////////////






const submitGrades = async () => {
  if (hasMidtermScoresExceedingHps() || hasFinalScoresExceedingHps()) {
    await Swal.fire({
      icon: 'error',
      title: 'Scores Exceed HPS',
      html: `
        <p class="text-sm text-gray-700">
          Some scores are higher than their column HPS.<br>
          Please fix the <span class="font-semibold text-red-600">red-highlighted cells</span> before submitting.
        </p>
      `,
      confirmButtonColor: '#ef4444',
    })
    return
  }
  const result = await Swal.fire({
    title: 'Submit Grades?',
    html: `
      <p class="text-sm text-gray-700">
        Once submitted, <b>grades cannot be edited or modified</b>.<br>
        Are you sure you want to finalize and submit all grades for this class?
      </p>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Submit',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#2563eb',
    cancelButtonColor: '#6b7280',
    reverseButtons: true,
  });

  if (!result.isConfirmed) return;

  try {
    await axios.post(`/grades/submit`, {
      teacher_username: username.value,
      subject_code: subject,
      course,
      year,
      section,
      ay_id: ay.value.id,
    });
    isSubmitted.value = true;
    await Swal.fire({
      icon: 'success',
      title: 'Grades Submitted!',
      text: 'All grades have been marked as submitted and are now locked.',
      confirmButtonColor: '#2563eb',
    });
  } catch (err) {
    console.error(err);
    Swal.fire({
      icon: 'error',
      title: 'Submission Failed!',
      text: 'An error occurred while submitting grades. Please try again later.',
      confirmButtonColor: '#ef4444',
    });
  } finally {
    loading.value = false;
  }
};















// Save grades to backend
const saveGrades = async () => {
  if (hasMidtermScoresExceedingHps()) {
    await Swal.fire({
      icon: 'error',
      title: 'Scores Exceed HPS',
      html: `
        <p class="text-sm text-gray-700">
          At least one student has a score that is higher than the HPS for its column.<br>
          Please review the <span class="font-semibold text-red-600">red-highlighted cells</span> before saving.
        </p>
      `,
      confirmButtonColor: '#ef4444',
    })
    return
  }
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
          score: score, // replace to this version for 0 instead of NULL/Blank ---> score: Number(score) (add Number())
        });
      });
      // Attendance
      student.attendance.forEach((score, idx) => {
        gradesData.push({
          student_id: student.studid,
          component_type: 'attendance',
          component_index: idx + 1,
          score: score,
        });
      });
      // Performance
      gradesData.push({
        student_id: student.studid,
        component_type: 'performance',
        component_index: 1,
        score: student.performance,
      });
      // Exams: prelim and midterm
      gradesData.push({
        student_id: student.studid,
        component_type: 'exam',
        component_index: 1,
        score: student.prelimScore,
      });
      gradesData.push({
        student_id: student.studid,
        component_type: 'exam',
        component_index: 2,
        score: student.midtermScore,
      });
    });

    // Prepare gradesSummary array (midterm, final, overall)
    const gradesSummary = students.value.map(student => ({
      student_id: student.studid,
      midterm: Number(student.equivalent) || 0,
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

    await Swal.fire({
      icon: 'success',
      title: 'Midterm Grades Saved!',
      text: 'All midterm grades were successfully saved.',
      confirmButtonColor: '#2563eb',
    })
    hasComponents.midterm = true
    structureDirty.midterm = false

  } catch (error) {
    console.error('Failed to save grades:', error);
    Swal.fire({
      icon: 'error',
      title: 'Failed to Save!',
      text: 'There was an error saving midterm grades. Please try again.',
      confirmButtonColor: '#ef4444',
    })
  }
};

const saveFinalGrades = async () => {
  if (hasFinalScoresExceedingHps()) {
    await Swal.fire({
      icon: 'error',
      title: 'Scores Exceed HPS',
      html: `
        <p class="text-sm text-gray-700">
          At least one student has a score that is higher than the HPS for its column.<br>
          Please review the <span class="font-semibold text-red-600">red-highlighted cells</span> before saving.
        </p>
      `,
      confirmButtonColor: '#ef4444',
    })
    return
  }
  try {
    const gradeComponents = []

    // Quizzes
    hpsFinalQuizzes.value.forEach((hps, idx) => {
      gradeComponents.push({
        component_type: 'quiz',
        component_index: idx + 1,
        hps: Number(hps) || 0,
      })
    })

    // Attendance
    hpsFinalAttendance.value.forEach((hps, idx) => {
      gradeComponents.push({
        component_type: 'attendance',
        component_index: idx + 1,
        hps: Number(hps) || 0,
      })
    })

    // Performance + Exam
    gradeComponents.push({
      component_type: 'performance',
      component_index: 1,
      hps: Number(hpsFinalPerformance.value) || 0,
    })
    gradeComponents.push({
      component_type: 'exam',
      component_index: 1,
      hps: Number(hpsFinalExam.value) || 0,
    })

    const gradesData = []
    finalStudents.value.forEach(student => {
      student.quizzes.forEach((score, i) => {
        gradesData.push({ student_id: student.studid, component_type: 'quiz', component_index: i + 1, score })
      })
      student.attendance.forEach((score, i) => {
        gradesData.push({ student_id: student.studid, component_type: 'attendance', component_index: i + 1, score })
      })
      gradesData.push({ student_id: student.studid, component_type: 'performance', component_index: 1, score: student.performance })
      gradesData.push({ student_id: student.studid, component_type: 'exam', component_index: 1, score: student.finalExam })
    })

    const gradesSummary = finalStudents.value.map(s => {
      const midterm = getMidtermGrade(s.studid)
      const finalGrade = gradeEquivalent(Number(s.finalGrade)) || 0
      // Weighted overall (30% midterm + 70% final)
      const overall = ((gradeEquivalent(midterm) * 0.3) + (finalGrade * 0.7)).toFixed(2)
      return {
        student_id: s.studid,
        final: finalGrade,
        overall, 
      }
    })


    await axios.post(`/finalgrades/save`, {
      teacher_username: username.value,
      subject_code: subject,
      course,
      year,
      section,
      ay_id: ay.value.id,
      gradeComponents,
      gradesData,
      gradesSummary,
      term: 'final',
    })

    await Swal.fire({
      icon: 'success',
      title: 'Final Grades Saved!',
      text: 'All final grades were successfully saved.',
      confirmButtonColor: '#2563eb',
    })  
    hasComponents.finals = true
    structureDirty.finals = false

  } catch (err) {
    console.error('Failed to save final grades:', err)
    Swal.fire({
      icon: 'error',
      title: 'Save Failed!',
      text: 'There was an error saving final grades. Please try again.',
      confirmButtonColor: '#ef4444',
    })
  }
}





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



onMounted(async () => {
  await fetchCurrentAY()
  if (subject && course && year && section && ay.value?.id) {
    loading.value = true
    await fetchGrades()
    loading.value = false
    await fetchFinalGrades()
  } else {

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
.excel-btn {
  @apply px-3 py-1 border bg-gray-100 hover:bg-gray-200 text-sm;
}

.dropdown-item {
  @apply block w-full text-left px-3 py-1 text-sm hover:bg-gray-100;
}

.excel-icon-btn {
  @apply px-2 py-1 border bg-gray-100 hover:bg-gray-200 text-sm;
}


.score-input {
  width: 35px;      /* smaller width */
  font-size: 0.85rem;
  padding: 2px 4px;
  text-align: center;
}

</style>
