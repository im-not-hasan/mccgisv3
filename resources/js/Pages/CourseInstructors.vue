<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="`Instructors – ${department}`">
    <!-- Controls -->
    <div class="flex flex-col md:flex-row justify-between items-center p-5">
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
        placeholder="Search instructors..."
        class="border px-3 py-1 rounded w-full md:w-64 ml-[62px]"
      />
      <div class="flex">
      <button
        @click="openImportModal"
        class="bg-mccblue text-white  px-4 py-2 rounded-lg hover:bg-mccdarkblue transition"
      >
        Import
      </button>

      <InstructorForm
        :course="department"
        class="ml-4"
        :editMode="editMode"
        :instructorToEdit="instructorToEdit"
        @submitted="fetchInstructors"
        @cancelEdit="cancelEdit"
      />
      </div>
    </div>
    <AssignmentForm :course="department" ref="assignmentForm" :instructor="selectedInstructor" />
    <!-- Table -->
    <div class="p-4 space-y-6 animate-slide-in-top">
      <div class="overflow-x-auto rounded-lg border shadow">
        <table class="min-w-full bg-white">
          <thead class="bg-mcclightblue text-white">
            <tr>
              <th
                v-for="column in columns"
                :key="column.key"
                class="px-4 py-2 text-center cursor-pointer select-none"
                @click="toggleSort(column.key)"
              >
                {{ column.label }}
                <span v-if="sortPriority.find(s => s.key === column.key)">
                  {{ sortPriority.find(s => s.key === column.key).direction === 'asc' ? '▲' : '▼' }}
                </span>
              </th>
              <th class="px-4 py-2 text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="instructor in paginatedInstructors" :key="instructor.id" class="hover:bg-gray-100">
              <td class="px-4 py-2 text-center">{{ instructor.teachid }}</td>
              <td class="px-4 py-2 text-center">{{ instructor.fname }}</td>
              <td class="px-4 py-2 text-center">{{ instructor.lname }}</td>
              <td class="px-4 py-2 text-center">{{ instructor.sex }}</td>
              <td class="px-4 py-2 text-center space-x-2">
                <button @click="openAssignments(instructor)"  class="text-green-600 hover:underline select-none">View Subjects</button>
                <button @click="editInstructor(instructor)" class="text-blue-600 hover:underline select-none">Edit</button>
                <button @click="deleteInstructor(instructor.id)" class="text-red-600 hover:underline select-none">Delete</button>
              </td>
            </tr>
            <tr v-if="paginatedInstructors.length === 0">
              <td colspan="5" class="text-center py-4">No instructors found.</td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination Controls -->
        <div class="flex justify-between bg-mcclightblue items-center px-2 text-sm text-white select-none">
          <div>
            Showing
            <span class="font-semibold">
              {{
                paginatedInstructors.length
                  ? (currentPage - 1) * perPage + 1
                  : 0
              }}
            </span>
            to
            <span class="font-semibold">
              {{
                (currentPage - 1) * perPage + paginatedInstructors.length
              }}
            </span>
            of
            <span class="font-semibold">{{ filteredInstructors.length }}</span> entries
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
import InstructorForm from '@/Components/instructors/InstructorForm.vue'
import AssignmentForm from '@/Components/instructors/AssignmentForm.vue'

const page = usePage()
const department = page.props.department
const fullname = ref('')
const userLevel = ref('')
const instructors = ref([])
const username = ref('')
const assignmentForm = ref(null)


const search = ref('')
const sortPriority = ref([
  { key: 'lname', direction: 'asc' }
])

const perPage = ref(10)
const currentPage = ref(1)

const columns = [
  { key: 'id', label: 'ID' },
  { key: 'fname', label: 'First Name' },
  { key: 'lname', label: 'Last Name' },
  { key: 'sex', label: 'Gender' },
]

const editInstructor = (instructor) => {
  editMode.value = true
  instructorToEdit.value = { ...instructor }
}

const editMode = ref(false)
const instructorToEdit = ref(null)

const cancelEdit = () => {
  editMode.value = false
  instructorToEdit.value = null
}
const selectedInstructor = ref(null)

const openAssignments = (instructor) => {
  selectedInstructor.value = instructor
  assignmentForm.value.openModal()
}




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

const fetchInstructors = async () => {
  try {
    const res = await axios.get(`/api/instructors/${department}`)
    instructors.value = res.data
    currentPage.value = 1
  } catch (err) {
    console.error('Error fetching instructors:', err)
  }
}

const filteredInstructors = computed(() => {
  const sorted = [...instructors.value].sort((a, b) => {
    for (const s of sortPriority.value) {
      const key = s.key
      const dir = s.direction
      if (a[key] < b[key]) return dir === 'asc' ? -1 : 1
      if (a[key] > b[key]) return dir === 'asc' ? 1 : -1
    }
    return 0
  })

  return sorted.filter(i =>
    Object.values(i).join(' ').toLowerCase().includes(search.value.toLowerCase())
  )
})

const paginatedInstructors = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredInstructors.value.slice(start, start + perPage.value)
})

