<template>
  
  <div>
    <!-- Trigger Button -->
    <button
      @click="isOpen = true"
      class="bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 px-4 rounded-md transition"
    >
      Change Password
    </button>

    <!-- Modal -->
    <teleport to="body">
    <Transition name="fade">
      <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white w-full max-w-md p-6 rounded-xl shadow-lg relative animate-fade-in-up">
          <h2 class="text-xl font-bold mb-4 text-mccblue select-none">Change Password</h2>

          <!-- Form -->
          <form @submit.prevent="handleSubmit" class="space-y-5">
            <!-- Old Password -->
            <div class="relative">
              <label for="oldPassword" class="block text-sm font-medium text-gray-700 mb-1">Old Password</label>
              <input
                :type="showOldPassword ? 'text' : 'password'"
                id="oldPassword"
                v-model="form.oldPassword"
                required
                placeholder="Enter old password"
                class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
              />
              <button
                type="button"
                tabindex="-1"
                @click="showOldPassword = !showOldPassword" 
                class="absolute right-3 top-9 text-gray-500 hover:text-mccblue transition"
              >
                <svg v-if="!showOldPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.478 0-8.268-2.943-9.542-7z" />
                </svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7 1.274-4.057 5.064-7 9.542-7 1.011 0 1.988.149 2.91.425M15 12a3 3 0 01-6 0m-6.9-5.9l13.8 13.8" />
                </svg>
              </button>
            </div>

            <!-- New Password -->
            <div class="relative">
              <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
              <input
                :type="showNewPassword ? 'text' : 'password'"
                id="newPassword"
                v-model="form.newPassword"
                required
                placeholder="Enter new password"
                class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
              />
              <button
                type="button"
                tabindex="-1"
                @click="showNewPassword = !showNewPassword"
                class="absolute right-3 top-9 text-gray-500 hover:text-mccblue transition"
              >
                <svg v-if="!showNewPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.478 0-8.268-2.943-9.542-7z" />
                </svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7 1.274-4.057 5.064-7 9.542-7 1.011 0 1.988.149 2.91.425M15 12a3 3 0 01-6 0m-6.9-5.9l13.8 13.8" />
                </svg>
              </button>
            </div>

            <!-- Confirm New Password -->
            <div class="relative">
              <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
              <input
                :type="showConfirmPassword ? 'text' : 'password'"
                id="confirmPassword"
                v-model="form.confirmPassword"
                required
                placeholder="Confirm new password"
                class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
              />
              <button
                type="button"
                tabindex="-1"
                @click="showConfirmPassword = !showConfirmPassword"
                class="absolute right-3 top-9 text-gray-500 hover:text-mccblue transition"
              >
                <svg v-if="!showConfirmPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.478 0-8.268-2.943-9.542-7z" />
                </svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7 1.274-4.057 5.064-7 9.542-7 1.011 0 1.988.149 2.91.425M15 12a3 3 0 01-6 0m-6.9-5.9l13.8 13.8" />
                </svg>
              </button>
            </div>

            <!-- Password Match Status -->
            <div v-if="form.confirmPassword" class="text-sm font-medium" :class="passwordMatch ? 'text-green-600' : 'text-red-600'">
              {{ passwordMatch ? 'Passwords match' : 'Passwords do not match' }}
            </div>

            <!-- Buttons -->
            <div class="flex justify-end gap-4 pt-2">
              <button type="button" @click="closeModal" class="text-gray-500 hover:text-red-500 transition">Cancel</button>
              <button type="submit" :disabled="!passwordMatch" class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition">Update</button>
            </div>
          </form>

          <!-- Close Icon -->
          <button @click="closeModal" class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition">
            &times;
          </button>
        </div>
      </div>
    </Transition>
    </teleport>
  </div>
  
</template>

<script setup>
import { ref, computed } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const isOpen = ref(false)

const form = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: '',
})

const showOldPassword = ref(false)
const showNewPassword = ref(false)
const showConfirmPassword = ref(false)

const passwordMatch = computed(() => form.value.newPassword && form.value.newPassword === form.value.confirmPassword)

const handleSubmit = async () => {
  if (!passwordMatch.value) {
    Swal.fire({ icon: 'warning', title: 'Passwords do not match!' })
    return
  }

  try {
    const res = await axios.post('/settings/update-password', {
      oldPassword: form.value.oldPassword,
      newPassword: form.value.newPassword,
    })

    form.value.oldPassword = ''
    form.value.newPassword = ''
    form.value.confirmPassword = ''

    Swal.fire({ icon: 'success', title: res.data.message || 'Password Updated!' })
    closeModal()
  } catch (error) {
    Swal.fire({ icon: 'error', title: error.response?.data?.message || 'Error updating password.' })
    console.error(error)
  }
}

const closeModal = () => {
  isOpen.value = false
  form.value = { oldPassword: '', newPassword: '', confirmPassword: '' }
}
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
.animate-fade-in-up {
  animation: fadeInUp 0.3s ease-out;
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(25px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
