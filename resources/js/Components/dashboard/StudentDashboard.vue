<template>
  <div>
    <div v-if="loading" class="text-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue mx-auto" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
      <div v-if="student" class="bg-white rounded shadow p-4 mb-4 flex justify-between items-center mr-[2px]">
        <div>
          <h1 class="md:text-2xl font-bold text-mccblue">Welcome, {{ student.fullname }}</h1>
          <p class="md:text-base text-sm text-gray-700">
            ID: <span class=" font-medium">{{ student.id }}</span> |
            {{ student.course }} {{ student.year }}-{{ student.section }}
          </p>
        </div>
        <div>
          <button
            @click="confirmTORRequest"
            class="md:px-4 md:py-2 px-2 py-2 md:text-base text-sm bg-mccblue hover:bg-mccdarkblue text-white rounded-md font-medium transition"
            :disabled="loadingRequest"
          >
            {{ loadingRequest ? 'Requesting…' : 'Request TOR' }}
          </button>
        </div>
      </div>

      <div class="p-1 mb-4">
        <!-- Header Summary -->
        <div class="mb-4">
          <p class="text-gray-600 mt-1">
            You are enrolled in {{ totalSubjects }} unique subject<span v-if="totalSubjects !== 1">s</span> this semester.
          </p>
        </div>

        <!-- Controls -->
        <div class="flex flex-col md:flex-row justify-between items-center mb-4 mr-[2px]">
          <div class="mb-2 md:mb-0">
            <label class="mr-2">Show</label>
            <select v-model="perPage" @change="updatePagination" class="border py-1 rounded">
              <option v-for="n in [10, 25, 50, 100]" :key="n" :value="n">{{ n }}</option>
            </select>
            <span class="ml-2">entries</span>
          </div>

          <input
            v-model="search"
            @input="updatePagination"
            type="text"
            placeholder="Search subjects..."
            class="border px-3 py-1 rounded w-full md:w-64"
          />
        </div>

        <!-- Loading Spinner -->
        <div v-if="loading" class="flex justify-center py-10">
          <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
          </svg>
        </div>

        <!-- Table -->
        <div v-else>
          <table class="min-w-full bg-white shadow rounded-lg overflow-hidden ml-[-2px]">
            <thead class="bg-mcclightblue text-white">
              <tr>
                <th
                  v-for="column in columns"
                  :key="column.key"
                  class="md:py-2 md:px-4 md:text-base text-sm text-center cursor-pointer select-none"
                  @click="toggleSort(column.key)"
                >
                  {{ column.label }}
                  <span v-if="sortPriority.find(s => s.key === column.key)">
                    {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
                  </span>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in paginatedSubjects" :key="row.code" class="hover:bg-gray-100">
                <td class="py-2 px-4 font-medium text-center">{{ row.code }}</td>
                <td class="py-2 px-4 text-center">{{ row.title }}</td>
                <td class="py-2 px-4 text-center">{{ row.instructor }}</td>
                <td class="py-2 px-4 text-center">{{ row.grade ? Number(row.grade).toFixed(1) : "-"  }}</td>
              </tr>
              <tr v-if="paginatedSubjects.length === 0">
                <td colspan="4" class="text-center py-4">
                  <svg class="animate-spin h-8 w-8 text-mccblue mx-auto" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
                  </svg>
                </td>
              </tr>
            </tbody>
          </table>

          <!-- Pagination Controls -->
          <div class="flex justify-between bg-mcclightblue items-center px-2 md:text-sm text-xs text-white select-none rounded-b-lg">
            <div>
              Showing
              <span class="font-semibold">
                {{ paginatedSubjects.length ? (currentPage - 1) * perPage + 1 : 0 }}
              </span>
              to
              <span class="font-semibold">
                {{ (currentPage - 1) * perPage + paginatedSubjects.length }}
              </span>
              of
              <span class="font-semibold">{{ filteredSubjects.length }}</span> entries
            </div>

            <div class="flex gap-1">
              <button @click="sortPriority = []" class="md:text-sm text-xs hover:bg-mccblue px-2 py-1 rounded transition">
                Clear Sorting
              </button>

              <button
                @click="currentPage--"
                :disabled="currentPage === 1"
                class="px-3 py-1 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue"
              >
                Prev
              </button>

              <button
                v-for="page in totalPages"
                :key="page"
                @click="currentPage = page"
                :class="[
                  'px-3 py-1 rounded',
                  currentPage === page
                    ? 'bg-white text-mccblue font-bold'
                    : 'hover:bg-mccblue transition'
                ]"
              >
                {{ page }}
              </button>

              <button
                @click="currentPage++"
                :disabled="currentPage === totalPages"
                class="px-3 py-1 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition"
              >
                Next
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- 📝 Announcements Section -->
      <div class="bg-white rounded shadow p-6 mr-[2px]">
        <h2 class="text-lg font-semibold mb-4">Announcements</h2>
        <p class="text-gray-600">No announcements at the moment.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import { router } from '@inertiajs/vue3'
