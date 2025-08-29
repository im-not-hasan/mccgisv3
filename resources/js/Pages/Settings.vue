<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="'Settings'" class="animate-slide-in-top">
    
    <div class="max-w-4xl mx-auto space-y-6">
      
      <!-- Profile Overview Card -->
      <div class="bg-white rounded-lg shadow-md p-6 border border-gray-200 w-full">
        <h2 class="text-2xl font-bold text-mccblue mb-4 select-none">Profile Overview</h2>

        <div class="space-y-3">
          <div class="flex flex-col md:flex-row md:justify-between">
            <span class="text-gray-600">User ID:</span>
            <span class="font-medium text-gray-800">{{ username }}</span>
          </div>
          <div class="flex flex-col md:flex-row md:justify-between">
            <span class="text-gray-600">Full Name:</span>
            <span class="font-medium text-gray-800">{{ fullname }}</span>
          </div>
          <div class="flex flex-col md:flex-row md:justify-between">
            <span class="text-gray-600">Role:</span>
            <span class="font-medium text-gray-800 capitalize">{{ userLevel }}</span>
          </div>
        </div>
      </div>

      <!-- Security Section -->
      <div class="bg-white rounded-lg shadow-md p-6 border border-gray-200 w-full">
        <h2 class="text-2xl font-bold text-mccblue mb-4 select-none">Security</h2>

        <div class="space-y-3">
          <div class="flex flex-col md:flex-row md:justify-between">
            <span class="text-gray-600">Username:</span>
            <span class="font-medium text-gray-800">{{ username }}</span>
          </div>
          <div class="flex flex-col md:flex-row md:justify-between items-start md:items-center">
            <span class="text-gray-600">Password:</span>
            <span class="font-medium text-gray-800">********</span>
          </div>

          <!-- Change Password Form Trigger -->
          <div class="mt-4">
            <ChangePasswordForm />
          </div>
        </div>
      </div>

      <!-- Existing Admin AcademicYearList -->
      <AcademicYearList class="select-none" v-if="userLevel === 'admin'" />
      <CurriculumList v-if="userLevel === 'admin'" />

    </div>

  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import AcademicYearList from '@/Components/settings/AcademicYearList.vue'
import ChangePasswordForm from '@/Components/settings/ChangePasswordForm.vue'
import CurriculumList from '@/Components/settings/CurriculumList.vue'

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
