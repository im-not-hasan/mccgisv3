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
      <!-- Welcome Card -->
      <div class="bg-white rounded shadow p-4 mb-4">
        <h1 class="text-2xl font-bold text-mccblue">Welcome, {{ fullname }}</h1>
        <p class="text-gray-700">
          ID: <span class="font-medium">{{ username }}</span> | Registrar Portal
        </p>
      </div>

      <div v-if="activeSemesters.length" class="bg-mcclightblue text-white px-4 py-2 rounded mb-4 shadow">
        Active Semesters:
        <span class="font-bold">
          {{ activeSemesters.map(s => s === '1' ? 'First Semester' : s === '2' ? 'Second Semester' : 'Summer').join(', ') }}
        </span>
      </div>

      <!-- 📚 Quick Access Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-6">
        <CardSpotlight
          label="Classes"
          :count="counts.class || 0"
          iconName="grades"
          :useSvg="true"
          @click="goToClasses"
          class="cursor-pointer"
        />

        <CardSpotlight
          label="Students"
          :count="counts.students || 0"
          iconName="students"
          :useSvg="true"
          @click="goToStudents"
          class="cursor-pointer"
        />

        <CardSpotlight
          label="TOR Requests"
          :count="TOR_requests"
          iconName="grades"
          :useSvg="true"
          @click="goToTORRequests"
          class="cursor-pointer"
        />

      </div>

      <!-- 📝 Announcements Section -->
      <div class="bg-white rounded shadow p-6 mb-6">
        <h2 class="text-lg font-semibold mb-4">Announcements</h2>
        <p class="text-gray-600">No announcements at the moment.</p>
      </div>

      <!-- 📊 Quick Stats -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div class="bg-white rounded shadow p-4 text-center">
          <p class="text-gray-500">Pending Requests</p>
          <p class="text-2xl font-bold text-orange-500">{{ pendingRequests }}</p>
        </div>

        <div class="bg-white rounded shadow p-4 text-center">
          <p class="text-gray-500">Compliance Rate</p>
          <p class="text-2xl font-bold text-green-500">{{ complianceRate }}%</p>
        </div>

        <div class="bg-white rounded shadow p-4 text-center">
          <p class="text-gray-500">Incomplete Grades</p>
          <p class="text-2xl font-bold text-mccblue">{{ incompleteGrades ? incompleteGrades : "0"  }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import { router } from '@inertiajs/vue3'

const props = defineProps({
  counts: Object,
  grading: Object,
  activeSemesters: Number,
  complianceRate: Number,
  studentsChartOptions: Object,
  fullname: Object,
  username: Object,
})

const TOR_requests = ref(0)
const studentCounts = ref({ total: 0 })
const activeSemesters = ref([])
const pendingRequests = ref([])
const complianceRate = ref(0)
const loading = ref(true)

const fetchRegistrarDashboard = async () => {
  try {
    const res = await axios.get('/registrar/dashboard')
    TOR_requests.value = res.data.TOR_requests
    activeSemesters.value = res.data.activeSemesters
    pendingRequests.value = res.data.pendingRequests
  } catch (err) {
    console.error('Failed to load registrar dashboard:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRegistrarDashboard()
})


const goToClasses = () => router.visit(`/classes`)
const goToStudents = () => router.visit(`/students`)
const goToTORRequests = () => router.visit(`/tor-requests`)
</script>
