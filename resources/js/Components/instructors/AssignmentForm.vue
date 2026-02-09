<template>
  <div>
    <!-- Modal -->
    <Transition name="fade">
      <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white w-full max-w-3xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">
          
          <!-- 🔷 Title -->
          <h2 class="text-xl font-bold mb-4 text-mccblue select-none">
            {{ instructor.fname }} {{ instructor.lname }} – Assigned Subjects & Classes
          </h2>

          <!-- ➕ Assign Button -->
          <div class="flex justify-end mb-2">
            <button
              @click="toggleAssignForm"
              class="bg-mccblue hover:bg-mccdarkblue text-white px-3 py-1 rounded-md transition mr-[20px] mt-[-45px] mb-4"
            >
              {{ showAssignForm ? 'Cancel' : '+ Assign Subject' }}
            </button>
          </div>

          <!-- 📋 Existing Assignments Table -->
          <div class="min-w-full bg-white rounded mb-4 overflow-y-auto" :class="assignments.length > 5 ? 'max-h-64' : ''">
            <div v-if="loadingAssignments" class="flex justify-center py-4">
              <svg class="animate-spin h-8 w-8 text-mccblue" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
              </svg>
            </div>

            <table v-else class="min-w-full border border-gray-300 rounded">
              <thead class="bg-mcclightblue text-white">
                <tr>
                  <th class="px-4 py-2">Subject</th>
                  <th class="px-4 py-2">Class</th>
                  <th class="px-4 py-2">Year</th>
                  <th class="px-4 py-2">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="a in assignments" :key="a.id" class="text-center border-t border-gray-200">
                  <td class="px-4 py-2">{{ a.subject_name }}</td>
                  <td class="px-4 py-2">{{ a.course }} {{ a.year }}-{{ a.section }}</td>
                  <td class="px-4 py-2">{{ a.year }}</td>
                  <td class="px-4 py-2">
                    <button
                      @click="deleteAssignment(a.id)"
                      class="text-red-500 hover:text-red-700 text-md transition"
                      title="Delete assignment"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
                <tr v-if="assignments.length === 0">
                  <td colspan="4" class="py-4 text-gray-500 text-center">No assignments yet.</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- ➕ Assign Form (Hidden by default) -->
          <form v-if="showAssignForm" @submit.prevent="handleSubmit" class="space-y-4 mb-4">
            <!-- Subject input with datalist -->
            <div class="relative">
              <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Subject</label>
              <input
                v-model="subjectSearch"
                @input="filterSubjects"
                placeholder="Type to search subject..."
                class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                required
              />

              <div v-if="filteredSubjects.length" class="absolute z-10 w-full bg-white border border-gray-300 rounded-md mt-1 max-h-40 overflow-y-auto">
                <div
                  v-for="subject in filteredSubjects"
                  :key="subject.id"
                  @click="selectSubject(subject)"
                  class="px-3 py-2 hover:bg-gray-200 text-gray-800 cursor-pointer"
                >
                  {{ subject.title }}
                </div>
              </div>
            </div>

            <div class="grid grid-cols-3 gap-2">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Course</label>
                <select v-model="form.course" class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition" required>
                  <option value="" disabled>Select course</option>
                  <option v-for="c in courses" :key="c">{{ c }}</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Year</label>
                <select v-model="form.year" class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition" required>
                  <option value="" disabled>Select year</option>
                  <option v-for="y in [1,2,3,4]" :key="y">{{ y }}</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Section</label>
                <select v-model="form.section" class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition" required>
                  <option value="" disabled>Select section</option>
                  <option v-for="s in sections" :key="s">{{ s }}</option>
                </select>
              </div>
            </div>

            <!-- Save Button -->
            <div class="flex justify-end pt-2">
              <button type="submit" class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition">
                Save Assignment
              </button>
            </div>
          </form>

          <!-- Close Button -->
          <button @click="closeModal" class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition">
            &times;
          </button>
        </div>
      </div>
    </Transition>
  </div>
</template>


<script setup>
import { ref, watch, nextTick} from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const props = defineProps({
  instructor: Object,
  course: String,
})

