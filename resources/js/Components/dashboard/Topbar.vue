<template>
  <header class="relative flex items-center justify-between bg-mccblue shadow p-4 z-40">
    <div class="flex items-center gap-3">
      <!-- Sidebar toggle -->
      <button
        @click="toggleSidebar"
        class="p-2 rounded-3xl hover:bg-mccdarkblue transition z-10"
        aria-label="Open sidebar"
      >
        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
          <line x1="3" y1="12" x2="21" y2="12" />
          <line x1="3" y1="6" x2="21" y2="6" />
          <line x1="3" y1="18" x2="21" y2="18" />
        </svg>
      </button>
      <img src="/logo.png" alt="Logo" class="select-none h-[40px] scale-125 cursor-pointer z-10" @click="goToDashboard"/>
    </div>

    <!-- Title centered absolutely -->
    <div class="absolute left-0 right-0 text-center">
      <h1 class="text-lg font-semibold text-white">{{ title }}</h1>
    </div>

    <!-- Profile Button -->
    <div class="relative" ref="dropdownRef">
      <button @click="dropdownOpen = !dropdownOpen" class="p-2 rounded-full bg-mccblue hover:bg-mccdarkblue focus:outline-none transition z-10">
        <!-- User icon -->
        <svg class="h-6 w-6 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
          <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4z"/>
          <path d="M4 20c0-4 4-6 8-6s8 2 8 6"/>
        </svg>
      </button>

      <!-- Dropdown menu -->
      <div
        v-if="dropdownOpen"
        class="absolute right-0 mt-1 w-48 bg-white text-black rounded-lg shadow-lg z-50 overflow-hidden"
      >
        <div class="px-4 py-2 text-md font-medium border-b border-gray-200">
          {{ fullname }}
          <div class="text-xs font-thin mt-[-2px]">{{ userLevel }}</div>
        </div>
        <button
          @click="toggleDarkMode"
          class="w-full text-left px-4 py-2 text-sm hover:bg-gray-100 transition"
        >
          Toggle Dark Mode
        </button>
        <button
          @click="logout"
          class="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100 transition"
        >
          Logout
        </button>
      </div>
    </div>
  </header>
</template>




<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import { router } from '@inertiajs/vue3'

const emit = defineEmits(['toggle-sidebar'])

const props = defineProps({
  fullname: String,
  userLevel: String,
  title: {
    type: String,
    default: 'Dashboard',
  }
})

const dropdownOpen = ref(false)
const dropdownRef = ref(null)

function toggleSidebar() {
  emit('toggle-sidebar')
}

const toggleDarkMode = () => {
  document.documentElement.classList.toggle('dark')
  localStorage.setItem('theme', document.documentElement.classList.contains('dark') ? 'dark' : 'light')
}

const goToDashboard = () => {
  router.visit(`/dashboard`)
}

const confirmLogout = async () => {
  const result = await Swal.fire({
    title: 'Logout',
    text: 'Are you sure you want to logout? All unsaved changes will be lost.',
    showCancelButton: true,
    confirmButtonText: 'Logout',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
  })

  if (result.isConfirmed) {
    try {
      await axios.post('/logout', {}, { withCredentials: true })
      window.location.href = '/'
    } catch (error) {
      console.error('Logout failed:', error)
      Swal.fire('Oops!', 'Logout failed.', 'error')
    }
  }
}

async function logout(){
  try {
    await axios.post('/logout') // CSRF cookie already handled by Laravel’s default setup
    window.location.href = '/'
  } catch (e) {
    console.error(e)
  }
}

// 👉 Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
    dropdownOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

