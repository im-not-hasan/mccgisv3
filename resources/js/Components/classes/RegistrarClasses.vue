<template>
  <div>
    <!-- Charts Row -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 p-4">
      <!-- Class Count by Course -->
      <div class="bg-white rounded-lg shadow p-4">
        <h2 class="text-sm md:text-lg font-semibold text-gray-700 mb-2">Class Count by Course</h2>
        <v-chart :option="classCountByCourse" class="h-[250px]" autoresize />
      </div>

      <!-- Average Students per Class -->
      <div class="bg-white rounded-lg shadow p-4">
        <h2 class="text-sm md:text-lg font-semibold text-gray-700 mb-2">Average Students per Class</h2>
        <v-chart :option="averageStudentsPerCourse" class="h-[250px]" autoresize />
      </div>

      <!-- Class Count by Year Level -->
      <div class="bg-white rounded-lg shadow p-4">
        <h2 class="text-sm md:text-lg font-semibold text-gray-700 mb-2">Class Count by Year Level</h2>
        <v-chart :option="classCountByYear" class="h-[250px]" autoresize />
      </div>
    </div>

    <!-- Summary Row -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-4 mt-6">
      <!-- Total Classes -->
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Total Classes</h3>
        <p class="text-3xl font-bold text-mcclightblue">{{ totalClasses }}</p>
      </div>

      <!-- Total Students -->
      <div class="bg-white shadow p-4 rounded-lg text-center">
        <h3 class="text-gray-700 font-semibold text-lg">Total Students</h3>
        <p class="text-3xl font-bold text-green-600">{{ totalStudents }}</p>
      </div>

      <!-- View All Classes Card -->
      <CardSpotlight
        label="View All Classes"
        :count="totalClasses"
        :iconName="'students'"
        :useSvg="true"
        bgColor="#3b82f6"
        :gradientSize="0"
        class="cursor-pointer h-[90px]"
        @click="router.visit('/view-classes')"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { router } from '@inertiajs/vue3'
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import 'echarts'
import 'vue-echarts'

const totalClasses = ref(0)
const totalStudents = ref(0)
const classCards = ref([])

const fetchClassData = async () => {
  try {
    const res = await axios.get('/class-stats')
    totalClasses.value = res.data.totalClasses
    totalStudents.value = res.data.totalStudents

    classCards.value = res.data.classes.map(cls => ({
      label: `${cls.course} ${cls.year} - ${cls.section}`,
      count: cls.studentCount,
      color: cls.color,
      id: cls.id
    }))
  } catch (e) {
    console.error('Failed to load class stats', e)
  }
}

const classCountByCourse = computed(() => ({
  tooltip: { trigger: 'item' },
  series: [
    {
      type: 'pie',
      radius: ['40%', '70%'],
      label: { show: false },
      labelLine: { show: false },
      emphasis: {
        label: {
          show: true,
          fontSize: 16,
          fontWeight: 'bold'
        }
      },
      data: classCards.value.reduce((acc, cls) => {
        const course = cls.label.split(' ')[0]
        const existing = acc.find(e => e.name === course)
        if (existing) existing.value += 1
        else acc.push({ name: course, value: 1 })
        return acc
      }, [])
    }
  ]
}))

const averageStudentsPerCourse = computed(() => {
  const data = {}
  classCards.value.forEach(cls => {
    const course = cls.label.split(' ')[0]
    if (!data[course]) data[course] = { total: 0, count: 0 }
    data[course].total += cls.count
    data[course].count += 1
  })

  const chartData = Object.entries(data).map(([course, { total, count }]) => ({
    name: course,
    value: count ? (total / count).toFixed(1) : 0
  }))

  return {
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'value', axisLabel: { color: '#6B7280' } },
    yAxis: {
      type: 'category',
      data: chartData.map(item => item.name),
      axisLabel: { color: '#374151', fontWeight: 'bold' }
    },
    series: [
      {
        type: 'bar',
        data: chartData.map(item => parseFloat(item.value)),
        barWidth: '60%',
        itemStyle: {
          color: '#3b82f6',
          borderRadius: 6,
        },
      }
    ]
  }
})

const classCountByYear = computed(() => ({
  tooltip: { trigger: 'axis' },
  xAxis: {
    type: 'category',
    data: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
    axisLabel: { fontWeight: 'bold', color: '#374151' },
  },
  yAxis: { type: 'value', axisLabel: { color: '#6B7280' } },
  series: [
    {
      type: 'bar',
      data: [1, 2, 3, 4].map(year =>
        classCards.value.filter(cls => cls.label.includes(`${year}`)).length
      ),
      barWidth: '60%',
      itemStyle: { borderRadius: 6, color: '#f97316' }
    }
  ]
}))

onMounted(() => {
  fetchClassData()
})
</script>
