<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="'Generate Reports'" class="animate-slide-in-top">
    
  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'

const fullname = ref('')
const userLevel = ref('')
const username = ref('')

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

onMounted(() => {
  fetchSession()
})
</script>
