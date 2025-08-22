<template>
  <div>
    <!-- Trigger Button -->
    <button
      @click="openModal"
      class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-lg shadow-md transition"
    >
      <p class="text-xs md:text-base select-none">+ Add Student</p>
    </button>

    <!-- Modal -->
    <Transition name="fade">
      <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white w-full max-w-3xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">

          <!-- Back button for Step 2 -->
          <button
            v-if="currentStep === 2"
            @click="goBack"
            class="absolute top-4 left-4 text-gray-500 text-lg hover:text-mccblue transition mt-[9px]"
          >
            ← Back
          </button>

          <h2 class="text-xl font-bold mb-4 text-mccblue select-none text-center">
            {{ currentStep === 1
              ? (editMode ? 'Edit Student' : 'Add New Student')
              : 'Select Subjects for ' + form.fname + ' ' + form.lname
            }}
          </h2>

          <!-- Fixed size container for both steps -->
          <div class="relative w-full h-[600px] overflow-hidden">

            <!-- Step 1: Student Form -->
            <Transition name="slide-left-right">
              <form
                v-if="currentStep === 1"
                @submit.prevent="handleSubmit"
                class="absolute top-0 left-0 w-full h-full grid grid-cols-1 md:grid-cols-2 gap-4 overflow-y-auto pr-2"
              >

                <div class="ml-1">
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Student ID</label>
                  <input
                    type="text"
                    v-model="form.studid"
                    @input="formatStudid"
                    placeholder="e.g. 2024-0001"
                    maxlength="9"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">First Name</label>
                  <input
                    type="text"
                    v-model="form.fname"
                    placeholder="e.g. Hasan"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  />
                </div>

                <div class="ml-1">
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Middle Name</label>
                  <input
                    type="text"
                    v-model="form.mname"
                    placeholder="Leave Blank if N/A"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Last Name</label>
                  <input
                    type="text"
                    v-model="form.lname"
                    placeholder="e.g. Syed"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  />
                </div>

                <div class="ml-1">
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Email</label>
                  <input
                    type="email"
                    v-model="form.email"
                    placeholder="e.g. hasanmangubat@gmail.com"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Year</label>
                  <select
                    v-model="form.year"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  >
                    <option value="" disabled>Select Year</option>
                    <option v-for="y in [1,2,3,4]" :key="y" :value="y">{{ y }}</option>
                  </select>
                </div>

                <div class="ml-1">
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Section</label>
                  <select
                    v-model="form.section"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  >
                    <option value="" disabled>Select Section</option>
                    <option v-for="section in sections" :key="section" :value="section">{{ section }}</option>
                  </select>

                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Semester</label>
                  <select
                    v-model="form.semester"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  >
                    <option value="" disabled>Select Semester</option>
                    <option value="First Semester">First Semester</option>
                    <option value="Second Semester">Second Semester</option>
                    <option value="Summer">Summer</option>
                  </select>
                </div>

                <div class="ml-1">
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Academic Year</label>
                  <select
                    v-model="form.ay"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  >
                    <option value="" disabled>Select Academic Year</option>
                    <option v-for="ay in academicYears" :key="ay" :value="ay">{{ ay }}</option>
                  </select>

                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Gender</label>
                  <select
                    v-model="form.gender"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    required
                  >
                    <option value="" disabled>Select Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                  </select>
                </div>

                <div class="ml-1">
                  <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Student Type</label>
                  <select
                    v-model="form.regular"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  >
                    <option :value="1">Regular</option>
                    <option :value="0">Irregular</option>
                  </select>
                </div>

                <!-- Actions -->
                <div class="md:col-span-2 flex justify-end gap-4 pt-4">
                  <button
                    type="button"
                    @click="cancelEdit"
                    class="text-gray-500 hover:text-red-500 transition"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition"
                  >
                    {{ form.regular == 0 ? 'Next' : 'Save' }}
                  </button>
                </div>
              </form>
            </Transition>

            <!-- Step 2: Subject Selection -->
            <Transition name="slide-left-right">
              <div v-if="currentStep === 2" class="absolute top-0 left-0 w-full h-full p-4 flex flex-col">
                <div class="flex items-center justify-between mb-4">
                  <h2 class="text-xl font-bold text-mccblue select-none">{{ form.fname }} {{ form.lname }} - Subjects</h2>
                </div>

                <!-- Searchable Subject Input + Dropdown -->
                <div class="relative mb-4">
                  <input
                    v-model="subjectSearch"
                    @input="filterSubjects"
                    placeholder="Type to search subject"
                    class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
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

                <!-- Added Subjects List -->
                <ul class="mb-4 flex-1 overflow-y-auto">
                  <li
                    v-for="subject in selectedSubjects"
                    :key="subject.id"
                    class="flex justify-between items-center bg-gray-100 text-gray-800 px-3 py-2 mb-2 rounded-md"
                  >
                    <span>{{ subject.title }}</span>
                    <button @click="removeSubject(subject)" class="text-red-500 hover:text-red-700">-</button>
                  </li>
                </ul>

                <!-- Save Button -->
                <div class="flex justify-end gap-4 mt-auto pt-4">
                  <button @click="submitIrregSubjects" class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition">
                    Save
                  </button>
                </div>
              </div>
            </Transition>

          </div>

          <!-- Close Button -->
          <button
            @click="cancelEdit"
            class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition mt-[6px]"
          >
            &times;
          </button>

        </div>
      </div>
    </Transition>
  </div>
