<template>
  <DashboardLayout
    :fullname="fullname"
    :userLevel="userLevel"
    title="View Grades"
    class="animate-slide-in-top"
  >
    <div v-if="loading" class="flex justify-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
        <!-- Header card -->
      <div class="bg-white rounded shadow p-4 mb-4 flex flex-wrap gap-4 justify-between items-center">
        <!-- left info -->
        <div>
          <p class="text-sm text-gray-700">
            Curriculum:
            <span class="font-semibold">
              {{ curriculum !== null && curriculum !== undefined ? curriculum : 'Active' }}
            </span>
          </p>
          <p class="text-xs text-gray-500 mt-1">
            Total Subjects: <span class="font-semibold">{{ totalSubjects }}</span>
            • With Grades: <span class="font-semibold">{{ subjectsWithGrades }}</span>
          </p>
        </div>

        <!-- right actions -->
        <div>
          <button
            @click="downloadPdf"
            class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md text-sm font-medium transition"
          >
            Download a Copy
          </button>
        </div>
      </div>

      <!-- Year & Semester Tables -->
      <div v-for="(semesters, yearLabel) in grouped" :key="yearLabel" class="mb-6">
        <h2 class="text-center md:text-xl text-lg font-semibold text-mccblue mb-2">{{ yearLabel }}</h2>

        <div
          v-for="(subjects, semLabel) in semesters"
          :key="semLabel"
          class="bg-white rounded shadow mb-4"
        >
          <h3 class="text-center md:text-lg text-md font-semibold text-mccblue py-2">
            {{ semLabel }}
          </h3>
          <table class="min-w-full bg-white rounded-b-lg overflow-hidden">
            <thead class="bg-mcclightblue text-white">
              <tr>
                <th class="py-2 px-4 text-center md:text-base text-xs">Subject Code</th>
                <th class="py-2 px-4 text-center md:text-base text-xs">Descriptive Title</th>
                <th class="py-2 px-4 text-center md:text-base text-xs">Total Units</th>
                <th class="py-2 px-4 text-center md:text-base text-xs">Grade</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="s in subjects"
                :key="s.code"
                class="hover:bg-gray-100 transition"
              >
                <td class="py-2 px-4 text-center font-medium md:text-base text-xs">{{ s.code }}</td>
                <td class="py-2 px-4 text-center md:text-base text-xs">{{ s.title }}</td>
                <td class="py-2 px-4 text-center md:text-base text-xs">{{ s.total_units }}</td>
                <td class="py-2 px-4 text-center md:text-base text-xs">
                  <span v-if="s.grade">{{ Number(s.grade).toFixed(1) }}</span>
                  <span v-else class="text-gray-400">–</span>
                </td>
              </tr>
              <tr v-if="!subjects.length">
                <td colspan="4" class="text-center py-3 text-gray-500">
                  No subjects found for this semester.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'

const fullname = ref('')
const userLevel = ref('')
const loading = ref(true)
const curriculum = ref(null)
const grouped = ref({})

const fetchSession = async () => {
  try {
    const res = await axios.get('/session')
    fullname.value = res.data.fullname
    userLevel.value = res.data.level
    username.value = res.data.username
    if (!fullname.value || !userLevel.value) window.location.href = '/'
  } catch {
    window.location.href = '/'
  }
}

const fetchViewGradesData = async () => {
  const res = await axios.get('/student/viewgrades/data')
  curriculum.value = res.data.curriculum
  grouped.value = res.data.grouped
}

// 👇 flatten helper
const allSubjects = computed(() => {
  const list = []
  Object.values(grouped.value).forEach((semesters) => {
    Object.values(semesters).forEach((subjects) => {
      subjects.forEach((s) => list.push(s))
    })
  })
  return list
})

const totalSubjects = computed(() => allSubjects.value.length)

const subjectsWithGrades = computed(() =>
  allSubjects.value.filter((s) => s.grade !== null && s.grade !== undefined && s.grade !== '').length
)

const downloadPdf = async () => {
  try {
    // Show a temporary loading indicator if you want (optional)
    const res = await axios.get('/viewgrades/download', {
      responseType: 'blob', // tells Axios to treat it as a file
    });

    // Create a blob and trigger the browser download
    const blob = new Blob([res.data], { type: 'application/pdf' });
    const link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.download = 'gradeslip.pdf'; // filename
    link.click();
    window.URL.revokeObjectURL(link.href);
  } catch (err) {
    console.error('Failed to download PDF:', err);
  }
};


onMounted(async () => {
  try {
    await fetchSession()
    await fetchViewGradesData()
  } finally {
    loading.value = false
  }
})
</script>