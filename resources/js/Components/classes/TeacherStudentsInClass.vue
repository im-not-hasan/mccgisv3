<template>
  <Transition name="fade">
    <div v-if="visible" class="fixed inset-0 z-50 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white w-full max-w-4xl p-6 rounded-lg shadow-lg relative overflow-y-auto max-h-[90vh] animate-fade-in-up">
        <h2 class="text-xl sm:text-2xl font-bold mb-4 text-mccblue">
          Students in {{ selectedClass.course }} {{ selectedClass.year }}-{{ selectedClass.section }}
        </h2>

        <!-- 🔄 Loading spinner -->
        <div v-if="loadingStudents" class="flex justify-center py-4">
          <svg class="animate-spin h-8 w-8 text-mccblue" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
          </svg>
        </div>

        <!-- ✅ Main Content -->
        <div v-else>
          <div class="overflow-x-auto rounded-lg border shadow">
            <table class="min-w-full text-xs sm:text-sm bg-white">
              <thead class="bg-mcclightblue text-white">
                <tr>
                  <th class="px-2 sm:px-4 py-2">Student ID</th>
                  <th class="px-2 sm:px-4 py-2">Last Name</th>
                  <th class="px-2 sm:px-4 py-2">First Name</th>
                  <th class="px-2 sm:px-4 py-2">Middle Name</th>
                  <th class="px-2 sm:px-4 py-2 text-center">Gender</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="student in sortedStudents" :key="student.id" class="hover:bg-gray-100">
                  <td class="px-2 sm:px-4 py-2">{{ student.studid }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ student.lname }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ student.fname }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ student.mname }}</td>
                  <td class="px-2 sm:px-4 py-2 text-center">{{ student.gender }}</td>
                </tr>
                <tr v-if="students.length === 0">
                  <td colspan="5" class="text-center py-4">No students in this class.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Close -->
        <button @click="close" class="absolute top-4 right-4 text-xl text-gray-600 hover:text-red-500 transition">
          &times;
        </button>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import axios from 'axios'

const props = defineProps({
  visible: Boolean,
  selectedClass: Object,
})
const emit = defineEmits(['close'])

const students = ref([])
const loadingStudents = ref(false)

const fetchStudents = async () => {
  if (!props.selectedClass) return
  loadingStudents.value = true
  try {
    const res = await axios.get('/students/by-class', {
      params: {
        course: props.selectedClass.course,
        year: props.selectedClass.year,
        section: props.selectedClass.section
      }
    })
    students.value = res.data.student
  } catch (err) {
    console.error('Error fetching students:', err)
  } finally {
    loadingStudents.value = false
  }
}

const sortedStudents = computed(() => {
  return [...students.value].sort((a, b) => {
    if (a.gender !== b.gender) return a.gender === 'Male' ? -1 : 1
    return a.lname.localeCompare(b.lname)
  })
})

const close = () => emit('close')

watch(() => props.visible, async (val) => {
  if (val) {
    await fetchStudents()
  }
})
</script>

<style scoped>
.animate-fade-in-up {
  animation: fadeInUp 0.3s ease-out;
}
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(25px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