</template>



<script setup>
import { ref, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const emit = defineEmits(['submitted', 'cancelEdit'])

const props = defineProps({
  course: String,
  editMode: Boolean,
  studentToEdit: Object,
})

const isOpen = ref(false)
const currentStep = ref(1)

const allSubjects = ref([])
const selectedSubjects = ref([])
const selectedSubjectToAdd = ref(null)
const subjectSearch = ref('')
const filteredSubjects = ref([])
const sections = ref([])
const academicYears = ref([])

const filterSubjects = () => {
  const search = subjectSearch.value.toLowerCase()
  filteredSubjects.value = allSubjects.value.filter(s =>
    s.title.toLowerCase().includes(search)
  )
}

const selectSubject = (subject) => {
  if (!selectedSubjects.value.some(s => s.id === subject.id)) {
    selectedSubjects.value.push(subject)
  }
  subjectSearch.value = ''
  filteredSubjects.value = []
}

const addSubject = () => {
  if (selectedSubjectToAdd.value && !selectedSubjects.value.find(s => s.id === selectedSubjectToAdd.value.id)) {
    selectedSubjects.value.push(selectedSubjectToAdd.value)
    selectedSubjectToAdd.value = null
  }
}

const removeSubject = (subject) => {
  selectedSubjects.value = selectedSubjects.value.filter(s => s.id !== subject.id)
}


const form = ref({
  studid: '',
  fname: '',
  mname: '',
  lname: '',
  email: '',
  course: props.course || '',
  year: '',
  section: '',
  semester: '',
  ay: '',
  gender: '',
  regular: 1,
})

const resetForm = () => {
  form.value = {
    studid: '',
    fname: '',
    mname: '',
    lname: '',
    email: '',
    course: props.course || '',
    year: '',
    section: '',
    semester: '',
    ay: '',
    gender: '',
    regular: 1,
  }
  currentStep.value = 1
  allSubjects.value = []
  selectedSubjects.value = []
}

const openModal = async () => {
  if (!props.editMode) {
    resetForm()
    isOpen.value = true
  }

  await fetchSections()
  await fetchAcademicYears()
}


const cancelEdit = () => {
  isOpen.value = false
  resetForm()
  emit('cancelEdit')
}

watch(
  () => props.studentToEdit,
  async (student) => {
    if (props.editMode && student) {
      form.value = { ...student }
      isOpen.value = true

      if (student.regular == 0) {
        await fetchSubjects()
        await fetchExistingIrregSubjects(student.studid)
      }
    }
  },
  { immediate: true }
)


const handleSubmit = async () => {
  // Check if studid exists only when adding new
  if (!props.editMode) {
    const exists = await checkStudidExists(form.value.studid)
    if (exists) {
      Swal.fire('Error', 'Student ID already exists. Please use a unique ID.', 'error')
      return
    }
  }

  if (form.value.regular == 0 && currentStep.value == 1) {
    await fetchSubjects()
    currentStep.value = 2
    return
  }

  try {
    if (props.editMode && props.studentToEdit?.id) {
      await axios.put(`/students/${props.studentToEdit.id}`, form.value)
      Swal.fire({
        icon: 'success',
        title: 'Student Updated',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } else {
      console.log('Form payload:', form.value)
      await axios.post('/students', form.value)
      Swal.fire({
        icon: 'success',
        title: 'Student Added',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }

    resetForm()
    isOpen.value = false
    emit('submitted')
  } catch (error) {
    if (error.response && error.response.status === 422) {
      console.error('Validation errors:', error.response.data.errors)
      Swal.fire('Validation Error', 'Please check form fields.', 'error')
    } else {
      console.error('Error saving student:', error)
      Swal.fire('Error', 'Could not save student', 'error')
    }
  }
}




const goBack = () => {
  currentStep.value = 1
}

const fetchSubjects = async () => {
  try {
    const res = await axios.get(`/api/allsubjects/${form.value.course}`)
    allSubjects.value = res.data
  } catch (e) {
    console.error('Failed to load subjects', e)
  }
}

const submitIrregSubjects = async () => {
  try {
    if (props.editMode) {
      // Update student data first
      await axios.put(`/students/${props.studentToEdit.id}`, form.value)

      // Update irregular subjects
      await axios.put(`/api/irregstudentsubject/${form.value.studid}`, {
        subjects: selectedSubjects.value,
      })
    } else {
      // Add new student first
      await axios.post('/students', form.value)

      // Add irregular subjects
      await axios.post('/api/irregstudentsubject', {
        studid: form.value.studid,
        subjects: selectedSubjects.value,
      })
    }

    Swal.fire({
      icon: 'success',
      title: props.editMode ? 'Student Updated' : 'Student Added',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })

    resetForm()
    isOpen.value = false
    emit('submitted')
  } catch (error) {
    console.error('Error saving irregular subjects:', error)
    Swal.fire('Error', 'Could not save irregular student subjects', 'error')
  }
}


// Auto-format Student ID as YYYY-NNNN and block excess characters
const formatStudid = () => {
  let raw = form.value.studid.replace(/\D/g, '')
  if (raw.length > 8) raw = raw.slice(0, 8)
  if (raw.length > 4) {
    raw = raw.slice(0, 4) + '-' + raw.slice(4)
  }
  form.value.studid = raw
}


// Fetch existing subjects for an irregular student
const fetchExistingIrregSubjects = async (studid) => {
  try {
    const res = await axios.get(`/api/irregstudentsubject/${studid}`)
    selectedSubjects.value = res.data
  } catch (e) {
    console.error('Failed to load existing irregular subjects:', e)
  }
}

// Update irregular student subjects
const updateIrregSubjects = async () => {
  try {
    await axios.put(`/api/irregstudentsubject/${form.value.studid}`, {
      studid: form.value.studid,
      subjects: selectedSubjects.value,
    })
    Swal.fire({
      icon: 'success',
      title: 'Irregular Subjects Updated',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Error updating irregular subjects:', error)
    Swal.fire('Error', 'Could not update irregular subjects', 'error')
  }
}



const fetchSections = async () => {
  try {
    const res = await axios.get('/api/sections')
    sections.value = res.data
  } catch (error) {
    console.error('Failed to fetch sections:', error)
  }
}

const fetchAcademicYears = async () => {
  try {
    const res = await axios.get('/api/academicyears')
    academicYears.value = res.data
  } catch (error) {
    console.error('Failed to fetch academic years:', error)
  }
}

const checkStudidExists = async (studid) => {
  try {
    const res = await axios.get(`/api/students/check/${studid}`)
    return res.data.exists
  } catch (error) {
    console.error('Failed to check studid:', error)
    return false // default to false to not block accidentally
  }
}


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
.slide-left-right-enter-active, .slide-left-right-leave-active {
  transition: transform 0.3s ease, opacity 0.3s ease;
  position: absolute;
  width: 100%;
  height: 100%;
}

.slide-left-right-enter-from {
  transform: translateX(100%);
  opacity: 0;
}

.slide-left-right-leave-to {
  transform: translateX(-100%);
  opacity: 0;
}

</style>
