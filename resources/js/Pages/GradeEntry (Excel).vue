<template>
  <div class="w-screen h-screen bg-pink-100 p-4">
    <div v-if="!tableData.length" class="text-center text-lg font-semibold text-gray-600">
      Loading student data...
    </div>
    <HotTable
      v-else
      :data="tableData"
      :colHeaders="columnHeaders"
      :columns="columns"
      :colWidths="colWidths"
      :rowHeaders="true"
      :licenseKey="'non-commercial-and-evaluation'"
      class="hot-table w-full h-full bg-white"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { usePage } from '@inertiajs/vue3'
import axios from 'axios'
import { HotTable } from '@handsontable/vue3'
import 'handsontable/dist/handsontable.full.min.css'

// Extract query parameters from the current URL
const { url } = usePage()
const queryParams = new URLSearchParams(url.split('?')[1])

const subject = queryParams.get('subject') || ''
const course = queryParams.get('course') || ''
const year = queryParams.get('year') || ''
const section = queryParams.get('section') || ''

const tableData = ref([])

const columnHeaders = [
  'Last Name', 'First Name', 'Middle Name',
  'Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7', 'Q8', 'Q9', 'Q10',
  'Quiz Total', 'Quiz Equiv', 'Quiz 30%',
  'Day1', 'Day2', 'Day3', 'Day4', 'Day5', 'Day6', 'Day7', 'Day8', 'Day9', 'Day10',
  'Day11', 'Day12', 'Day13', 'Day14', 'Day15', 'Day16', 'Day17', 'Day18', 'Day19', 'Day20',
  'Attendance Total', 'Attendance Equiv', 'Attendance 15%',
  'Performance Score', 'Performance Equiv', 'Performance 15%',
  'Prelim', 'Midterm', 'Exam Total', 'Exam Equiv', 'Exam 40%',
  'Midterm Grade', 'Equivalent', 'Remarks'
]

const columns = columnHeaders.map(() => ({ type: 'text' }))

const colWidths = columnHeaders.map((header) => {
  if (/^Q[1-9]$|^Q10$/.test(header)) return 35     // Quizzes
  if (/^Day[0-9]+$/.test(header)) return 60        // Attendance
  return 120                                       // Others
})

const fetchGrades = async () => {
  try {
    const url = `/grades/${encodeURIComponent(subject)}/${encodeURIComponent(course)}/${encodeURIComponent(year)}/${encodeURIComponent(section)}`
    console.log('Requesting grades from:', url)
    const res = await axios.get(url)

    const students = res.data.students || []

    const rows = students.map((student, index) => {
      const infoCols = [
        student.lname || '',
        student.fname || '',
        student.mname || ''
      ]
      const emptyCols = Array(columnHeaders.length - 4).fill('')
      return [...infoCols, ...emptyCols]
    })

    tableData.value = rows
  } catch (err) {
    console.error('Failed to fetch grades:', err)
  }
}

onMounted(() => {
  if (subject && course && year && section) {
    fetchGrades()
  } else {
    console.warn('Missing query parameters. Grade table not loaded.')
  }
})
</script>

<style scoped>
.hot-table {
  border: 1px solid #000;
}
</style>
