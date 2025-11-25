<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" title="Students" class="animate-slide-in-top">
    <div class="flex flex-col md:flex-row gap-6 p-1">
      <!-- Charts -->
      <div class="flex-1 bg-white rounded-lg shadow p-4">
        <h2 class="text-sm md:text-lg font-semibold text-gray-700 mb-2">Student Statistics</h2>
        <div class="grid grid-cols-1 md:grid-cols-2">
          <v-chart :option="courseChartOptions" autoresize class="h-[300px]" />
          <v-chart :option="genderChartOptions" autoresize class="h-[300px]" />
        </div>
      </div>

      <!-- Cards -->
      <div class="flex flex-col justify-between space-y-2">
        <CardSpotlight
          v-for="course in courseCards"
          :key="course.label"
          :label="course.label"
          :count="course.count"
          :iconName="'students'"
          :useSvg="true"
          :bgColor="course.color"
          :gradientSize="0"
          class="cursor-pointer md:w-[300px] h-[90px]"
          @click="goToCourse(course.label)"
        />
        <CardSpotlight
        label="View All Students"
        :count="totalClasses"
        :iconName="'students'"
        :useSvg="true"
        bgColor="#3b82f6"
        :gradientSize="0"
        class="cursor-pointer h-[90px]"
        @click="router.visit(`/students/all`)"
      />
      </div>
    </div>

    <!-- Totals -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6 px-4">
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Total Students</h3>
        <p class="text-3xl font-bold text-mcclightblue">{{ overallCounts.total }}</p>
      </div>
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Male / Female</h3>
        <p class="text-2xl font-bold text-gray-700">
          👨 {{ overallCounts.male }} &nbsp;&nbsp; 👩 {{ overallCounts.female }}
        </p>
      </div>
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Regular / Irregular</h3>
        <p class="text-2xl font-bold text-mcclightblue">
           {{ overallCounts.regular || 0}} /   {{ overallCounts.irregular || 0 }}
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

const goToCourse = (course) => {
  router.visit(`/students/${course}`)
}



// Session info
const fullname = ref('')
const userLevel = ref('')
const username = ref('')


// Data
const courseData = ref({})
const genderData = ref({})
const overallCounts = ref({ total: 0, male: 0, female: 0, regular: 0, irregular: 0})         
const courseRegularData = ref({})   
const courseIrregularData = ref({}) 

const courseCards = ref([
  { label: 'BSIT', count: 0, color: '#dc2626' },
  { label: 'BSBA', count: 0, color: '#16a34a' },
  { label: 'BSHM', count: 0, color: '#ea580c' },
  { label: 'EDUC', count: 0, color: '#1e3a8a' },
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

const fetchStudentStats = async () => {
  try {
    const res = await axios.get('/student-stats') // endpoint from StudentsController
    courseData.value = res.data.byCourse
    courseRegularData.value   = res.data.byCourseRegular   || {}
    courseIrregularData.value = res.data.byCourseIrregular || {}
    genderData.value = res.data.byGender
    overallCounts.value = res.data.totals

    courseCards.value = courseCards.value.map(c => ({
      ...c,
      count: courseData.value[c.label] || 0,
    }))
  } catch (err) {
    console.error('Failed to fetch student stats:', err)
  }
}

// 🔹 Chart: Students by course (stacked bar: Regular vs Irregular)
const courseChartOptions = computed(() => {
  const labels = courseCards.value.map(c => c.label)

  const regularSeries = labels.map(label => courseRegularData.value[label] || 0)
  const totalSeries   = labels.map(label => courseData.value[label] || 0)
  const irregularSeries = totalSeries.map((total, idx) => {
    const reg = regularSeries[idx]
    const irr = total - reg
    return irr < 0 ? 0 : irr
  })

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' }
    },
    legend: {
      data: ['Regular', 'Irregular'],
    },
    xAxis: {
      type: 'category',
      data: labels,
      axisLabel: { fontWeight: 'bold', color: '#374151' },
    },
    yAxis: {
      type: 'value',
      axisLabel: { color: '#6B7280' },
    },
    series: [
      {
        name: 'Regular',
        type: 'bar',
        stack: 'total',
        barWidth: '50%',
        data: regularSeries,
        itemStyle: {
          borderRadius: [6, 6, 0, 0],
          color: (params) => courseCards.value[params.dataIndex].color, 
        },
      },
      {
        name: 'Irregular',
        type: 'bar',
        stack: 'total',
        barWidth: '50%',
        data: irregularSeries,
        itemStyle: {
          borderRadius: [6, 6, 0, 0],
          color: '#22c55e', 
        },
      },
    ],
    grid: { left: '5%', right: '5%', bottom: '10%', top: '10%', containLabel: true },
  }
})

// Chart: Students by gender
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
  fetchStudentStats()
})
</script>
