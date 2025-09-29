<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="`TOR Requests`">
    <!-- Controls -->
    <div class="flex flex-col md:flex-row justify-between select-none items-center p-5">
      <div class="mb-2 md:mb-0">
        <label class="mr-2">Show</label>
        <select v-model="perPage" @change="updatePagination" class="border py-1 rounded">
          <option v-for="n in [10, 25, 50, 100]" :key="n" :value="n">{{ n }}</option>
        </select>
        <span class="ml-2">entries</span>
      </div>

      <div class="flex flex-col md:flex-row gap-2 items-center">
        <input
          v-model="search"
          @input="updatePagination"
          type="text"
          placeholder="Search requests..."
          class="border px-3 py-1 rounded w-full md:w-64"
        />
      </div>
    </div>

    <!-- Table -->
    <div class="p-4 space-y-6 animate-slide-in-top">
      <div class="overflow-x-auto rounded-lg border shadow">
        <table class="min-w-full bg-white text-sm">
          <thead class="bg-mcclightblue text-white">
            <tr>
              <th v-for="column in columns" :key="column.key"
                  class="px-4 py-2 text-center cursor-pointer select-none"
                  @click="toggleSort(column.key)">
                {{ column.label }}
                <span v-if="sortPriority.find(s => s.key === column.key)">
                  {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="req in paginatedRequests" :key="req.id" class="hover:bg-gray-100">
              <td class="px-4 py-2 text-center">{{ req.student_id }}</td>
              <td class="px-4 py-2 text-center">{{ req.lname }}</td>
              <td class="px-4 py-2 text-center">{{ req.fname }}</td>
              <td class="px-4 py-2 text-center">{{ req.mname }}</td>
              <td class="px-4 py-2 text-center">{{ new Date(req.requested_at).toLocaleDateString() }}</td>
              <td class="px-4 py-2 text-center select-none">
                <span
                  :class="{
                    'bg-red-100 text-red-500 px-2 py-1 rounded': req.status === 'pending',
                    'bg-blue-100 text-blue-500 px-2 py-1 rounded': req.status === 'processing',
                    'bg-green-100 text-green-500 px-2 py-1 rounded': req.status === 'completed'
                  }"
                >
                  {{ formatStatus(req.status) }}
                </span>
              </td>
              <td class="px-4 py-2 text-center">
                <button
                  @click="openModal(req)"
                  class="bg-mcclightblue text-white px-2 py-1 rounded hover:bg-mccblue transition select-none"
                >
                  View
                </button>
              </td>
            </tr>
            <tr v-if="paginatedRequests.length === 0">
              <td colspan="7" class="text-center py-4">No TOR requests found.</td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination -->
        <div class="flex justify-between bg-mcclightblue items-center px-2 text-sm text-white select-none">
          <div>
            Showing
            <span class="font-semibold">
              {{ paginatedRequests.length ? (currentPage - 1) * perPage + 1 : 0 }}
            </span>
            to
            <span class="font-semibold">
              {{ (currentPage - 1) * perPage + paginatedRequests.length }}
            </span>
            of
            <span class="font-semibold">{{ filteredRequests.length }}</span> entries
          </div>

          <div class="flex gap-1 items-center">
            <button @click="sortPriority = []" class="text-sm hover:bg-mccblue px-2 py-1 rounded transition">
              Clear Sorting
            </button>
            <button @click="currentPage--" :disabled="currentPage === 1"
              class="px-3 py-1 rounded disabled:opacity-50 hover:bg-mccblue transition">Prev</button>
            <button v-for="page in totalPages" :key="page" @click="currentPage = page"
              :class="[
                'px-3 py-1 rounded',
                currentPage === page
                  ? 'bg-white text-mccblue font-bold'
                  : 'hover:bg-mccblue transition'
              ]">
              {{ page }}
            </button>
            <button @click="currentPage++" :disabled="currentPage === totalPages"
              class="px-3 py-1 rounded disabled:opacity-50 hover:bg-mccblue transition">Next</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <Transition name="fade">
      <div v-if="showModal" class="fixed inset-0 z-50 bg-black bg-opacity-50 flex items-center justify-center">
        <div class="bg-white w-full max-w-4xl p-6 rounded-lg shadow-lg relative animate-fade-in-up max-h-[80vh] overflow-y-auto">
          <!-- Header -->
          <h2 class="text-xl sm:text-2xl font-bold mb-4 text-mccblue">
            TOR Request for {{ selectedReq.lname }}, {{ selectedReq.fname }}
          </h2>

          <!-- Status buttons -->
          <div class="flex gap-2 mb-4">
            <button @click="updateStatus(selectedReq.id, 'pending')" class="bg-green-500 text-white px-3 py-1 rounded select-none">
              Mark as Pending
            </button>
            <button @click="updateStatus(selectedReq.id, 'processing')" class="bg-green-500 text-white px-3 py-1 rounded select-none">
              Mark as Processing
            </button>
            <button @click="updateStatus(selectedReq.id, 'completed')" class="bg-green-500 text-white px-3 py-1 rounded select-none">
              Mark as Completed
            </button>
          </div>

          <!-- Two-column layout (until Place of Birth) -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- Left Form -->
            <form id="torForm" @submit.prevent="saveStudentInfo" class="space-y-3 md:col-span-2">
              <div class="grid grid-cols-2 gap-2">
                <input v-model="studentInfo.student_number" placeholder="Student Number" class="border p-2 rounded text-sm" readonly />
                <input v-model="studentInfo.sex" placeholder="Sex" class="border p-2 rounded text-sm" readonly />
              </div>
              <div class="grid grid-cols-3 gap-2">
                <input v-model="studentInfo.surname" placeholder="Last Name" class="border p-2 rounded text-sm" readonly />
                <input v-model="studentInfo.firstname" placeholder="First Name" class="border p-2 rounded text-sm" readonly />
                <input v-model="studentInfo.middlename" placeholder="Middle Name" class="border p-2 rounded text-sm" readonly />
              </div>
              <div class="grid grid-cols-3 gap-2">
                <select v-model="dob.month" @change="updateDays" class="border p-2 rounded text-sm">
                  <option disabled value="">Month</option>
                  <option v-for="(m, i) in months" :key="i" :value="i+1">{{ m }}</option>
                </select>
                <select v-model="dob.day" class="border p-2 rounded text-sm">
                  <option disabled value="">Day</option>
                  <option v-for="d in daysInMonth" :key="d" :value="d">{{ d }}</option>
                </select>
                <select v-model="dob.year" class="border p-2 rounded text-sm">
                  <option disabled value="">Year</option>
                  <option v-for="y in years" :key="y" :value="y">{{ y }}</option>
                </select>
              </div>
              <input v-model="studentInfo.place_of_birth" placeholder="Place of Birth" class="border p-2 rounded text-sm w-full" />
            </form>

            <div class="flex flex-col items-center">
              <div class="w-32 max-h-40 bg-gray-100 border-black flex items-center justify-center overflow-hidden mb-2 shrink-0">
                <img
                  v-if="studentInfo.picture"
                  :src="'data:image/jpeg;base64,' + studentInfo.picture"
                  alt="Preview"
                  class="w-full h-full object-cover"
                />
                <span v-else class="text-gray-400 text-xs">No Picture</span>
              </div>
              <input type="file" @change="handleImageUpload" accept="image/png, image/jpeg" class="text-xs" />
            </div>
          </div>

          <!-- Rest of fields (stacked full width) -->
          <div class="mt-4 space-y-3">
            <div class="grid grid-cols-3 gap-2">
              <input v-model="studentInfo.civil_status" placeholder="Civil Status" class="border p-2 rounded text-sm" />
              <input v-model="studentInfo.religion" placeholder="Religion" class="border p-2 rounded text-sm" />
              <input v-model="studentInfo.citizenship" placeholder="Citizenship" class="border p-2 rounded text-sm" />
            </div>
            <div class="grid grid-cols-2 gap-2">
              <input v-model="studentInfo.intermediate_school" placeholder="Intermediate School" class="border p-2 rounded text-sm" />
              <input v-model="studentInfo.intermediate_sy" placeholder="SY" class="border p-2 rounded text-sm" />
            </div>
            <div class="grid grid-cols-2 gap-2">
              <input v-model="studentInfo.highschool_school" placeholder="Highschool School" class="border p-2 rounded text-sm" />
              <input v-model="studentInfo.highschool_sy" placeholder="SY" class="border p-2 rounded text-sm" />
            </div>
            <input v-model="studentInfo.guardian_name" placeholder="Guardian / Parent Name" class="border p-2 rounded text-sm w-full" />
            <input v-model="studentInfo.home_address" placeholder="Home Address" class="border p-2 rounded text-sm w-full" />
            <input v-model="studentInfo.date_enrolled" placeholder="Date Enrolled (ex. May 21, 2018)" class="border p-2 rounded text-sm w-full" />
          </div>

          <!-- Footer -->
          <div class="flex justify-between mt-6">
            <button type="button" @click="closeModal" class="px-4 py-2 bg-red-500 text-white rounded">Close</button>
            <button type="submit" form="torForm" class="px-4 py-2 bg-mccblue text-white rounded hover:bg-mccdarkblue transition">Save & Print</button>
          </div>

          <!-- Close -->
          <button @click="closeModal" class="absolute top-4 right-4 text-xl text-gray-600 hover:text-red-500">&times;</button>
        </div>
      </div>
    </Transition>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import Swal from 'sweetalert2'

