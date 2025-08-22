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

    <!-- 📝 Grading Compliance + 📊 Students per Course Side by Side -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Grading Compliance Panel -->
      <div class="bg-white rounded shadow p-6">
        <h2 class="text-lg font-semibold mb-4">Grading Compliance</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <div>
            <p class="text-gray-500">Classes with Complete Grades</p>
            <p class="text-xl font-bold">{{ grading.complete || 0 }}</p>
          </div>
          <div>
            <p class="text-gray-500">Classes Missing Grades</p>
            <p class="text-xl font-bold">{{ grading.incomplete || 0 }}</p>
          </div>
          <div>
            <p class="text-gray-500">% Fully Graded</p>
            <p class="text-xl font-bold">{{ complianceRate }}%</p>
          </div>
        </div>

        <!-- Progress Bar -->
        <div class="w-full bg-gray-300 rounded-full h-3 overflow-hidden">
          <div class="bg-mccblue h-3" :style="{ width: complianceRate + '%' }"></div>
        </div>

        <!-- CTA -->
        <button @click="goToIncompleteGrades"
          class="mt-4 bg-mccblue text-white px-4 py-2 rounded hover:bg-mccdarkblue transition">
          View Incomplete Grades
        </button>
      </div>

      <!-- Students per Course Bar Chart -->
      <div class="bg-white rounded shadow p-6">
        <h2 class="text-lg font-semibold mb-4">Students per Course</h2>
        <v-chart :option="studentsChartOptions" class="h-64" />
      </div>
    </div>
  </div>
</template>

<script setup>
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import 'vue-echarts'
import { router } from '@inertiajs/vue3'

const props = defineProps({
  counts: Object,
  grading: Object,
  activeSemesters: Array,
  complianceRate: Number,
  studentsChartOptions: Object,
})

// Nav functions
const goToSubjects = () => router.visit(`/subjects`)
const goToClasses = () => router.visit(`/classes`)
const goToTeachers = () => router.visit(`/instructors`)
const goToStudents = () => router.visit(`/students`)
const goToIncompleteGrades = () => router.visit(`/grades/incomplete`)
</script>