import Swal from 'sweetalert2'

const student = ref(null)
const activeSemesters = ref([])
const subjects = ref([])
const loading = ref(true)
const search = ref('')
const sortPriority = ref([
  { key: 'title', direction: 'asc' }
])

const fetchStudentDashboard = async () => {
  try {
    const res = await axios.get('/student/dashboard')
    console.log('Student dashboard response:', res)

    if (!res.data.student) {
      console.error('No student data received:', res.data)
    }

    student.value = res.data.student
    activeSemesters.value = res.data.activeSemesters

  } catch (err) {
    console.error('Failed to load student dashboard data:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchStudentDashboard()
})


const perPage = ref(10)
const currentPage = ref(1)

const columns = [
  { key: 'code', label: 'Subject Code' },
  { key: 'title', label: 'Subject Title' },
  { key: 'instructor', label: 'Instructor' },
  { key: 'grade', label: 'Grade'}
]

const fetchSubjects = async () => {
  try {
    const res = await axios.get('/student-subjects')
    subjects.value = res.data.subjects
  } catch (e) {
    console.error('Failed to load student subjects:', e)
  } finally {
    loading.value = false
  }
}

const filteredSubjects = computed(() => {
  const sorted = [...subjects.value].sort((a, b) => {
    for (const s of sortPriority.value) {
      const key = s.key
      const dir = s.direction
      if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
      if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
    }
    return 0
  })

  return sorted.filter(row =>
    Object.values(row).join(' ').toLowerCase().includes(search.value.toLowerCase())
  )
})

const paginatedSubjects = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredSubjects.value.slice(start, start + perPage.value)
})

const totalPages = computed(() => {
  return Math.ceil(filteredSubjects.value.length / perPage.value)
})

const updatePagination = () => {
  currentPage.value = 1
}

const toggleSort = (key) => {
  const index = sortPriority.value.findIndex(s => s.key === key)
  if (index !== -1) {
    sortPriority.value[index].direction =
      sortPriority.value[index].direction === 'asc' ? 'desc' : 'asc'
  } else {
    sortPriority.value.push({ key, direction: 'asc' })
  }
}

const totalSubjects = computed(() => {
  const uniqueCodes = new Set(subjects.value.map(r => r.code))
  return uniqueCodes.size
})



const loadingRequest = ref(false)

async function confirmTORRequest() {
  const confirm = await Swal.fire({
    title: 'Request Transcript of Records?',
    text: 'Do you want to submit a request for your Transcript of Records?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, continue',
    cancelButtonText: 'Cancel',
    // hideClass: {
    //   popup: '' // remove animation on hide
    // }
  })

  if (!confirm.isConfirmed) return

  // Ask for password
  const { value: password } = await Swal.fire({
    title: 'Confirm with Password',
    input: 'password',
    inputLabel: 'Enter your account password to confirm',
    inputPlaceholder: 'Password',
    inputAttributes: {
      autocapitalize: 'off',
      autocorrect: 'off'
    },
    showCancelButton: true,
    confirmButtonText: 'Submit Request',
    // showClass: {
    //   popup: '' // remove animation on show
    // },
    // hideClass: {
    //   popup: '' // remove animation on hide
    // }
  })

  if (!password) return

  // Submit request
  try {
    loadingRequest.value = true
    const res = await axios.post('/tor/request', { password })
    Swal.fire('Success', res.data.message, 'success')
  } catch (err) {
    const status = err.response?.status
    const data = err.response?.data

    if (status === 401) {
      Swal.fire('Unauthorized', 'Wrong password.', 'error')
    } else if (status === 409 && data?.error === 'duplicate') {
      Swal.fire('Already Requested', data.message, 'info')
    } else if (status === 429 && data?.error === 'cooldown') {
      Swal.fire('Please Wait', data.message, 'warning')
    } else {
      Swal.fire('Error', 'Failed to request TOR.', 'error')
    }
  } finally {
    loadingRequest.value = false
  }
}
 
onMounted(() => {
  fetchSubjects()
})
</script>
