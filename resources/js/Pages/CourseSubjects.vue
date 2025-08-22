<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="`Subjects – ${course}`">
    
    <!-- Controls: Search & Entry Limit -->
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
        placeholder="Search subjects..."
        class="border px-3 py-1 rounded w-full md:w-64"
      />
      <!-- Add/Edit Subject Form -->
    <SubjectForm
      :course="course"
      class="ml-4"
      @submitted="fetchSubjects"
      :editMode="editMode"
      :subjectToEdit="subjectToEdit"
      @cancelEdit="cancelEdit"
    />
    </div>
    </div>


    <!-- Subject Table -->
    <div class="p-4 space-y-6 animate-slide-in-top">
      <div class="overflow-x-auto rounded-lg border shadow">
        <table class="min-w-full bg-white">
          <thead class="bg-mcclightblue text-white">
            <tr>
              <th
                v-for="column in columns"
                :key="column.key"
                class="px-4 py-2 select-none text-center cursor-pointer"
                @click="toggleSort(column.key)"
              >
                {{ column.label }}
                <span v-if="sortPriority.find(s => s.key === column.key)">
                  {{
                    sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼'
                  }}
                </span>

              </th>
              <th class="px-4 py-2 text-center select-none">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="subject in paginatedSubjects"
              :key="subject.id"
              class="hover:bg-gray-100"
            >
              <td class="px-4 py-2">{{ subject.code }}</td>
              <td class="px-4 py-2">{{ subject.title }}</td>
              <td class="px-4 py-2 text-center">{{ subject.totalunit }}</td>
              <td class="px-4 py-2 text-center">{{ subject.pre || 'None' }}</td>
              <td class="px-4 py-2 text-center">{{ subject.year }}</td>
              <td class="px-4 py-2 text-center">
                {{ subject.semester == 1 ? '1st Sem' : subject.semester == 2 ? '2nd Sem' : 'Summer' }}
              </td>
              <td class="px-4 py-2 text-center space-x-2">
                <button @click="editSubject(subject)" class="text-blue-600 select-none hover:underline">
                  Edit
                </button>
                <button @click="deleteSubject(subject.id)" class="text-red-600 select-none hover:underline">
                  Delete
                </button>
              </td>
            </tr>
            <tr v-if="paginatedSubjects.length === 0">
              <td colspan="7" class="text-center py-4">No subjects found.</td>
            </tr>
          </tbody>
        </table>
        <!-- Pagination Controls -->
        <div class="flex justify-between bg-mcclightblue items-center  px-2 text-sm text-white select-none">
          <div>
            Showing
            <span class="font-semibold">
              {{
                paginatedSubjects.length
                  ? (currentPage - 1) * perPage + 1
                  : 0
              }}
            </span>
            to
            <span class="font-semibold">
              {{
                (currentPage - 1) * perPage + paginatedSubjects.length
              }}
            </span>
            of
            <span class="font-semibold">{{ filteredSubjects.length }}</span> entries
          </div>
          
          <div class="flex gap-1">
            <button @click="sortPriority = []" class="text-sm text-white border-0 rounded  hover:bg-mccblue transition">
            Clear Sorting
          </button>

            <button
              @click="currentPage = currentPage - 1"
              :disabled="currentPage === 1"
              class="px-3 py-1 border-0 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition"
            >
              Prev
            </button>

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
import SubjectForm from '@/Components/subjects/SubjectForm.vue'

const page = usePage()
const course = page.props.course
const fullname = ref('')
const userLevel = ref('')
const username = ref('')
const subjects = ref([])

const search = ref('')
const sortPriority = ref([
  { key: 'year', direction: 'asc' },
  { key: 'semester', direction: 'asc' }
])

const perPage = ref(10)
const currentPage = ref(1)

const editMode = ref(false)
const subjectToEdit = ref(null)

const columns = [
  { key: 'code', label: 'Code' },
  { key: 'title', label: 'Title' },
  { key: 'totalunit', label: 'Units' },
  { key: 'pre', label: 'Prerequisites' },
  { key: 'year', label: 'Year' },
  { key: 'semester', label: 'Semester' },
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

const fetchSubjects = async () => {
  try {
    const response = await axios.get(`/api/subjects/${course}`)
    subjects.value = response.data
    currentPage.value = 1
    cancelEdit()
  } catch (error) {
    console.error('Failed to load subjects:', error)
  }
}

const filteredSubjects = computed(() => {
  const sorted = [...subjects.value].sort((a, b) => {
    for (const sort of sortPriority.value) {
      const key = sort.key
      const dir = sort.direction
      if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
      if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
    }
    return 0
  })

  return sorted.filter(subject =>
    Object.values(subject)
      .join(' ')
      .toLowerCase()
      .includes(search.value.toLowerCase())
  )
})



const paginatedSubjects = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredSubjects.value.slice(start, start + perPage.value)
})

const updatePagination = () => {
  currentPage.value = 1
}
const totalPages = computed(() => {
  return Math.ceil(filteredSubjects.value.length / perPage.value)
})


const toggleSort = (key) => {
  const index = sortPriority.value.findIndex(s => s.key === key)
  if (index !== -1) {
    // Flip direction if already exists
    sortPriority.value[index].direction =
      sortPriority.value[index].direction === 'asc' ? 'desc' : 'asc'
  } else {
    // Append to preserve current sort priority
    sortPriority.value.push({ key, direction: 'asc' })
  }
}



const deleteSubject = async (id) => {
  const confirmed = await Swal.fire({
    title: 'Delete this subject?',
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes',
  })

  if (confirmed.isConfirmed) {
    try {
      await axios.delete(`/subjects/${id}`)
      await fetchSubjects()
      Swal.fire({
        toast: true,
        title: 'Deleted',
        icon: 'success',
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } catch (error) {
      Swal.fire('Error', 'Failed to delete subject.', 'error')
    }
  }
}

const editSubject = (subject) => {
  editMode.value = true
  subjectToEdit.value = { ...subject }
}

const cancelEdit = () => {
  editMode.value = false
  subjectToEdit.value = null
}

onMounted(() => {
  fetchSession()
  fetchSubjects()
})

const props = defineProps({
  course: String,
})
</script>
