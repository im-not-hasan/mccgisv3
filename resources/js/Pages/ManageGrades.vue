<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" title="Manage Grades">

    <!-- 🔄 Loading -->
    <div v-if="loading" class="flex justify-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
        
      <div v-if="userLevel === 'admin'">

        <!-- Controls -->
        <div class="flex flex-col md:flex-row justify-between select-none items-center p-5 mt-[-30px] mb-[-20px]">

          <!-- Entries -->
          <div class="mb-2 md:mb-0">
            <label class="mr-2">Show</label>
            <select v-model="perPage" @change="updatePagination" class="border py-1 rounded">
              <option v-for="n in [10, 25, 50, 100]" :key="n" :value="n">{{ n }}</option>
            </select>
            <span class="ml-2">entries</span>
          </div>

          <!-- Course Filters -->
          <div class="flex flex-wrap gap-4 p-4 bg-white rounded shadow mb-4 mt-[16px] md:ml-[100px]">
            <label v-for="c in courseFilters" :key="c" class="inline-flex items-center space-x-2">
              <input
                type="checkbox"
                v-model="selectedCourses"
                :value="c"
                class="h-4 w-4 text-mcclightblue"
                @change="fetchData"
              />
              <span class="text-gray-700">{{ c }}</span>
            </label>
          </div>

          <!-- Search -->
          <div class="flex flex-row gap-2 items-center mb-5 md:mb-0">
            <input
              v-model="search"
              @input="updatePagination"
              type="text"
              placeholder="Search..."
              class="border px-3 py-1 rounded w-full md:w-64"
            />
          </div>
        </div>

        <!-- Table -->
        <div class="px-0 sm:px-4 animate-slide-in-top">
          <div class="overflow-x-auto rounded-lg border shadow">

            <table class="min-w-full bg-white text-xs sm:text-sm">
              <thead class="bg-mcclightblue text-white">
                <tr>
                  <th v-for="col in columns" :key="col.key"
                      class="px-3 py-2 text-center cursor-pointer"
                      @click="toggleSort(col.key)">
                    {{ col.label }}
                    <span v-if="sortPriority.find(s => s.key === col.key)">
                      {{ sortPriority.find(s => s.key === col.key).direction === 'asc' ? '▲' : '▼' }}
                    </span>
                  </th>
                  <th class="px-3 py-2 text-center">Actions</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="row in paginatedData" :key="row.id" class="hover:bg-gray-100">

                  <td class="px-3 py-2 text-center">{{ row.instructor }}</td>
                  <td class="px-3 py-2 text-center">{{ row.subject }}</td>
                  <td class="px-3 py-2 text-center">{{ row.course }}</td>
                  <td class="px-3 py-2 text-center">{{ row.year }}</td>
                  <td class="px-3 py-2 text-center">{{ row.section }}</td>

                  <!-- Status -->
                  <td class="px-3 py-2 text-center">
                    <span :class="row.submitted ? 'text-green-600 font-semibold' : 'text-red-500 font-semibold'">
                      {{ row.submitted ? 'Submitted' : 'Not Submitted' }}
                    </span>
                  </td>

                  <!-- Last Updated -->
                  <td class="px-3 py-2 text-center">
                    {{ formatDate(row.last_updated) }}
                  </td>

                  <!-- Actions -->
                  <td class="px-3 py-2 text-center space-x-2">
                    <button
                      v-if="row.submitted"
                      class="text-red-600 hover:underline"
                      @click="unsubmit(row)">
                      Unsubmit
                    </button>

                    <button
                      v-else
                      class="text-green-600 hover:underline"
                      @click="resubmit(row)">
                      Submit
                    </button>
                  </td>

                </tr>

                <tr v-if="paginatedData.length === 0">
                  <td colspan="8" class="text-center py-4">No records found.</td>
                </tr>
              </tbody>
            </table>

            <!-- Pagination -->
            <div class="flex flex-col sm:flex-row justify-between bg-mcclightblue items-center px-2 text-xs sm:text-sm text-white">

              <div class="mb-2 sm:mb-0">
                Showing
                <span class="font-semibold">{{ startEntry }}</span>
                to
                <span class="font-semibold">{{ endEntry }}</span>
                of
                <span class="font-semibold">{{ filteredData.length }}</span>
                entries
              </div>

              <div class="flex gap-1">
                <button @click="currentPage--" :disabled="currentPage === 1"
                        class="px-2 py-1 rounded disabled:opacity-50 hover:bg-mccblue">
                  Prev
                </button>

                <button v-for="p in totalPages" :key="p"
                        @click="currentPage = p"
                        :class="['px-2 py-1 rounded', currentPage === p ? 'bg-white text-mccblue font-bold' : 'hover:bg-mccblue']">
                  {{ p }}
                </button>

                <button @click="currentPage++" :disabled="currentPage === totalPages"
                        class="px-2 py-1 rounded disabled:opacity-50 hover:bg-mccblue">
                  Next
                </button>
              </div>

            </div>

          </div>
        </div>

      </div>

      <!-- ⚠️ Unauthorized -->
      <div v-else class="text-center text-red-500">
        Unauthorized access
      </div>

    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'

