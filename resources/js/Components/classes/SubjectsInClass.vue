<template>
  <Transition name="fade">
    <div v-if="visible" class="fixed inset-0 z-50 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white w-full max-w-5xl p-6 rounded-lg shadow-lg relative overflow-y-auto max-h-[90vh] animate-fade-in-up">
        <h2 class="text-xl sm:text-2xl font-bold mb-4 text-mccblue">
          Subjects in {{ selectedClass.name }} 
        </h2>

        <!-- 🔄 Loading spinner -->
        <div v-if="loadingSubjects" class="flex justify-center py-4">
          <svg class="animate-spin h-8 w-8 text-mccblue" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
          </svg>
        </div>

        <!-- ✅ Main Content -->
        <div v-else>
          <!-- Student List -->
          <div class="overflow-x-auto rounded-lg border shadow">
            <table class="min-w-full text-xs sm:text-sm bg-white">
              <thead class="bg-mcclightblue text-white">
                <tr>
                  <th class="px-2 sm:px-4 py-2">Subject Code</th>
                  <th class="px-2 sm:px-4 py-2">Description</th>
                  <th class="px-2 sm:px-4 py-2">Instructor</th>
                  <th class="px-2 sm:px-4 py-2">Status</th>
                  <th class="px-2 sm:px-4 py-2 text-center">Action</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="subject in subjects" :key="subject.id" class="hover:bg-gray-100">
                  <td class="px-2 sm:px-4 py-2">{{ subject.code }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ subject.title }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ subject.instructor}}</td>
                  <td class="px-2 sm:px-4 py-2"> Not submitted</td>
                  <td class="px-2 sm:px-4 py-2 text-center space-x-2">
                  <!-- <button class="text-green-600 select-none hover:underline" @click.stop="viewGradeSheet(classItem)">View </button> -->
                  <button class="text-blue-600 select-none hover:underline" @click="printGradeSheet(subject, selectedClass)">Print</button>
                  </td>
                </tr>
                <tr v-if="subjects.length === 0">
                  <td colspan="6" class="text-center py-4">No subjects in this class.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Close -->
        <button @click="close" class="absolute top-4 right-4 text-xl text-gray-600 hover:text-red-500">
          &times;
        </button>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import axios from 'axios'
import { router } from '@inertiajs/vue3'

const props = defineProps({
  visible: Boolean,
  selectedClass: Object,
})
const emit = defineEmits(['close', 'updated'])

const subjects = ref([])
const loadingSubjects = ref(false)


const fetchSubjects = async () => {
  if (!props.selectedClass?.id) return
  loadingSubjects.value = true
  try {
    const res = await axios.get(`/classes/${props.selectedClass.id}/subjects`)
    subjects.value = res.data.subjects
  } catch (err) {
    console.error('Error fetching subjects:', err)
  } finally {
    loadingSubjects.value = false
  }
}

function printGradeSheet(subject, selectedClass) {
  const url = route('gradesheet.print', {
    subject_id: subject.id,
    course: selectedClass.course,
    year: selectedClass.year,
    section: selectedClass.section,
    ay_id: subject.ay_id,
    teacher_id: subject.teacher_id
  })

  // Open in a new tab instead of replacing current page
  window.open(url, '_blank')
}


const close = () => emit('close')

watch(() => props.visible, async (val) => {
  if (val) {
    loadingSubjects.value = true
    await fetchSubjects()
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