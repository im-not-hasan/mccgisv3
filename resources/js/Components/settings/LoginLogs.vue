<template>
  <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
    <!-- Header -->
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-2xl font-semibold text-mccblue">Activity Logs</h2>
      <button
        @click="fetchLogs"
        class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-md text-xs md:text-base transition"
      >
        Refresh
      </button>
    </div>

    <!-- Controls -->
    <div class="flex flex-col md:flex-row justify-between items-center mb-4">
      <div class="mb-2 md:mb-0">
        <label class="mr-2">Show</label>
        <select v-model="perPage" @change="updatePagination" class="border py-1 rounded">
          <option v-for="n in [10,25,50,100]" :key="n" :value="n">{{ n }}</option>
        </select>
        <span class="ml-2">entries</span>
      </div>

      <input
        v-model="search"
        @input="updatePagination"
        type="text"
        placeholder="Search logs..."
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
            <th class="py-2 px-4 text-center select-none cursor-pointer" @click="toggleSort('user_name')">
              User
              <span v-if="sortKey === 'user_name'">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span>
            </th>
            <th class="py-2 px-4 text-center select-none cursor-pointer" @click="toggleSort('event')">
              Event
              <span v-if="sortKey === 'event'">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span>
            </th>
            <th class="py-2 px-4 text-center select-none cursor-pointer" @click="toggleSort('ip_address')">
              IP
              <span v-if="sortKey === 'ip_address'">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span>
            </th>
            <th class="py-2 px-4 text-center">View</th>
            <th class="py-2 px-4 text-center select-none cursor-pointer" @click="toggleSort('created_at')">
              Date
              <span v-if="sortKey === 'created_at'">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="log in paginatedLogs"
            :key="log.id"
            class="hover:bg-gray-100 transition"
          >
            <td class="px-4 py-2 text-center">
              <span class="font-semibold">{{ log.user_name || 'Unknown' }}</span>
              <span class="text-gray-500 text-xs md:text-sm ml-1">
                ({{ log.user_level || 'N/A' }})
              </span>
            </td>
            <td class="px-4 py-2 text-center capitalize">
              <span
                :class="{
                  'text-green-600 font-semibold': log.event === 'login',
                  'text-red-600 font-semibold': log.event === 'logout',
                  'text-yellow-600 font-semibold': log.event === 'failed',
                }"
              >
                {{ log.event }}
              </span>
            </td>
            <td class="px-4 py-2 text-center">{{ log.ip_address }}</td>
            <td class="px-4 py-2 text-center text-blue-600">
              <button
                @click="openModal(log)"
                class="hover:underline font-medium"
              >
                View Details
              </button>
            </td>
            <td class="px-4 py-2 text-center text-gray-600">
              {{ formatDate(log.created_at) }}
            </td>
          </tr>
          <tr v-if="paginatedLogs.length === 0">
            <td colspan="5" class="text-center py-4 text-gray-500">
              No login activity found.
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination Controls -->
      <div class="flex justify-between bg-mcclightblue items-center px-2 text-sm text-white select-none rounded-b-lg mt-2">
        <div>
          Showing
          <span class="font-semibold">{{ paginatedLogs.length ? (currentPage-1)*perPage+1 : 0 }}</span>
          to
          <span class="font-semibold">{{ (currentPage-1)*perPage + paginatedLogs.length }}</span>
          of
          <span class="font-semibold">{{ filteredLogs.length }}</span> entries
        </div>

        <div class="flex gap-1">
          <button @click="clearSorting" class="text-sm hover:bg-mccblue px-2 py-1 rounded transition">Clear Sorting</button>

          <button
            @click="currentPage--"
            :disabled="currentPage === 1"
            class="px-3 py-1 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue"
          >Prev</button>

          <button
            v-for="page in totalPages"
            :key="page"
            @click="currentPage = page"
            :class="[
              'px-3 py-1 rounded',
              currentPage === page ? 'bg-white text-mccblue font-bold' : 'hover:bg-mccblue transition'
            ]"
          >
            {{ page }}
          </button>

          <button
            @click="currentPage++"
            :disabled="currentPage === totalPages"
            class="px-3 py-1 rounded disabled:opacity-50 disabled:hover:bg-mcclightblue hover:bg-mccblue transition"
          >Next</button>
        </div>
      </div>
    </div>

    <!-- 🌍 Modal -->
    <teleport to="body">
      <Transition name="fade">
        <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div class="bg-white w-full max-w-3xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">
            <button @click="closeModal" class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition">&times;</button>
            <h2 class="text-xl font-bold mb-4 text-mccblue select-none">Login Details</h2>

            <p><strong>User:</strong> {{ selectedLog.user_name }} ({{ selectedLog.user_level }})</p>
            <p><strong>IP:</strong> {{ selectedLog.ip_address }}</p>
            <p><strong>Event:</strong> {{ selectedLog.event }}</p>
            <p><strong>Date:</strong> {{ formatDate(selectedLog.created_at) }}</p>

            <div v-if="geoLoading" class="text-gray-500 mt-4 flex justify-center py-6">
              <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
              </svg>
            </div>

            <div v-else-if="geoError" class="text-red-600 mt-4">{{ geoError }}</div>

            <div v-else class="mt-4">
              <p><strong>Location:</strong> {{ geoData.city }}, {{ geoData.region }}, {{ geoData.country }}</p>
              <p><strong>Org:</strong> {{ geoData.org || '—' }}</p>
              <p><strong>Latitude:</strong> {{ geoData.latitude }}</p>
              <p><strong>Longitude:</strong> {{ geoData.longitude }}</p>
              <div id="map" class="w-full h-64 mt-3 rounded-md border"></div>
            </div>
          </div>
        </div>
      </Transition>
    </teleport>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, nextTick } from 'vue'
