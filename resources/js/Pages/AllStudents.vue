<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="`All Students`">
    <div class="flex flex-col md:flex-row justify-between select-none items-center p-5">
      <div class="mb-2 md:mb-0">
        <label class="mr-2">Show</label>
        <select v-model="perPage" @change="updatePagination" class="border py-1 rounded">
          <option v-for="n in [10, 25, 50, 100]" :key="n" :value="n">{{ n }}</option>
        </select>
        <span class="ml-2">entries</span>
      </div>
      <div class="flex flex-col md:flex-row gap-2 items-center">
        <!-- Import -->
        <button v-if="userLevel !== 'registrar'"
          @click="openImportModal"
          class="bg-mccblue text-white px-3 py-1 rounded hover:bg-mccdarkblue transition"
        >
          Import
        </button>

        <!-- Export template (no data) -->
        <button v-if="userLevel !== 'registrar'"
          @click="exportTemplate"
          class="bg-mccblue text-white px-3 py-1 rounded hover:bg-mccdarkblue transition"
        >
          Export
        </button>
        <input
          v-model="search"
          @input="updatePagination"
          type="text"
          placeholder="Search students..."
          class="border px-3 py-1 rounded w-full md:w-64"
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
            </tr>
          </thead>
          <tbody>
            <tr v-for="student in paginatedStudents" :key="student.id" class="hover:bg-gray-100">
              <td class="px-4 py-2 text-center">{{ student.studid }}</td>
              <td class="px-4 py-2">{{ student.fname }} {{ student.lname }}</td>
              <td class="px-4 py-2 text-center">{{ student.gender }}</td>
              <td class="px-4 py-2 text-center">{{ student.course }}</td>
              <td class="px-4 py-2 text-center">{{ student.year }}</td>
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
import Swal from 'sweetalert2'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'

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
  { key: 'course', label: 'Course'},
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
  const response = await axios.get(`/api/allstudents/`)
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

const cancelEdit = () => {
  editMode.value = false
  studentToEdit.value = null
}


//ExportImport
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'


// Export a blank template (headers only)
const exportTemplate = () => {
  // simplest: navigate to GET route to trigger download
  window.location.href = '/students/template/export'
}

const openImportModal = () => {
  const UPLOAD_URL = '/students/template/import' // or '/students/template/import-csv'
  let selectedFile = null

  Swal.fire({
    title: 'Import Students',
    html: `
      <div id="dz"
           class="mt-2 border-2 border-dashed rounded-lg p-6 text-sm
                  bg-white hover:bg-gray-50 transition-colors
                  border-gray-300 text-gray-600">
        <div class="pointer-events-none select-none">
          <div class="font-semibold text-gray-800 mb-1 text-lg">Drag & drop file here</div>
          <div class="text-md opacity-80 mb-3">Accepted: .xlsx, .csv</div>
        </div>
        <div class="items-center gap-2">
          <button id="browseBtn"
                  class="px-4 py-2 rounded bg-mccblue text-white text-md hover:opacity-90">
            Browse
          </button>
          <span id="fileName" class="text-xs"></span>
        </div>
        <input id="fileInput" type="file" accept=".xlsx,.csv" class="hidden" />

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
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#16a34a',
    width: 600,
    focusConfirm: false,
    allowOutsideClick: () => !Swal.isLoading(), // don't close while uploading
    didOpen: () => {
      const dz = document.getElementById('dz')
      const input = document.getElementById('fileInput')
      const browseBtn = document.getElementById('browseBtn')
      const fileNameEl = document.getElementById('fileName')

      const acceptExts = ['xlsx', 'csv']
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
    // 👇 This runs when you click "Upload"
    preConfirm: async () => {
      if (!selectedFile) {
        Swal.showValidationMessage('Please select a file first.')
        return false // keep modal open
      }

      const progressWrap = document.getElementById('progressWrap')
      const bar = document.getElementById('bar')
      const pct = document.getElementById('pct')
      progressWrap.classList.remove('hidden')
      bar.style.width = '0%'; pct.textContent = '0%'

      const fd = new FormData()
      fd.append('file', selectedFile)

      try {
        const res = await axios.post(UPLOAD_URL, fd, {
          headers: { 'Content-Type': 'multipart/form-data' },
          onUploadProgress: (evt) => {
            if (!evt.total) return
            const p = Math.round((evt.loaded / evt.total) * 100)
            bar.style.width = p + '%'
            pct.textContent = p + '%'
          }
        })
        return res.data // becomes result.value below
      } catch (err) {
        const msg = err?.response?.data?.error || err?.response?.data?.message || err.message || 'Upload failed'
        Swal.showValidationMessage(msg)
        return false // keep modal open
      }
    }
  }).then(async (result) => {
    if (result.isConfirmed && result.value) {
      const { inserted=0, updated=0, skipped=0, errors=[] } = result.value
      await Swal.fire({
        icon: 'success',
        title: 'Import completed',
        html: `<div class="text-center">
                 <div><b>Inserted:</b> ${inserted}</div>
                 <div><b>Updated:</b> ${updated}</div>
                 <div><b>Skipped:</b> ${skipped}</div>
                 ${errors.length ? `<hr class="my-2"/><div class="text-sm max-h-40 overflow-auto">${errors.map(e=>`<div>• ${e}</div>`).join('')}</div>` : ''}
               </div>`
      })
      await fetchStudents()
    }
  })
}



onMounted(() => {
  fetchSession()
  fetchStudents()
})
</script>
