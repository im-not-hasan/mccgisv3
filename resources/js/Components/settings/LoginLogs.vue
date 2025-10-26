<template>
  <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
    <!-- Header -->
    <div class="flex justify-between items-center">
      <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">Activity Logs</h2>
      <button
        @click="fetchLogs"
        class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-md transition md:mt-[-17px] mb-2 md:mb-0 text-xs md:text-base"
      >
        Refresh
      </button>
    </div>
    <hr class="border-t border-gray-300 mb-4" />

    <!-- Loading -->
    <div v-if="loading" class="text-center text-gray-500 py-6">
      Loading logs...
    </div>

    <!-- Table -->
    <div v-else class="overflow-x-auto max-w-full">
      <table class="min-w-full border-separate border-spacing-y-2 table-fixed">
        <thead class="bg-mccblue text-white">
          <tr>
            <th class="px-4 py-2 text-left text-xs md:text-base w-[25%]">User</th>
            <th class="px-4 py-2 text-left text-xs md:text-base w-[15%]">Event</th>
            <th class="px-4 py-2 text-left text-xs md:text-base w-[20%]">IP</th>
            <th class="px-4 py-2 text-left text-xs md:text-base w-[20%]">View</th>
            <th class="px-4 py-2 text-left text-xs md:text-base w-[20%]">Date</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="log in logs"
            :key="log.id"
            class="bg-white text-gray-800 border hover:bg-gray-100 transition"
          >
            <td class="px-4 py-2 text-xs md:text-base">
              <span class="font-semibold">{{ log.user_name || 'Unknown' }}</span>
              <span class="text-gray-500 text-xs md:text-sm ml-1">
                ({{ log.user_level || 'N/A' }})
              </span>
            </td>
            <td class="px-4 py-2 capitalize text-xs md:text-base">
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
            <td class="px-4 py-2 text-xs md:text-base">{{ log.ip_address }}</td>
            <td class="px-4 py-2 text-xs md:text-base text-blue-600">
              <button
                @click="openModal(log)"
                class="hover:underline text-blue-700 font-medium"
              >
                View Details
              </button>
            </td>
            <td class="px-4 py-2 text-gray-600 text-xs md:text-base">
              {{ formatDate(log.created_at) }}
            </td>
          </tr>
          <tr v-if="logs.length === 0">
            <td colspan="5" class="text-center py-4 text-gray-500">
              No login activity found.
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 🌍 Modal -->
     <teleport to="body">
    <Transition name="fade">
      <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white w-full max-w-3xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">

          <!-- ❌ Close -->
          <button
            @click="closeModal"
            class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition"
          >
            &times;
          </button>

          <!-- 🧾 Header -->
          <h2 class="text-xl font-bold mb-4 text-mccblue select-none">Login Details</h2>

          <!-- 🧠 Info -->
          <p><strong>User:</strong> {{ selectedLog.user_name }} ({{ selectedLog.user_level }})</p>
          <p><strong>IP:</strong> {{ selectedLog.ip_address }}</p>
          <p><strong>Event:</strong> {{ selectedLog.event }}</p>
          <p><strong>Date:</strong> {{ formatDate(selectedLog.created_at) }}</p>

          <!-- 🛰️ Loading State -->
          <div v-if="geoLoading" class="text-gray-500 mt-4 flex justify-center py-6">
            <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
            </svg>
          </div>

          <div v-else-if="geoError" class="text-red-600 mt-4">{{ geoError }}</div>

          <!-- ✅ Map -->
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
import { ref, onMounted, nextTick } from 'vue'
import axios from 'axios'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

// fix missing icons in vite
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

// Fetch logs
const fetchLogs = async () => {
  loading.value = true
  try {
    const res = await axios.get('/admin/login-logs')
    logs.value = Array.isArray(res.data) ? res.data : []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

onMounted(fetchLogs)

const formatDate = (dt) => new Date(dt).toLocaleString()

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
tr:hover {
  transition: background-color 0.25s ease;
}

/* ✨ same animations as AssignmentForm.vue */
.animate-fade-in-up {
  animation: fadeInUp 0.3s ease-out;
}
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(25px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
