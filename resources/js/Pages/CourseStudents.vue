<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="`Students – ${course}`">
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
          placeholder="Search students..."
          class="border px-3 py-1 rounded w-full md:w-64"
        />
        <StudentForm
          v-if="userLevel !== 'registrar'"
          :course="course"
          class="ml-4"
          @submitted="fetchStudents"
          :editMode="editMode"
          :studentToEdit="studentToEdit"
          @cancelEdit="cancelEdit"
        />
      </div>
    </div>

    <div class="p-4 space-y-6 animate-slide-in-top">
      <div class="overflow-x-auto rounded-lg border shadow">
        <table class="min-w-full bg-white">
          <thead class="bg-mcclightblue text-white">
            <tr>
              <th v-for="column in columns" :key="column.key" class="px-4 py-2 text-center cursor-pointer" @click="toggleSort(column.key)">
                {{ column.label }}
                <span v-if="sortPriority.find(s => s.key === column.key)">
                  {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
                </span>
              </th>
              <th v-if="userLevel !== 'registrar'" class="px-4 py-2 text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="student in paginatedStudents" :key="student.id" class="hover:bg-gray-100">
              <td class="px-4 py-2 text-center">{{ student.studid }}</td>
              <td class="px-4 py-2">{{ student.fname }} {{ student.lname }}</td>
              <td class="px-4 py-2 text-center">{{ student.gender }}</td>
              <td class="px-4 py-2 text-center">{{ student.year }}</td>
              <td v-if="userLevel !== 'registrar'" class="px-4 py-2 text-center space-x-2">
                <button @click="editStudent(student)" class="text-blue-600 hover:underline">Edit</button>
                <button @click="deleteStudent(student.id)" class="text-red-600 hover:underline">Delete</button>
              </td>
            </tr>
            <tr v-if="paginatedStudents.length === 0">
              <td colspan="5" class="text-center py-4">No students found.</td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination -->
        <div class="flex justify-between bg-mcclightblue items-center px-2 text-sm text-white select-none">
            <div>
                Showing
                <span class="font-semibold">
                {{
                    paginatedStudents.length
                    ? (currentPage - 1) * perPage + 1
                    : 0
                }}
                </span>
                to
                <span class="font-semibold">
                {{
                    (currentPage - 1) * perPage + paginatedStudents.length
                }}
                </span>
                of
                <span class="font-semibold">{{ filteredStudents.length }}</span> entries
            </div>

            <div class="flex gap-1 items-center">
              <button @click="sortPriority = []" class="text-sm hover:bg-mccblue px-2 py-1 rounded transition">
              Clear Sorting
            </button>
                <button
                @click="currentPage = currentPage - 1"
                :disabled="currentPage === 1"
                class="px-3 py-1 border-0 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition"
                >
                Prev
                </button>

                <!-- Show normal pagination if ≤10 pages -->
                <template v-if="totalPages <= 10">
                <button
                    v-for="page in totalPages"
                    :key="page"
                    @click="currentPage = page"
                    :class="[
                    'px-3 py-1 border-0 rounded',
                    currentPage === page
                        ? 'bg-white text-mccblue font-bold'
                        : 'hover:bg-mccblue transition'
                    ]"
                >
                    {{ page }}
                </button>
                </template>

                <!-- If >10 pages, show dropdown -->
                <template v-else>
                <select
                    v-model="currentPage"
                    @change="currentPage = parseInt($event.target.value)"
                    class="bg-white text-mccblue py-[0.5px] rounded border-none"
                >
                    <option
                    v-for="page in totalPages"
                    :key="page"
                    :value="page"
                    >
                    {{ page }}
                    </option>
                </select>
                </template>

                <button
                @click="currentPage = currentPage + 1"
                :disabled="currentPage === totalPages"
                class="px-3 py-1 border-0 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition"
                >
                Next
                </button>
            </div>
            </div>

      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { usePage } from '@inertiajs/vue3'
import Swal from 'sweetalert2'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import StudentForm from '@/Components/students/StudentForm.vue'

const page = usePage()
const course = page.props.course
const fullname = ref('')
const userLevel = ref('')
const username = ref('')
const students = ref([])

const search = ref('')
const sortPriority = ref([{ key: 'studid', direction: 'asc' }])
const perPage = ref(10)
const currentPage = ref(1)

const editMode = ref(false)
const studentToEdit = ref(null)

const columns = [
  { key: 'studid', label: 'Student ID' },
  { key: 'name', label: 'Name' },
  { key: 'gender', label: 'Gender' },
  { key: 'year', label: 'Year' },
]


const fetchSession = async () => {
  try {
    const res = await axios.get('/session')
    fullname.value = res.data.fullname
    userLevel.value = res.data.level
    username.value = res.data.username
    if (!fullname.value || !userLevel.value) window.location.href = '/'
  } catch {
    window.location.href = '/'
  }
}

const fetchStudents = async () => {
  const response = await axios.get(`/api/students/${course}`)
  students.value = response.data
  currentPage.value = 1
  cancelEdit()
}

const filteredStudents = computed(() => {
  const sorted = [...students.value].sort((a, b) => {
    for (const sort of sortPriority.value) {
      const key = sort.key
      const dir = sort.direction
      if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
      if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
    }
    return 0
  })

  return sorted.filter(student =>
    Object.values(student).join(' ').toLowerCase().includes(search.value.toLowerCase())
  )
})

const paginatedStudents = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredStudents.value.slice(start, start + perPage.value)
})

const totalPages = computed(() => Math.ceil(filteredStudents.value.length / perPage.value))

const updatePagination = () => { currentPage.value = 1 }

const toggleSort = (key) => {
  const index = sortPriority.value.findIndex(s => s.key === key)
  if (index !== -1) {
    sortPriority.value[index].direction = sortPriority.value[index].direction === 'asc' ? 'desc' : 'asc'
  } else {
    sortPriority.value.push({ key, direction: 'asc' })
  }
}

const deleteStudent = async (id) => {
  const confirmed = await Swal.fire({
    title: 'Delete this student?',
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes',
  })
  if (confirmed.isConfirmed) {
    await axios.delete(`/students/${id}`)
    await fetchStudents()
    Swal.fire({ toast: true, title: 'Deleted', icon: 'success', position: 'top-end', timer: 2000, showConfirmButton: false })
  }
}

const editStudent = (student) => {
  editMode.value = true
  studentToEdit.value = { ...student }
}

const cancelEdit = () => {
  editMode.value = false
  studentToEdit.value = null
}

onMounted(() => {
  fetchSession()
  fetchStudents()
})
</script>