const fullname = ref('')
const userLevel = ref('')
const username = ref('')
const requests = ref([])

const search = ref('')
const sortPriority = ref([{ key: 'requested_at', direction: 'desc' }])
const perPage = ref(10)
const currentPage = ref(1)

const showModal = ref(false)
const selectedReq = ref({})
const studentInfo = ref({})
const dob = ref({ month: '', day: '', year: '' })

const months = ['January','February','March','April','May','June','July','August','September','October','November','December']
const years = Array.from({length: 80}, (_, i) => new Date().getFullYear() - i)

const daysInMonth = computed(() => {
  if (!dob.value.month || !dob.value.year) return []
  return Array.from({ length: new Date(dob.value.year, dob.value.month, 0).getDate() }, (_, i) => i + 1)
})
const updateDays = () => { if (dob.value.day > daysInMonth.value) dob.value.day = '' }

const columns = [
  { key: 'student_id', label: 'Student ID' },
  { key: 'lname', label: 'Last Name' },
  { key: 'fname', label: 'First Name' },
  { key: 'mname', label: 'Middle Name' },
  { key: 'requested_at', label: 'Date of Request' },
  { key: 'status', label: 'Status' },
  { key: 'actions', label: 'Actions' },
]

const fetchRequests = async () => {
  const res = await axios.get('/tor-requests/all')
  requests.value = res.data
}