const fullname = ref('')
const userLevel = ref('')
const loading = ref(true)
const data = ref([])

const search = ref('')
const perPage = ref(10)
const currentPage = ref(1)

const courseFilters = ['BSIT', 'BSBA', 'BSHM', 'BSED', 'BEED']
const selectedCourses = ref([...courseFilters])

const sortPriority = ref([{ key: 'year', direction: 'asc' }])

const columns = [
  { key: 'instructor', label: 'Instructor' },
  { key: 'subject', label: 'Subject' },
  { key: 'course', label: 'Course' },
  { key: 'year', label: 'Year' },
  { key: 'section', label: 'Section' },
  { key: 'submitted', label: 'Status' },
  { key: 'last_updated', label: 'Last Updated' },
]

// Fetch session
const fetchSession = async () => {
  try {
    const res = await axios.get('/session')
    fullname.value = res.data.fullname
    userLevel.value = res.data.level

    if (!fullname.value || !userLevel.value) {
      window.location.href = '/'
    }
  } catch {
    window.location.href = '/'
  }
}

// Fetch grade data
const fetchData = async () => {
  try {
    const res = await axios.get('/grade-management')
    data.value = res.data
  } catch (err) {
    console.error(err)
  }
}

// Actions
const unsubmit = async (row) => {
  const confirm = await Swal.fire({
    title: 'Unsubmit Grades?',
    text: 'Instructor will be able to edit again.',
    icon: 'warning',
    showCancelButton: true,
  })
  if (!confirm.isConfirmed) return

  await axios.post('/grades/unsubmit', row)
  Swal.fire({ icon: 'success', title: 'Grades Unsubmitted', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
  fetchData()
}

const resubmit = async (row) => {
  const confirm = await Swal.fire({
    title: 'Submit Grades?',
    text: 'Instructor will not be able to edit again.',
    icon: 'warning',
    showCancelButton: true,
  })
  if (!confirm.isConfirmed) return
  await axios.post('/grades/resubmit', row)
    Swal.fire({ icon: 'success', title: 'Grades Submitted', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })

  fetchData()
}

// Filtering
const filteredData = computed(() => {
  return data.value
    .filter(r =>
      selectedCourses.value.includes(r.course) &&
      Object.values(r).join(' ').toLowerCase().includes(search.value.toLowerCase())
    )
})

// Pagination
const paginatedData = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredData.value.slice(start, start + perPage.value)
})

const totalPages = computed(() => Math.ceil(filteredData.value.length / perPage.value))

const startEntry = computed(() =>
  filteredData.value.length ? (currentPage.value - 1) * perPage.value + 1 : 0
)

const endEntry = computed(() =>
  (currentPage.value - 1) * perPage.value + paginatedData.value.length
)

const updatePagination = () => {
  currentPage.value = 1
}

// Sorting
const toggleSort = (key) => {
  const index = sortPriority.value.findIndex(s => s.key === key)
  if (index !== -1) {
    sortPriority.value[index].direction =
      sortPriority.value[index].direction === 'asc' ? 'desc' : 'asc'
  } else {
    sortPriority.value.push({ key, direction: 'asc' })
  }
}

// Format date
const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString()
}

// Init
onMounted(async () => {
  await fetchSession()

  if (userLevel.value === 'admin') {
    await fetchData()
  }

  loading.value = false
})
</script>