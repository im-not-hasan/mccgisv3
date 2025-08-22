<template>
  <div>
    <!-- 👋 Welcome Header -->
    <div v-if="loading" class="text-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue mx-auto" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
      <div v-if="student" class="bg-white rounded shadow p-4 mb-4">
        <h1 class="text-2xl font-bold text-mccblue">Welcome, {{ student.fullname }}</h1>
        <p class="text-gray-700">
          ID: <span class="font-medium">{{ student.id }}</span> |
          {{ student.course }} {{ student.year }}-{{ student.section }}
        </p>
      </div>

      <!-- 🔵 Active Semesters Banner -->
      <div v-if="activeSemesters.length" class="bg-mccblue text-white px-4 py-2 rounded mb-4 shadow">
        Active Semesters:
        <span class="font-bold">
          {{ activeSemesters.map(s => s === '1' ? 'First Semester' : s === '2' ? 'Second Semester' : 'Summer').join(', ') }}
        </span>
      </div>

      <!-- 📚 Quick Access Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 mb-6">
        <CardSpotlight
          label="My Grades"
          iconName="grades"
          :useSvg="true"
          @click="goToGrades"
          class="cursor-pointer"
        />

        <CardSpotlight
          label="My Subjects"
          iconName="subjects"
          :useSvg="true"
          @click="goToSubjects"
          class="cursor-pointer"
        />
      </div>

      <!-- 📝 Announcements Section -->
      <div class="bg-white rounded shadow p-6">
        <h2 class="text-lg font-semibold mb-4">Announcements</h2>
        <p class="text-gray-600">No announcements at the moment.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import { router } from '@inertiajs/vue3'

const student = ref(null)
const activeSemesters = ref([])
const loading = ref(true)

const fetchStudentDashboard = async () => {
  try {
    const res = await axios.get('/student/dashboard')
    console.log('Student dashboard response:', res)

    if (!res.data.student) {
      console.error('No student data received:', res.data)
    }

    student.value = res.data.student
    activeSemesters.value = res.data.activeSemesters

  } catch (err) {
    console.error('Failed to load student dashboard data:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchStudentDashboard()
})

// Navigation functions
const goToGrades = () => router.visit(`/grades`)
const goToSubjects = () => router.visit(`/subjects`)
</script>