const filteredRequests = computed(() => {
  const sorted = [...requests.value].sort((a, b) => {
    for (const s of sortPriority.value) {
      const key = s.key
      const dir = s.direction
      if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
      if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
    }
    return 0
  })
  return sorted.filter(r => Object.values(r).join(' ').toLowerCase().includes(search.value.toLowerCase()))
})

const paginatedRequests = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredRequests.value.slice(start, start + perPage.value)
})
const totalPages = computed(() => Math.ceil(filteredRequests.value.length / perPage.value))
const updatePagination = () => { currentPage.value = 1 }
const toggleSort = (key) => {
  const index = sortPriority.value.findIndex(s => s.key === key)
  if (index !== -1) {
    sortPriority.value[index].direction = sortPriority.value[index].direction === 'asc' ? 'desc' : 'asc'
  } else {
    sortPriority.value.push({ key, direction: 'asc' })
  }
}
const formatStatus = (status) => !status ? '' : status.charAt(0).toUpperCase() + status.slice(1)

const openModal = async (req) => {
  selectedReq.value = req

  // Default prefill from request table
  studentInfo.value = {
    tor_request_id: req.id,
    student_number: req.student_id,
    surname: req.lname,
    firstname: req.fname,
    middlename: req.mname,
    sex: req.gender || '',
    course: req.course || '',
    dob_month: '',
    dob_day: '',
    dob_year: '',
    place_of_birth: '',
    civil_status: '',
    religion: '',
    citizenship: '',
    intermediate_sy: '',
    intermediate_school: '',
    highschool_sy: '',
    highschool_school: '',
    guardian_name: '',
    home_address: '',
    date_enrolled: '',
    picture: ''
  }

  try {
    const res = await axios.get(`/tor-requests/${req.id}/student-info`)
    if (res.data && Object.keys(res.data).length > 0) {
      studentInfo.value = { ...studentInfo.value, ...res.data }

      // Sync DOB into dropdowns
      if (studentInfo.value.dob_month) {
        dob.value.month = months.findIndex(m => m === studentInfo.value.dob_month) + 1
      }
      if (studentInfo.value.dob_day) {
        dob.value.day = Number(studentInfo.value.dob_day)
      }
      if (studentInfo.value.dob_year) {
        dob.value.year = Number(studentInfo.value.dob_year)
      }
    }
  } catch (err) {
    console.error('Error fetching student info', err)
  }

  showModal.value = true
}

const closeModal = () => { showModal.value = false }

const updateStatus = async (id, status) => {
  try {
    await axios.post(`/tor-requests/${id}/update-status`, { status })
    fetchRequests()
    Swal.fire({
      icon: 'success',
      title: `Status updated to ${status.charAt(0).toUpperCase() + status.slice(1)}`,
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (err) {
    console.error('Failed to update status', err)
  }
}
const saveStudentInfo = async () => {
  try {
    studentInfo.value.dob_month = months[dob.value.month - 1] || ''
    studentInfo.value.dob_day = dob.value.day ? String(dob.value.day) : ''
    studentInfo.value.dob_year = dob.value.year ? String(dob.value.year) : ''

    const res = await axios.post('/tor-requests/save-student-info', studentInfo.value)

    // ✅ On success, open print view
    if (res.data.success) {
      const url = route('tor.print', { request_id: selectedReq.value.id })
      window.open(url, '_blank')
      closeModal()
    }
  } catch (err) {
    console.error('Failed to save student info', err)
    Swal.fire('Error', 'Could not save TOR student info', 'error')
  }
}
const handleImageUpload = (e) => {
  const file = e.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = () => { studentInfo.value.picture = reader.result.split(',')[1] }
    reader.readAsDataURL(file)
  }
}

const fetchSession = async () => {
  try {
    const res = await axios.get('/session')
    fullname.value = res.data.fullname
    userLevel.value = res.data.level
    username.value = res.data.username
    if (!fullname.value || !userLevel.value) window.location.href = '/'
  } catch { window.location.href = '/' }
}
onMounted(() => { fetchSession(); fetchRequests() })
</script>

<style scoped>
.animate-fade-in-up { animation: fadeInUp 0.3s ease-out; }
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(25px); }
  to { opacity: 1; transform: translateY(0); }
}
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
