<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="'Dashboard'" class="animate-slide-in-top">

    <!-- 🔄 Loading Indicator -->
    <div v-if="loading" class="flex justify-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor"
          d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
      <!-- 🟢 Admin Dashboard -->
      <AdminDashboard
        v-if="userLevel === 'admin'"
        :counts="counts"
        :grading="grading"
        :activeSemesters="activeSemesters"
        :complianceRate="complianceRate"
        :studentsChartOptions="studentsChartOptions"
      />

      <!-- 🟠 Teacher Dashboard -->
      <TeacherDashboard
        v-else-if="userLevel === 'teacher'"
        :counts="counts"
        :grading="grading"
        :activeSemesters="activeSemesters"
      />

      <!-- 🔵 Student Dashboard -->
      <StudentDashboard
        v-else-if="userLevel === 'student'"
        :counts="counts"
        :activeSemesters="activeSemesters"
      />
      
      <!-- 🟣 Registrar Dashboard -->
      <RegistrarDashboard
        v-else-if="userLevel === 'registrar'"
        :counts="counts"
        :grading="grading"
        :activeSemesters="activeSemesters"
        :complianceRate="complianceRate"
        :studentsChartOptions="studentsChartOptions"
        :username="username"
        :fullname="fullname"
      />
    
      <!-- ⚠️ Unknown user level -->
      <div v-else class="text-center text-red-500">
        Unknown user level: {{ userLevel }}
      </div>
    </div>

  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import AdminDashboard from '@/Components/dashboard/AdminDashboard.vue'
import TeacherDashboard from '@/Components/dashboard/TeacherDashboard.vue'
import StudentDashboard from '@/Components/dashboard/StudentDashboard.vue'
import RegistrarDashboard from '@/Components/dashboard/RegistrarDashboard.vue'


const fullname = ref('')
const username = ref('')
const userLevel = ref('')
const loading = ref(true)

const counts = ref({
  students: 0,
  teachers: 0,
  class: 0,
  subjects: 0,
})

const activeSemesters = ref([])

const grading = ref({
  complete: 0,
  incomplete: 0,
})

const studentsPerCourse = ref([
  { course: 'BSIT', students: 0 },
  { course: 'BSBA', students: 0 },
  { course: 'BSED', students: 0 },
])

const complianceRate = computed(() => {
  const total = (grading.value.complete || 0) + (grading.value.incomplete || 0)
  return total === 0 ? 0 : ((grading.value.complete / total) * 100).toFixed(1)
})

const studentsChartOptions = computed(() => ({
  tooltip: { trigger: 'axis' },
  xAxis: {
    type: 'category',
    data: studentsPerCourse.value.map(d => d.course),
    axisLabel: { fontWeight: 'bold', color: '#374151' },
  },
  yAxis: {
    type: 'value',
    axisLabel: { color: '#6B7280' },
  },
  series: [{
    type: 'bar',
    barWidth: '50%',
    data: studentsPerCourse.value.map(d => d.students || 0),
    itemStyle: { color: '#0ea5e9' },
  }],
  grid: { left: '5%', right: '5%', bottom: '10%', top: '10%', containLabel: true },
}))

// Fetch session
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

// Fetch dashboard counts
const fetchCounts = async () => {
  try {
    const res = await axios.get('/dashboard-counts')
    counts.value = res.data.counts || {}
    activeSemesters.value = res.data.activeSemesters || []
    grading.value = res.data.grading || { complete: 0, incomplete: 0 }
    studentsPerCourse.value = res.data.studentsPerCourse || []
  } catch (err) {
    console.error('Error:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchSession()
  fetchCounts()
})
</script>