const loadingAssignments = ref(false)
const isOpen = ref(false)
const showAssignForm = ref(false)
const subjects = ref([])
const assignments = ref([])

const courses = ['BSIT','BSBA','BSHM','BSED','BEED']
const sections = ['North','East','West','South','Northeast','Northwest','Southeast','Southwest','Nihonggo','Mandarin','German','Spanish']

const form = ref({
  teacher_id: props.instructor?.id || '',
  subject_input: '',
  subject_id: '',
  course: '',
  year: '',
  section: '',
})

const fetchSubjects = async () => {
  try {
    const res = await axios.get(`/api/allsubjects`)
    // const res = await axios.get(`/api/allsubjects/${props.course}`)   <---- for filtering by course
    subjects.value = res.data
  } catch (e) {
    console.error('Failed to load subjects', e)
  }
}

const subjectSearch = ref('')
const filteredSubjects = ref([])

const filterSubjects = () => {
  const search = subjectSearch.value.toLowerCase()
  filteredSubjects.value = subjects.value.filter(s =>
    s.title.toLowerCase().includes(search)
  )
}

const selectSubject = (subject) => {
  form.value.subject_id = subject.id
  form.value.subject_input = subject.title

  
  form.value.course = subject.course
  form.value.year = subject.year

  subjectSearch.value = subject.title
  filteredSubjects.value = []
}



const fetchAssignments = async () => {
  if (!props.instructor?.id) {
    return
  }
  try {
    const res = await axios.get(`/api/instructors/${props.instructor.id}/assignments`)
    assignments.value = res.data
  } catch (e) {
    console.error('Failed to load assignments', e)
  } finally {
    loadingAssignments.value = false
  }
}

const deleteAssignment = async (assignmentId) => {
  const confirm = await Swal.fire({
    title: 'Are you sure?',
    text: "This will remove the assigned subject.",
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Yes',
  });

  if (confirm.isConfirmed) {
    try {
      await axios.delete(`/instructors/${props.instructor.id}/assignments/${assignmentId}`)
      Swal.fire({
      icon: 'success',
      title: 'Assignment removed.',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
      fetchAssignments()
    } catch (err) {
      console.error(err)
      Swal.fire('Error', 'Could not delete assignment', 'error')
    }
  }
}


const openModal = async () => {
  isOpen.value = true
  assignments.value = [] // clear old data
  loadingAssignments.value = true

  await nextTick() // force DOM update before fetching

  fetchSubjects()
  fetchAssignments()
}

const closeModal = () => {
  isOpen.value = false
  showAssignForm.value = false
  assignments.value = []
  resetForm()
}

const toggleAssignForm = () => {
  showAssignForm.value = !showAssignForm.value
  if (!showAssignForm.value) resetForm()
}

const resetForm = () => {
  form.value.subject_input = ''
  form.value.subject_id = ''
  form.value.course = ''
  form.value.year = ''
  form.value.section = ''

  subjectSearch.value = ''
  filteredSubjects.value = []
}


watch(
  () => props.instructor,
  (newVal) => {
    if (newVal && newVal.id) {
      console.log("View subjects clicked:")
      console.log("instructor id:", newVal.id)
      console.log("instructor course:", props.course)
      openModal()
    }
  },
  { immediate: true }
)



const handleSubmit = async () => {
  if (!form.value.subject_id) {
    Swal.fire('Error', 'Please select a subject from the list.', 'error')
    return
  }

  try {
    await axios.post(`/instructors/${props.instructor.id}/assign-subject`, {
      subject_id: form.value.subject_id,
      course: form.value.course,
      year: form.value.year,
      section: form.value.section,
    })
    Swal.fire({
      icon: 'success',
      title: 'Assignment saved',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
    fetchAssignments()
    resetForm()
  } catch (err) {
    console.error(err)

    let message = 'Could not save assignment'
    if (err.response && err.response.data && err.response.data.message) {
      message = err.response.data.message
    }

    Swal.fire('Error', message, 'error')
  }
}


defineExpose({ openModal })
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
