<template>
  <div class="min-h-screen flex flex-col">
    <!-- Topbar -->
    <Topbar :fullname="fullname" :userLevel="userLevel" :title="title" @toggle-sidebar="toggleSidebar" />

    <div class="flex flex-1 relative">
      <!-- Sidebar -->
      <Sidebar
        :isOpen="sidebarOpen"
        :userLevel="userLevel"
        @toggle-sidebar="toggleSidebar"
      />

      <main class="flex-1 p-6 bg-gray-50">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import Topbar from './Topbar.vue'
import Sidebar from './Sidebar.vue'

defineProps({
  userLevel: String,
  fullname: String,
  title: {
    type: String,
    default: 'Dashboard',
  },
})

const sidebarOpen = ref(false)

function toggleSidebar() {
  sidebarOpen.value = !sidebarOpen.value
}
</script>
