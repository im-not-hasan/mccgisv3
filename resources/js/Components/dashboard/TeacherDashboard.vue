<template>
  <div>

    <!-- 🔵 Active Semesters Banner -->
    <div v-if="activeSemesters.length" class="bg-mccblue text-white px-4 py-2 rounded mb-4 shadow">
      Active Semesters:
      <span class="font-bold">
        {{ activeSemesters.map(s => s === '1' ? 'First Semester' : s === '2' ? 'Second Semester' : 'Summer').join(', ') }}
      </span>
    </div>

    <!-- 🔄 Loading Indicator -->
    <div v-if="loading" class="flex justify-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor"
          d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
      <!-- Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-3 gap-6 mb-6">
         <CardSpotlight
          label="My Subjects"
          :count="counts.subjects || 0"
          iconName="subjects"
          :useSvg="true"
          @click="goToSubjects"
          class="cursor-pointer"
        />
<!---counts.class = subject count, counts.subjects = class count-->
        <CardSpotlight
          label="My Classes"
          :count="counts.class || 0" 
          iconName="grades"
          :useSvg="true"
          @click="goToClasses"
          class="cursor-pointer"
        />

        <CardSpotlight
          label="Consultations"
          :count="counts.consultations || 0"
          iconName="grades"
          :useSvg="true"
          @click="goToConsultation"
          class="cursor-pointer"
        />

      </div>

      <!-- 📝 Grading Compliance Panel -->
      <div class="bg-white rounded shadow p-6 mb-6">
        <h2 class="text-lg font-semibold mb-4">My Grading Compliance</h2>
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
            <p class="text-xl font-bold">{{ grading.complianceRate }}%</p>
          </div>
        </div>

        <!-- Progress Bar -->
        <div class="w-full bg-gray-300 rounded-full h-3 overflow-hidden relative">
          <div
            class="h-3 rounded-full transition-all duration-1000 ease-out"
            :class="barColor"
            :style="{ width: animatedRate + '%' }"
          ></div>
        </div>

        <!-- CTA -->
        <button @click="goToIncompleteGrades"
          class="mt-4 bg-mccblue text-white px-4 py-2 rounded hover:bg-mccdarkblue transition">
          View Incomplete Grades
        </button>
      </div>
    </div>

  </div>
</template>

<script setup>
import { router } from '@inertiajs/vue3'
import CardSpotlight from '@/Components/InspiraUI/CardSpotlight.vue'
import { ref, watch, computed} from 'vue'

const props = defineProps({
  counts: Object,
  grading: Object,
  activeSemesters: Array,
  complianceRate: [String, Number],
  loading: {
    type: Boolean,
    default: false,
  },
})

const barColor = computed(() => {
  const rate = animatedRate.value
  if (rate < 50) return 'bg-red-500'
  if (rate < 80) return 'bg-yellow-400'
  return 'bg-green-500'
})

const animatedRate = ref(0)
watch(
  () => props.grading.complianceRate,
  (newVal) => {
    animatedRate.value = 0
    setTimeout(() => {
      animatedRate.value = Number(newVal) || 0
    }, 100) // small delay to trigger animation
  },
  { immediate: true }
)

// Nav functions
const goToClasses = () => router.visit('/classes')
const goToSubjects = () => router.visit('/subjects')
const goToConsultation = () => router.visit('/consultation')
const goToSettings = () => router.visit('/settings')
const goToIncompleteGrades = () => router.visit('/subjects')

</script>
