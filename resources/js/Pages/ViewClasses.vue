<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" title="All Classes">
    <div v-if="userLevel === 'admin' || userLevel === 'registrar' ">
      <!-- Controls -->
      <div class="flex flex-col md:flex-row justify-between select-none items-center p-5 mt-[-30px] mb-[-20px]">
        <div class="mb-2 md:mb-0">
          <label class="mr-2">Show</label>
          <select v-model="perPage" @change="updatePagination" class="border py-1 rounded">
            <option v-for="n in [10, 25, 50, 100]" :key="n" :value="n">{{ n }}</option>
          </select>
          <span class="ml-2">entries</span>
        </div>

        <!-- Course Filter Checkboxes -->
        <div class="flex flex-wrap gap-4 p-4 bg-white rounded shadow mb-4  mt-[16px]"
        :class="userLevel === 'admin' ? 'md:ml-[185px]' : 'md:ml-[58px]'">
          <label v-for="c in courseFilters" :key="c" class="inline-flex items-center space-x-2">
            <input
              type="checkbox"
              v-model="selectedCourses"
              :value="c"
              class="h-4 w-4 text-mcclightblue focus:ring-[0%]"
              @change="fetchClasses"
            />
            <span class="text-gray-700">{{ c }}</span>
          </label>
        </div>

        <div class="flex flex-row gap-2 items-center mb-5 md:mb-0">
          <input
            v-model="search"
            @input="updatePagination"
            type="text"
            placeholder="Search classes..."
            class="border px-3 py-1 rounded w-full md:w-64"
          />
          <ClassesForm v-if="userLevel === 'admin'" :editMode="editMode" :classToEdit="classToEdit" @submitted="handleSubmitted" @cancelEdit="cancelEdit" class="w-[160px] md:w-auto"/>
        </div>
      </div>

    
      <div class="px-0 sm:px-4 animate-slide-in-top">
        <div class="overflow-x-auto rounded-lg border shadow">
          <!-- Admin Table -->
          <table v-if="userLevel === 'admin'" class="min-w-full bg-white text-xs sm:text-sm">
            <thead class="bg-mcclightblue text-white">
              <tr>
                <th v-for="column in columns" :key="column.key" class="px-2 sm:px-4 py-2 text-center cursor-pointer select-none" @click="toggleSort(column.key)">
                  {{ column.label }}
                  <span v-if="sortPriority.find(s => s.key === column.key)">
                    {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
                  </span>
                </th>
                <th class="px-2 sm:px-4 py-2 text-center select-none">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="classItem in paginatedClasses"
                :key="classItem.id"
                class="hover:bg-gray-100 cursor-pointer"
                @dblclick="openStudentView(classItem)"
              >
                <td class="px-2 sm:px-4 py-2">{{ classItem.name }}</td>
                <td class="px-2 sm:px-4 py-2 text-center">{{ classItem.course }}</td>
                <td class="px-2 sm:px-4 py-2 text-center">{{ classItem.year }}</td>
                <td class="px-2 sm:px-4 py-2 text-center">{{ classItem.section }}</td>
                <td class="px-2 sm:px-4 py-2 text-center space-x-2">
                  <button class="text-green-600 select-none hover:underline" @click.stop="openStudentView(classItem)">View</button>
                  <button class="text-blue-600 select-none hover:underline" @click="startEdit(classItem)">Edit</button>
                  <button class="text-red-600 select-none hover:underline" @click="deleteClass(classItem.id)">Delete</button>
                </td>
              </tr>
              <tr v-if="paginatedClasses.length === 0">
                <td colspan="5" class="text-center py-4">No classes found.</td>
              </tr>
            </tbody>
          </table>

          <!-- Registrar Table -->
          <table v-else-if="userLevel === 'registrar'" class="min-w-full bg-white text-xs sm:text-sm">
            <thead class="bg-mcclightblue text-white">
              <tr>
                <th v-for="column in columns" :key="column.key" class="px-2 sm:px-4 py-2 text-center cursor-pointer select-none" @click="toggleSort(column.key)">
                  {{ column.label }}
                  <span v-if="sortPriority.find(s => s.key === column.key)">
                    {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
                  </span>
                </th>
                <th class="px-2 sm:px-4 py-2 text-center select-none">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="classItem in paginatedClasses"
                :key="classItem.id"
                class="hover:bg-gray-100 cursor-pointer"
                @dblclick="openSubtView(classItem)"
              >
                <td class="px-2 sm:px-4 py-2">{{ classItem.name }}</td>
                <td class="px-2 sm:px-4 py-2 text-center">{{ classItem.course }}</td>
                <td class="px-2 sm:px-4 py-2 text-center">{{ classItem.year }}</td>
                <td class="px-2 sm:px-4 py-2 text-center">{{ classItem.section }}</td>
                <td class="px-2 sm:px-4 py-2 text-center space-x-2">
                  <button class="text-green-600 select-none hover:underline" @click.stop="openSubjectView(classItem)">View Subjects</button>
                </td>
              </tr>
              <tr v-if="paginatedClasses.length === 0">
                <td colspan="5" class="text-center py-4">No classes found.</td>
              </tr>
            </tbody>
          </table>

          <!-- Pagination Controls -->
          <div class="flex flex-col sm:flex-row justify-between bg-mcclightblue items-center px-2 text-xs sm:text-sm text-white select-none">
            <div class="mb-2 sm:mb-0">
              Showing
              <span class="font-semibold">{{ paginatedClasses.length ? (currentPage - 1) * perPage + 1 : 0 }}</span>
              to
              <span class="font-semibold">{{ (currentPage - 1) * perPage + paginatedClasses.length }}</span>
              of
              <span class="font-semibold">{{ filteredClasses.length }}</span> entries
            </div>

            <div class="flex flex-wrap gap-1">
              <button @click="sortPriority = []" class="text-xs sm:text-sm text-white mr-2 border-0 rounded hover:bg-mccblue transition">Clear Sorting</button>
              <button @click="currentPage--" :disabled="currentPage === 1" class="px-2 sm:px-3 py-1 border-0 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition">Prev</button>
              <button
                v-for="page in totalPages"
                :key="page"
                @click="currentPage = page"
                :class="['px-2 sm:px-3 py-1 border-0 rounded', currentPage === page ? 'bg-white text-mccblue font-bold' : 'hover:bg-mccblue transition']"
              >
                {{ page }}
              </button>
              <button @click="currentPage++" :disabled="currentPage === totalPages" class="px-2 sm:px-3 py-1 border-0 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition">Next</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="text-center text-red-500">
        Unknown user level: {{ userLevel }}
      </div>
  </DashboardLayout>

  <SubjectsInClass
    :visible="showSubjectsModal"
    :selectedClass="selectedClass"
    @close="closeSubjectView"
  />

  <ViewStudentsInClass
    :visible="showStudentsModal"
    :selectedClass="selectedClass"
    @close="closeStudentView"
    @updated="refreshClassList"
  />
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import ClassesForm from '@/Components/classes/ClassesForm.vue'
import ViewStudentsInClass from '@/Components/classes/StudentsInClass.vue'
import SubjectsInClass from '@/Components/classes/SubjectsInClass.vue'

const fullname = ref('')
const userLevel = ref('')
const username = ref('')
const classes = ref([])

const search = ref('')
const sortPriority = ref([{ key: 'year', direction: 'asc' }])
const perPage = ref(10)
const currentPage = ref(1)
const courseFilters = ['BSIT', 'BSBA', 'BSHM', 'BSED', 'BEED']
const selectedCourses = ref([...courseFilters])
const editMode = ref(false)
const classToEdit = ref(null)
const showStudentsModal = ref(false)
const selectedClass = ref(null)

const openStudentView = (classItem) => {
  selectedClass.value = classItem
  showStudentsModal.value = true
}

const closeStudentView = () => {
  showStudentsModal.value = false
  selectedClass.value = null
}

const refreshClassList = async () => {
  await fetchClasses()
}

const columns = [
  { key: 'name', label: 'Class Name' },
  { key: 'course', label: 'Course' },
  { key: 'year', label: 'Year' },
  { key: 'section', label: 'Section' },
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

const fetchClasses = async () => {
  try {
    const params = { courses: selectedCourses.value.join(',') }
    const response = await axios.get('/api/classes', { params })
    classes.value = response.data.classes
  } catch (error) {
    console.error('Failed to load class list:', error)
  }
}

const deleteClass = async (id) => {
  const confirm = await Swal.fire({
    title: 'Delete Class?',
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Delete',
  })
  if (!confirm.isConfirmed) return

  try {
    await axios.delete(`/classes/${id}`)
    await fetchClasses()
    Swal.fire({ icon: 'success', title: 'Class Deleted', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
  } catch (error) {
    Swal.fire('Error', 'Failed to delete class', 'error')
  }
}

const startEdit = (classItem) => {
  editMode.value = true
  classToEdit.value = { ...classItem }
}

const cancelEdit = () => {
  editMode.value = false
  classToEdit.value = null
}

const handleSubmitted = async () => {
  editMode.value = false
  classToEdit.value = null
  await fetchClasses()
}

const filteredClasses = computed(() => {
  return classes.value
    .filter(c =>
      selectedCourses.value.includes(c.course) &&
      Object.values(c).join(' ').toLowerCase().includes(search.value.toLowerCase())
    )
    .sort((a, b) => {
      for (const sort of sortPriority.value) {
        const key = sort.key
        const dir = sort.direction
        if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
        if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
      }
      return 0
    })
})

const paginatedClasses = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredClasses.value.slice(start, start + perPage.value)
})

const totalPages = computed(() => Math.ceil(filteredClasses.value.length / perPage.value))
const updatePagination = () => { currentPage.value = 1 }
const toggleSort = (key) => {
  const index = sortPriority.value.findIndex(s => s.key === key)
  if (index !== -1) {
    sortPriority.value[index].direction = sortPriority.value[index].direction === 'asc' ? 'desc' : 'asc'
  } else {
    sortPriority.value.push({ key, direction: 'asc' })
  }
}

const showSubjectsModal = ref(false)

const openSubjectView = (classItem) => {
  selectedClass.value = classItem
  showSubjectsModal.value = true
}

const closeSubjectView = () => {
  showSubjectsModal.value = false
  selectedClass.value = null
}

onMounted(() => {
  fetchSession()
  fetchClasses()
})

watch(selectedCourses, () => {
  fetchClasses()
})
</script>
