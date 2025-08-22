<template>
  <div>
    <!-- 🔵 Active Semesters Banner -->
    <div v-if="activeSemesters.length" class="bg-mccblue text-white px-4 py-2 rounded mb-4 shadow">
      Active Semesters:
      <span class="font-bold">
        {{ activeSemesters.map(s => s === '1' ? 'First Semester' : s === '2' ? 'Second Semester' : 'Summer').join(', ') }}
      </span>
    </div>

    <!-- Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-6 mb-6">
      <CardSpotlight
        label="Students"
        :count="counts.students || 0"
        iconName="students"
        :useSvg="true"
        @click="goToStudents"
        class="cursor-pointer"
      />

      <CardSpotlight
        label="Teachers"
        :count="counts.teachers || 0"
        iconName="teachers"
        :useSvg="true"
        @click="goToTeachers"
        class="cursor-pointer"
      />

      <CardSpotlight
        label="Classes"
        :count="counts.class || 0"
        iconName="grades"
        :useSvg="true"
        @click="goToClasses"
        class="cursor-pointer"
      />

      <CardSpotlight
        label="Subjects"
        :count="counts.subjects || 0"
        iconName="subjects"
        :useSvg="true"
        @click="goToSubjects"
        class="cursor-pointer"
      />
    </div>

    <!-- 📝 Grading Compliance & 📊 Students per Course Side by Side -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
  <!-- 📝 Grading Compliance Panel (Circular Gauge Dummy + labels) -->
 <div class="bg-white rounded shadow p-6 mb-6 md:mb-0">
  <h2 class="text-lg font-semibold mb-4">Grading Compliance</h2>

  <!-- Labels and Gauge Container -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 items-center">
    <!-- Labels for complete and incomplete -->
    <div class="flex flex-col justify-center order-1 md:order-none md:mt-[-20px]">
      <p class="text-gray-500">Classes with Complete Grades:</p>
      <p class="text-xl font-bold">{{ grading.complete || 0 }}</p>

      <p class="text-gray-500 mt-4">Classes Missing Grades:</p>
      <p class="text-xl font-bold">{{ grading.incomplete || 0 }}</p>
    </div>

    <!-- Gauge Chart Dummy -->
    <div class="flex flex-col items-center order-2 md:order-none">
      <v-chart :option="dummyComplianceChartOptions" class="mx-auto h-48 md:w-48" />

      <!-- CTA -->
      <button @click="goToIncompleteGrades"
        class="mt-4 bg-mccblue text-white px-4 py-2 rounded hover:bg-mccdarkblue transition w-full">
        View Incomplete Grades
      </button>
    </div>
  </div>
</div>


  <!-- 📊 Students per Course Bar Chart -->
  <div class="bg-white rounded shadow p-6">
    <h2 class="text-lg font-semibold mb-4">Students per Course</h2>
    <v-chart :option="studentsChartOptions" class="h-64" />
  </div>
</div>



  </div>
</template>

<script setup>
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import { router } from '@inertiajs/vue3'

// ✅ Import ECharts core and gauge chart type
import * as echarts from 'echarts/core'
import { GaugeChart, BarChart } from 'echarts/charts'
import { CanvasRenderer } from 'echarts/renderers'
import { TitleComponent, TooltipComponent, GridComponent, LegendComponent } from 'echarts/components'
import VChart from 'vue-echarts'

// Register required chart types and components
echarts.use([
  GaugeChart,
  BarChart,
  CanvasRenderer,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
])

const props = defineProps({
  counts: Object,
  grading: Object,
  activeSemesters: Array,
  complianceRate: Number,
  studentsChartOptions: Object,
})

const dummyComplianceChartOptions = {
  series: [{
    type: 'gauge',
    startAngle: 90,
    endAngle: -270,
    radius: '100%',
    progress: {
      show: true,
      overlap: false,
      roundCap: true,
      clip: false,
      itemStyle: {
        color: '#22c55e', // ✅ green progress bar
      },
    },
    axisLine: {
      lineStyle: {
        width: 18,
        color: [[1, '#e5e7eb']], // ✅ gray background for incomplete portion
      },
    },
    pointer: { show: false },
    axisTick: { show: false },
    splitLine: { show: false },
    axisLabel: { show: false },
    data: [{ value: 100 }], // dummy 75% value
    detail: {
      valueAnimation: true,
      formatter: '{value}%',
      fontSize: 24,
      fontWeight: 'bold',
      color: '#0f172a',
      offsetCenter: [0, 0], // ✅ centers text
    },
  }],
}


// Nav functions
const goToSubjects = () => router.visit(`/subjects`)
const goToClasses = () => router.visit(`/classes`)
const goToTeachers = () => router.visit(`/instructors`)
const goToStudents = () => router.visit(`/students`)
const goToIncompleteGrades = () => router.visit(`/grades/incomplete`)
</script>

<script>
// ✅ Register <v-chart> locally
export default {
  components: {
    'v-chart': VChart,
  },
}
</script>
