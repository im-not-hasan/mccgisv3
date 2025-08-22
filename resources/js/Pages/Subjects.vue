<template>
  <DashboardLayout :fullname="fullname" :userLevel="userLevel" :title="(userLevel === 'teacher' || userLevel === 'student') ? 'My Subjects' : 'Subjects'" class="animate-slide-in-top">
   
    <div v-if="loading" class="flex justify-center py-10">
      <svg class="animate-spin h-8 w-8 text-mccblue" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
        <path class="opacity-75" fill="currentColor"
          d="M4 12a8 8 0 018-8v8H4z"/>
      </svg>
    </div>

    <div v-else>
      <!-- 🟢 Admin Classes -->
      <AdminSubjects v-if="userLevel === 'admin'" />

      <!-- 🟠 Teacher Classes -->
      <TeacherSubjects v-else-if="userLevel === 'teacher'" />

      <!-- 🔵 Student Dashboard -->
       <StudentSubjects v-else-if="userLevel === 'student'" />

      <!-- ⚠️ Unknown user level -->
      <div v-else class="text-center text-red-500">
        Unknown user level: {{ userLevel }}
      </div>
    </div>

  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'
import AdminSubjects from '@/Components/subjects/AdminSubjects.vue'
import TeacherSubjects from '@/Components/subjects/TeacherSubjects.vue'
import StudentSubjects from '@/Components/subjects/StudentSubjects.vue'

const fullname = ref('')
const userLevel = ref('')
const username = ref('')
const loading = ref(true)


const fetchSession = async () => {
  try {
    const res = await axios.get('/session')
    fullname.value = res.data.fullname
    userLevel.value = res.data.level
    username.value = res.data.username
    if (!fullname.value || !userLevel.value) window.location.href = '/'
  } catch {
    window.location.href = '/'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchSession()
})
</script>
