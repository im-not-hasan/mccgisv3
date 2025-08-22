<template>
  <Transition name="fade">
    <div v-if="visible" class="fixed inset-0 z-50 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white w-full max-w-4xl p-6 rounded-lg shadow-lg relative overflow-y-auto max-h-[90vh] animate-fade-in-up">
        <h2 class="text-xl sm:text-2xl font-bold mb-4 text-mccblue">
          Students in {{ selectedClass.name }} 
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
          <!-- Add Student Combobox -->
          <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1">Add Student</label>
            <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-2">
              <input
                v-model="studentSearch"
                type="text"
                placeholder="Search student by name..."
                class="w-full border rounded px-3 py-2 text-xs sm:text-sm"
                @input="filterAvailableStudents"
              />
              <button
                @click="addStudent"
                :disabled="!selectedStudentId"
                class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded text-xs sm:text-sm"
              >
                Add
              </button>
            </div>
            <ul v-if="filteredStudents.length && studentSearch" class="mt-2 border rounded bg-white shadow max-h-40 overflow-auto text-xs sm:text-sm">
              <li
                v-for="student in filteredStudents"
                :key="student.id"
                class="px-4 py-2 hover:bg-mcclightblue hover:text-white cursor-pointer"
                @click="selectStudent(student)"
              >
                {{ formatName(student) }} ({{ student.gender }})
              </li>
            </ul>
          </div>

          <!-- Student List -->
          <div class="overflow-x-auto rounded-lg border shadow">
            <table class="min-w-full text-xs sm:text-sm bg-white">
              <thead class="bg-mcclightblue text-white">
                <tr>
                  <th class="px-2 sm:px-4 py-2">Student ID</th>
                  <th class="px-2 sm:px-4 py-2">Last Name</th>
                  <th class="px-2 sm:px-4 py-2">First Name</th>
                  <th class="px-2 sm:px-4 py-2">Middle Name</th>
                  <th class="px-2 sm:px-4 py-2 text-center">Gender</th>
                  <th class="px-2 sm:px-4 py-2 text-center">Action</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="student in sortedStudents" :key="student.id" class="hover:bg-gray-100">
                  <td class="px-2 sm:px-4 py-2">{{ student.studid }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ student.lname }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ student.fname }}</td>
                  <td class="px-2 sm:px-4 py-2">{{ student.mname }}</td>
                  <td class="px-2 sm:px-4 py-2 text-center">{{ student.gender }}</td>
                  <td class="px-2 sm:px-4 py-2 text-center">
                    <button @click="removeStudent(student.id)" class="text-red-600 hover:underline">Delete</button>
                  </td>
                </tr>
                <tr v-if="students.length === 0">
                  <td colspan="6" class="text-center py-4">No students in this class.</td>
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
import Swal from 'sweetalert2'

const props = defineProps({
  visible: Boolean,
  selectedClass: Object,
})
const emit = defineEmits(['close', 'updated'])

const students = ref([])
const allPossibleStudents = ref([])
const studentSearch = ref('')
const selectedStudentId = ref(null)
const filteredStudents = ref([])
const loadingStudents = ref(false)

const formatName = (student) =>
  `${student.lname}, ${student.fname} ${student.mname || ''}`.trim()

const fetchStudents = async () => {
  if (!props.selectedClass?.id) return
  loadingStudents.value = true
  try {
    const res = await axios.get(`/classes/${props.selectedClass.id}/students`)
    students.value = res.data.students
  } catch (err) {
    console.error('Error fetching students:', err)
  } finally {
    loadingStudents.value = false
  }
}

const fetchEligibleStudents = async () => {
  try {
    const res = await axios.get('/students', {
      params: {
        course: props.selectedClass.course,
        year: props.selectedClass.year,
      },
    })
    allPossibleStudents.value = res.data.students
  } catch (err) {
    console.error('Error fetching eligible students:', err)
  }
}

const sortedStudents = computed(() => {
  return [...students.value]
    .sort((a, b) => {
      if (a.gender !== b.gender) return a.gender === 'Male' ? -1 : 1
      return a.lname.localeCompare(b.lname)
    })
})

const filterAvailableStudents = () => {
  const searchTerm = studentSearch.value.toLowerCase()
  filteredStudents.value = allPossibleStudents.value
    .filter(s =>
      formatName(s).toLowerCase().includes(searchTerm) &&
      !students.value.some(existing => existing.id === s.id)
    )
}

const selectStudent = (student) => {
  studentSearch.value = formatName(student)
  selectedStudentId.value = student.id
  filteredStudents.value = []
}

const addStudent = async () => {
  if (!selectedStudentId.value) return
  try {
    await axios.post(`/classes/${props.selectedClass.id}/students`, {
      student_id: selectedStudentId.value,
    })
    Swal.fire('Added', 'Student added to class', 'success')
    selectedStudentId.value = null
    studentSearch.value = ''
    await fetchStudents()
    emit('updated')
  } catch (err) {
    console.error('Error adding student:', err)
    Swal.fire('Error', 'Failed to add student', 'error')
  }
}

const removeStudent = async (studentId) => {
  try {
    await axios.delete(`/classes/${props.selectedClass.id}/students/${studentId}`)
    Swal.fire('Deleted', 'Student removed from class', 'success')
    await fetchStudents()
    emit('updated')
  } catch (err) {
    console.error('Error removing student:', err)
    Swal.fire('Error', 'Failed to remove student', 'error')
  }
}

const close = () => emit('close')

watch(() => props.visible, async (val) => {
  if (val) {
    loadingStudents.value = true
    await fetchStudents()
    await fetchEligibleStudents()
    studentSearch.value = ''
    selectedStudentId.value = null
    filteredStudents.value = []
    loadingStudents.value = false
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