import axios from 'axios'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

// Fix missing Leaflet icons
delete L.Icon.Default.prototype._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: new URL('leaflet/dist/images/marker-icon-2x.png', import.meta.url).href,
  iconUrl: new URL('leaflet/dist/images/marker-icon.png', import.meta.url).href,
  shadowUrl: new URL('leaflet/dist/images/marker-shadow.png', import.meta.url).href,
})

const logs = ref([])
const loading = ref(true)
const isOpen = ref(false)
const selectedLog = ref({})
const geoLoading = ref(false)
const geoError = ref('')
const geoData = ref({})
let mapInstance = null

// Pagination & Sorting
const currentPage = ref(1)
const perPage = ref(10)
const search = ref('')
const sortKey = ref('created_at')
const sortDirection = ref('desc')

// Fetch logs
const fetchLogs = async () => {
  loading.value = true
  try {
    const res = await axios.get('/admin/login-logs')
    logs.value = Array.isArray(res.data) ? res.data : []
    updatePagination()
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

onMounted(fetchLogs)

const formatDate = (dt) => new Date(dt).toLocaleString()

// Computed: filtered + sorted logs
const filteredLogs = computed(() => {
  let data = logs.value.filter(log =>
    (log.user_name || '').toLowerCase().includes(search.value.toLowerCase()) ||
    (log.user_level || '').toLowerCase().includes(search.value.toLowerCase()) ||
    (log.event || '').toLowerCase().includes(search.value.toLowerCase()) ||
    (log.ip_address || '').includes(search.value)
  )

  if (sortKey.value) {
    data.sort((a, b) => {
      const valA = a[sortKey.value] || ''
      const valB = b[sortKey.value] || ''
      if (valA < valB) return sortDirection.value === 'asc' ? -1 : 1
      if (valA > valB) return sortDirection.value === 'asc' ? 1 : -1
      return 0
    })
  }

  return data
})

const totalPages = computed(() => Math.ceil(filteredLogs.value.length / perPage.value))

const paginatedLogs = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  return filteredLogs.value.slice(start, start + perPage.value)
})

const updatePagination = () => {
  currentPage.value = 1
}

// Sorting helpers
const toggleSort = (key) => {
  if (sortKey.value === key) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value = key
    sortDirection.value = 'asc'
  }
}

const clearSorting = () => {
  sortKey.value = 'created_at'
  sortDirection.value = 'desc'
}

// Modal / Map
const openModal = async (log) => {
  selectedLog.value = log
  isOpen.value = true
  geoLoading.value = true
  geoError.value = ''
  geoData.value = {}

  try {
    const res = await axios.get(`/admin/logs/geolocate?ip=${log.ip_address}`)
    geoData.value = res.data
    if (!geoData.value.latitude || !geoData.value.longitude) {
      geoError.value = 'No coordinates returned for this IP.'
      geoLoading.value = false
      return
    }
    await nextTick()
    setTimeout(() => initMap(), 500)
  } catch (err) {
    console.error(err)
    geoError.value = 'Failed to fetch location.'
  } finally {
    geoLoading.value = false
  }
}

const closeModal = () => {
  isOpen.value = false
  if (mapInstance) {
    mapInstance.remove()
    mapInstance = null
  }
}

function initMap() {
  if (!geoData.value.latitude || !geoData.value.longitude) return

  const lat = geoData.value.latitude
  const lon = geoData.value.longitude
  const city = geoData.value.city || 'Unknown City'
  const country = geoData.value.country || 'Unknown Country'

  const mapEl = document.getElementById('map')
  if (!mapEl) return
  if (mapInstance) mapInstance.remove()

  mapInstance = L.map(mapEl).setView([lat, lon], 10)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(mapInstance)

  L.marker([lat, lon])
    .addTo(mapInstance)
    .bindPopup(`<b>${city}</b><br>${country}`)
    .openPopup()

  setTimeout(() => mapInstance.invalidateSize(), 400)
}
</script>

<style scoped>
.hover\:bg-gray-100:hover { background-color: #f5f5f5; }
.animate-fade-in-up { animation: fadeInUp 0.3s ease-out; }
@keyframes fadeInUp { from { opacity:0; transform:translateY(25px);} to{opacity:1; transform:translateY(0);} }
.fade-enter-active, .fade-leave-active { transition: opacity 0.25s ease; }
.fade-enter-from, .fade-leave-to { opacity:0; }
</style>
