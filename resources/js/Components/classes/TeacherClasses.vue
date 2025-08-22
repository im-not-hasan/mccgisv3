<template>
  <div class="p-4">
    <!-- Header Summary -->
    <div class="mb-4">
      <h1 class="text-2xl font-bold text-mccblue">My Classes Overview</h1>
      <p class="text-gray-600 mt-1">
        You are handling {{ filteredClasses.length }} class<span v-if="filteredClasses.length !== 1">es</span>
        with {{ totalSubjects }} unique subject<span v-if="totalSubjects !== 1">s</span>.
      </p>
    </div>

    <!-- Controls -->
    <div class="flex flex-col md:flex-row justify-between items-center mb-4">
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
        placeholder="Search classes..."
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
      <table class="min-w-full bg-white shadow rounded-lg overflow-hidden">
        <thead class="bg-mcclightblue text-white">
          <tr>
            <th
              v-for="column in columns"
              :key="column.key"
              class="py-2 px-4 text-center cursor-pointer select-none"
              @click="toggleSort(column.key)"
            >
              {{ column.label }}
              <span v-if="sortPriority.find(s => s.key === column.key)">
                {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
              </span>
            </th>
            <th class="py-2 px-4 text-center">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="cls in paginatedClasses" :key="cls.classKey" class="hover:bg-gray-100">
            <td class="py-2 px-4 font-medium text-center">{{ cls.classLabel }}</td>
            <td class="py-2 px-4 text-center">
              <ul>
                <li v-for="subj in cls.subjects" :key="subj.code">
                  {{ subj.code }} - {{ subj.title }}
                </li>
              </ul>
            </td>
            <td class="py-2 px-4 text-center">
              <button
                class="text-green-600 hover:underline select-none ml-2.5"
                @click="openStudentView(cls)"
              >View</button>
            </td>
          </tr>
          <tr v-if="paginatedClasses.length === 0">
            <td colspan="3" class="text-center py-4">No classes found.</td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination Controls -->
      <div class="flex justify-between bg-mcclightblue items-center px-2 text-sm text-white select-none rounded-b-lg">
        <div>
          Showing
          <span class="font-semibold">
            {{ paginatedClasses.length ? (currentPage - 1) * perPage + 1 : 0 }}
          </span>
          to
          <span class="font-semibold">
            {{ (currentPage - 1) * perPage + paginatedClasses.length }}
          </span>
          of
          <span class="font-semibold">{{ filteredClasses.length }}</span> entries
        </div>

        <div class="flex gap-1">
          <button @click="sortPriority = []" class="text-sm hover:bg-mccblue px-2 py-1 rounded transition">
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

      <!-- Improved Empty State -->
      <div v-if="filteredClasses.length === 0" class="text-center text-gray-500 mt-10">
        <div class="text-6xl mb-2">📚</div>
        <p class="text-lg">No classes assigned to you yet.</p>
      </div>
    </div>
  </div>

  <TeacherStudentsInClass
    :visible="showStudentsModal"
    :selectedClass="selectedClass"
    @close="closeStudentView"
  />
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import TeacherStudentsInClass from './TeacherStudentsInClass.vue'

const assignments = ref([])
const loading = ref(true)
const search = ref('')
const sortPriority = ref([
  { key: 'classLabel', direction: 'asc' }
])

const perPage = ref(10)
const currentPage = ref(1)

const columns = [
  { key: 'classLabel', label: 'Class' },
  { key: 'subjectCount', label: 'Subjects Handled' }
]

const fetchClasses = async () => {
  try {
    const res = await axios.get('/teacher-classes')
    assignments.value = res.data.classes
  } catch (e) {
    console.error('Failed to load teacher classes:', e)
  } finally {
    loading.value = false
  }
}

const groupedClasses = computed(() => {
  return assignments.value.map(a => ({
    classKey: `${a.course}_${a.year}_${a.section}`,
    course: a.course,
    year: a.year,
    section: a.section,
    classLabel: `${a.course} ${a.year}-${a.section}`,
    subjects: a.subjects,
    subjectCount: a.subjects.length
  }))
})

const filteredClasses = computed(() => {
  const sorted = [...groupedClasses.value].sort((a, b) => {
    for (const s of sortPriority.value) {
      const key = s.key
      const dir = s.direction
      if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
      if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
    }
    return 0
  })

  return sorted.filter(cls =>
    Object.values(cls).join(' ').toLowerCase().includes(search.value.toLowerCase())
  )
})

const paginatedClasses = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredClasses.value.slice(start, start + perPage.value)
})

const totalPages = computed(() => {
  return Math.ceil(filteredClasses.value.length / perPage.value)
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
  const allSubjects = groupedClasses.value.flatMap(c => c.subjects.map(s => s.code))
  return new Set(allSubjects).size
})

const showStudentsModal = ref(false)
const selectedClass = ref(null)

const openStudentView = (cls) => {
  selectedClass.value = {
    course: cls.course,
    year: cls.year,
    section: cls.section
  }
  showStudentsModal.value = true
}

const closeStudentView = () => {
  showStudentsModal.value = false
  selectedClass.value = null
}

onMounted(() => {
  fetchClasses()
})
</script>
