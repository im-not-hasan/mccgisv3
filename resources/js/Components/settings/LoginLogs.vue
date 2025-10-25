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
    <div v-else class="overflow-x-auto">
      <table class="w-full border-separate border-spacing-y-2 table-fixed">
        <thead class="bg-mccblue text-white">
          <tr>
            <th class="px-4 py-2 text-left md:w-[22%] w-[25%] md:text-base text-xs">User</th>
            <th class="px-4 py-2 text-left md:w-[14%] w-[18%] md:text-base text-xs">Event</th>
            <th class="px-4 py-2 text-left md:w-[18%] w-[21%] md:text-base text-xs">IP Address</th>
            <th class="px-4 py-2 text-left md:w-[25%] w-[15%] md:text-base text-xs">Location</th>
            <th class="px-4 py-2 text-left md:w-[21%] w-[21%] md:text-base text-xs">Date</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="log in logs"
            :key="log.id"
            class="bg-white text-gray-800 border hover:bg-gray-100 transition"
          >
            <td class="px-4 py-2">
              <span class="font-semibold  md:text-base text-xs" >{{ log.user_name || 'Unknown' }}</span>
              <span class=" md:text-sm text-xs text-gray-500 md:ml-1">
                ({{ log.user_level || 'N/A' }})
              </span>
            </td>
            <td class="px-4 py-2 capitalize  md:text-base text-xs">
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
            <td class="px-4 py-2 md:text-base text-xs">{{ log.ip_address }}</td>
            <td class="px-4 py-2 md:text-base text-xs">{{ formatLocation(log) }}</td>
            <td class="px-4 py-2 text-gray-600 md:text-base text-xs">{{ formatDate(log.created_at) }}</td>
          </tr>

          <tr v-if="logs.length === 0">
            <td colspan="5" class="text-center py-4 text-gray-500">
              No login activity found.
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const logs = ref([])
const loading = ref(true)

const fetchLogs = async () => {
  loading.value = true
  try {
    const res = await axios.get('/admin/login-logs')
    logs.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Failed to fetch logs:', err)
  } finally {
    loading.value = false
  }
}

onMounted(fetchLogs)

function formatDate(dt) {
  return new Date(dt).toLocaleString()
}

function formatLocation(log) {
  if (!log.country && !log.region && !log.city) return '—'
  return [log.city, log.region, log.country].filter(Boolean).join(', ')
}
</script>

<style scoped>
tr:hover {
  transition: background-color 0.25s ease;
}
</style>
