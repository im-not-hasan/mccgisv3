<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" title="Instructors" class="animate-slide-in-top">
    <div class="flex flex-col md:flex-row gap-6 p-1">
      <!-- Charts -->
      <div class="flex-1 bg-white rounded-lg shadow p-4">
        <h2 class="text-sm md:text-lg font-semibold text-gray-700 mb-2">Instructor Statistics</h2>
        <div class="grid grid-cols-1 md:grid-cols-2">
          <v-chart :option="departmentChartOptions" autoresize class="h-[300px]" />
          <v-chart :option="genderChartOptions" autoresize class="h-[300px]"/>
        </div>
      </div>

      <!-- Cards -->
      <div class="flex flex-col justify-between space-y-2">
        <CardSpotlight
          v-for="dept in departmentCards"
          :key="dept.label"
          :label="dept.label"
          :count="dept.count"
          :iconName="'teachers'"
          :useSvg="true"
          :bgColor="dept.color"
          :gradientSize="0"
          class="cursor-pointer md:w-[300px] h-[90px]"
          @click="goToDepartment(dept.label)"
        />
      </div>
    </div>

    <!-- Totals -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6 px-4">
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Total Instructors</h3>
        <p class="text-3xl font-bold text-mcclightblue">{{ overallCounts.total }}</p>
      </div>
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Male / Female</h3>
        <p class="text-2xl font-bold text-gray-700">
          👨 {{ overallCounts.male }} &nbsp;&nbsp; 👩 {{ overallCounts.female }}
        </p>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import 'echarts'
import 'vue-echarts'
import { router } from '@inertiajs/vue3'

const goToDepartment = (department) => {
  router.visit(`/instructors/${department}`)
}

// Session info
const fullname = ref('')
const userLevel = ref('')
const username = ref('')

// Data
const departmentData = ref({})
const genderData = ref({})
const overallCounts = ref({ total: 0, male: 0, female: 0 })

const departmentCards = ref([
  { label: 'BSIT', count: 0, color: '#dc2626' },
  { label: 'BSBA', count: 0, color: '#16a34a' },
  { label: 'BSHM', count: 0, color: '#ea580c' },
  { label: 'BSED', count: 0, color: '#1e3a8a' },
])



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

const fetchInstructorStats = async () => {
  try {
    const res = await axios.get('/instructor-stats') 
    departmentData.value = res.data.byDepartment
    genderData.value = res.data.byGender
    overallCounts.value = res.data.totals

    departmentCards.value = departmentCards.value.map(dept => ({
      ...dept,
      count: departmentData.value[dept.label] || 0,
    }))
  } catch (err) {
    console.error('Failed to fetch teacher stats:', err)
  }
}

// Chart: Instructors by department
const departmentChartOptions = computed(() => ({
  tooltip: { trigger: 'axis' },
  xAxis: {
    type: 'category',
    data: departmentCards.value.map(d => d.label),
    axisLabel: { fontWeight: 'bold', color: '#374151' },
  },
  yAxis: {
    type: 'value',
    axisLabel: { color: '#6B7280' },
  },
  series: [
    {
      data: departmentCards.value.map(d => d.count),
      type: 'bar',
      barWidth: '50%',
      itemStyle: {
        borderRadius: 6,
        color: (params) => departmentCards.value[params.dataIndex].color,
      },
    },
  ],
  grid: { left: '5%', right: '5%', bottom: '10%', top: '10%', containLabel: true },
}))

// Chart: Instructors by gender
const genderChartOptions = computed(() => ({
  tooltip: {
    trigger: 'item',
    formatter: '{b}: {c} ({d}%)'
  },
  series: [
    {
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      label: { show: false },
      emphasis: {
        label: {
          show: true,
          fontSize: 16,
          fontWeight: 'bold'
        }
      },
      labelLine: { show: false },
      data: [
        { value: genderData.value.male || 0, name: 'Male', itemStyle: { color: '#3b82f6' } },
        { value: genderData.value.female || 0, name: 'Female', itemStyle: { color: '#f472b6' } }
      ]
    }
  ]
}))

onMounted(() => {
  fetchSession()
  fetchInstructorStats()
})
</script>