const totalPages = computed(() => {
  return Math.ceil(filteredInstructors.value.length / perPage.value)
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

const deleteInstructor = async (id) => {
  const confirm = await Swal.fire({
    title: 'Move to Trash?',
    text: 'Move instructor record to trash?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#e3342f',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes',
  })

  if (confirm.isConfirmed) {
    try {
      await axios.delete(`/instructors/${id}`)
      await fetchInstructors()
      Swal.fire({
        icon: 'success',
        title: 'Moved to Trash',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } catch (err) {
      Swal.fire('Error', 'Failed to delete instructor', 'error')
    }
  }
}


const openImportModal = () => {
  const UPLOAD_URL = '/imports/instructor-loads' // 👈 NEW ENDPOINT
  let selectedFile = null

  Swal.fire({
    title: 'Import Instructor Loads',
    html: `
      <div id="dz"
           class="mt-2 border-2 border-dashed rounded-lg p-6 text-sm
                  bg-white hover:bg-gray-50 transition-colors
                  border-gray-300 text-gray-600">
        <div class="pointer-events-none select-none">
          <div class="font-semibold text-gray-800 mb-1 text-lg">Drag & drop file here</div>
          <div class="text-md opacity-80 mb-3">Accepted: .xlsx, .xls, .csv</div>
        </div>
        <div class="items-center gap-2">
          <button id="browseBtn"
                  class="px-4 py-2 rounded bg-mccblue text-white text-md hover:opacity-90">
            Browse
          </button>
          <span id="fileName" class="text-xs"></span>
        </div>
        <input id="fileInput" type="file" accept=".xlsx,.xls,.csv" class="hidden" />

        <div id="progressWrap" class="mt-4 hidden">
          <div class="h-2 w-full bg-gray-200 rounded">
            <div id="bar" class="h-2 bg-mccblue rounded" style="width:0%"></div>
          </div>
          <div id="pct" class="text-xs mt-1 text-gray-600">0%</div>
        </div>
      </div>
    `,
    showCancelButton: true,
    confirmButtonText: 'Upload',
    confirmButtonColor: '#16a34a',
    width: 600,
    focusConfirm: false,
    allowOutsideClick: () => !Swal.isLoading(), // don't close while uploading
    didOpen: () => {
      const dz = document.getElementById('dz')
      const input = document.getElementById('fileInput')
      const browseBtn = document.getElementById('browseBtn')
      const fileNameEl = document.getElementById('fileName')

      const acceptExts = ['xlsx', 'xls', 'csv']
      const pickFile = (file) => {
        if (!file) return
        const ext = (file.name.split('.').pop() || '').toLowerCase()
        if (!acceptExts.includes(ext)) {
          selectedFile = null
          fileNameEl.textContent = ''
          Swal.showValidationMessage('Invalid file type. Please upload a .xlsx or .csv file.')
          return
        }
        selectedFile = file
        fileNameEl.textContent = `${file.name} (${Math.round(file.size/1024)} KB)`
        Swal.resetValidationMessage()
      }

      // Browse
      browseBtn.addEventListener('click', () => input.click())
      input.addEventListener('change', (e) => pickFile(e.target.files?.[0]))

      // Drag & Drop
      const prevent = (e) => { e.preventDefault(); e.stopPropagation() }
      ;['dragenter','dragover','dragleave','drop'].forEach(ev => dz.addEventListener(ev, prevent))
      dz.addEventListener('dragenter', () => dz.classList.add('bg-gray-50'))
      dz.addEventListener('dragleave', () => dz.classList.remove('bg-gray-50'))
      dz.addEventListener('drop', (e) => {
        dz.classList.remove('bg-gray-50')
        pickFile(e.dataTransfer?.files?.[0])
      })
    },
    // keep your didOpen logic (drag&drop + browse + pickFile) unchanged,
    preConfirm: async () => {
      if (!selectedFile) { Swal.showValidationMessage('Please select a file first.'); return false; }
      const fd = new FormData(); fd.append('file', selectedFile)
      try {
        const res = await axios.post(UPLOAD_URL, fd, {
          headers: { 'Content-Type': 'multipart/form-data' },
          onUploadProgress: (e) => { /* update progress bar if you have it */ }
        })
        return res.data
      } catch (err) {
        const msg = err?.response?.data?.error || err?.response?.data?.message || err.message
        Swal.showValidationMessage(msg); return false
      }
    }
  }).then(async (result) => {
    if (result.isConfirmed && result.value) {
      const { inserted=0, updated=0, skipped=0, errors=[] } = result.value
      await Swal.fire({
        icon: 'success',
        title: 'Import completed',
        html: `<div class="text-left">
                 <div><b>Inserted:</b> ${inserted}</div>
                 <div><b>Updated:</b> ${updated}</div>
                 <div><b>Skipped:</b> ${skipped}</div>
                 ${errors.length ? `<hr class="my-2"/><div class="text-sm max-h-40 overflow-auto">${errors.map(e=>`<div>• ${e}</div>`).join('')}</div>` : ''}
               </div>`
      })
      // 👇 Refresh the view on this page
      await fetchInstructors?.() || await fetchAssignments?.() || await fetchData?.()
    }
  })
}

onMounted(() => {
  fetchSession()
  fetchInstructors()
})
</script>
