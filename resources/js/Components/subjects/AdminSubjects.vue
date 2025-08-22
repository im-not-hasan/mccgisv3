<template>
  <div class="flex flex-col md:flex-row gap-6 p-1">
    <!-- Chart and toggle -->
    <div class="flex-1 bg-white rounded-lg shadow p-4 flex flex-col justify-center">
      <div class="flex justify-between items-center mb-2">
        <h2 class="text-sm md:text-lg font-semibold text-gray-700">Subject Count per Course</h2>
        <div class="space-x-1 md:space-x-4 text-sm text-gray-700">
          <label><input type="radio" class="focus:ring-[0%] cursor-pointer" value="active" v-model="mode" @change="fetchSubjectCounts" /> Active</label>
          <label><input type="radio" class="focus:ring-[0%] cursor-pointer" value="total" v-model="mode" @change="fetchSubjectCounts" /> Total</label>
        </div>
      </div>
      <v-chart :option="chartOptions" autoresize class="h-[390px]" />
    </div>

    <!-- Cards (Right 1/3 width) -->
    <div class="flex flex-col justify-between space-y-2">
      <CardSpotlight
        v-for="course in courseCards"
        :key="course.label"
        :label="course.label"
        :count="course.count"
        iconName="subjects"
        :useSvg="true"
        :bgColor="course.color"
        :gradientSize="0"
        class="cursor-pointer md:w-[300px] h-[90px]"
        @click="goToCourse(course.name)"
      />
    </div>
  </div>

  <!-- Totals Section -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6 px-4">
    <div class="bg-white shadow p-4 rounded-lg text-center">
      <h3 class="text-gray-700 font-semibold text-lg">Total Subjects (All Semesters)</h3>
      <p class="text-3xl font-bold text-mcclightblue">{{ overallTotals.total }}</p>
    </div>
    <div class="bg-white shadow p-4 rounded-lg text-center">
      <h3 class="text-gray-700 font-semibold text-lg">Active Subjects (Current Semester)</h3>
      <p class="text-3xl font-bold text-green-600">{{ overallTotals.active }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import { router } from '@inertiajs/vue3'
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import 'echarts'
import 'vue-echarts'

const subjectData = ref({})
const overallTotals = ref({ total: 0, active: 0 })
const mode = ref('active') // 'active' or 'total'

const courseCards = ref([
  { name: 'BSIT', label: 'BSIT', count: 0, color: '#dc2626' },
  { name: 'BSBA', label: 'BSBA-FM', count: 0, color: '#16a34a' },
  { name: 'BSHM', label: 'BSHM', count: 0, color: '#ea580c' },
  { name: 'BSED', label: 'BSED Filipino', count: 0, color: '#1e3a8a' },
  { name: 'BEED', label: 'BEED', count: 0, color: '#0ea5e9' },
])

const fetchSubjectCounts = async () => {
  try {
    const response = await axios.get(`/subject-counts?mode=${mode.value}`)
    subjectData.value = response.data.byCourse
    overallTotals.value = {
      total: response.data.totals.total,
      active: response.data.totals.active,
    }

    courseCards.value = courseCards.value.map(course => ({
      ...course,
      count: subjectData.value[course.name] || 0,
    }))
  } catch (err) {
    console.error('Error fetching subject counts:', err)
  }
}

const goToCourse = (course) => {
  router.visit(`/subjects/${course}`)
}

const chartOptions = computed(() => ({
  tooltip: { trigger: 'axis' },
  xAxis: {
    type: 'category',
    data: courseCards.value.map(c => c.label),
    axisLabel: { fontWeight: 'bold', color: '#374151' },
  },
  yAxis: {
    type: 'value',
    axisLabel: { color: '#6B7280' },
  },
  series: [
    {
      data: courseCards.value.map(c => c.count),
      type: 'bar',
      itemStyle: {
        borderRadius: 6,
        color: (params) => courseCards.value[params.dataIndex].color,
      },
      barWidth: '50%',
    },
  ],
  grid: { left: '5%', right: '5%', bottom: '10%', top: '10%', containLabel: true },
}))

onMounted(() => {
  fetchSubjectCounts()
})
</script>
