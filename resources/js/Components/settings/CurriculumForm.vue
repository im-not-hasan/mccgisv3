<template>
  <div>
    <!-- Trigger Button -->
    <button
      @click="isOpen = true"
      class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-md transition"
    >
      <p class="text-xs md:text-base"> + New Curriculum </p>
    </button>

    <!-- Modal -->
    <teleport to="body">
      <Transition name="fade">
        <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div class="bg-white w-full max-w-md p-6 rounded-xl shadow-lg relative animate-fade-in-up">
            <h2 class="text-xl font-bold mb-4 text-mccblue">Create Curriculum</h2>

            <!-- Form -->
            <form @submit.prevent="submitForm" class="space-y-4">
              <!-- Curriculum Number -->
              <div>
                <label class="block text-sm font-medium text-gray-700">Curriculum</label>
                <input
                  v-model="form.curriculum"
                  type="number"
                  placeholder="e.g. 1"
                  class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <!-- Buttons -->
              <div class="flex justify-end gap-4 pt-2">
                <button type="button" @click="closeModal" class="text-gray-500 hover:text-red-500 transition">Cancel</button>
                <button type="submit" class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition">Save</button>
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
import { ref, defineEmits } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const emit = defineEmits(['submitted'])

const isOpen = ref(false)
const form = ref({ curriculum: '' })

const closeModal = () => {
  isOpen.value = false
  form.value = { curriculum: '' }
}

const submitForm = async () => {
  try {
    const { data } = await axios.get('/curriculums')

    // ✅ Prevent duplicate
    const duplicate = data.find(item => parseInt(item.curriculum) === parseInt(form.value.curriculum))
    if (duplicate) {
      return Swal.fire({
        icon: 'error',
        title: 'Duplicate Entry',
        text: 'This curriculum already exists.',
      })
    }

    await axios.post('/settings/curriculum', {
      curriculum: form.value.curriculum,
      display: 0,
    })

    closeModal()
    Swal.fire({
      icon: 'success',
      title: 'Curriculum Added',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
    emit('submitted')
  } catch (e) {
    console.error('Error saving curriculum:', e)
    Swal.fire('Error', 'Could not save curriculum', 'error')
  }
}
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s; }
.fade-enter, .fade-leave-to { opacity: 0; }
.animate-fade-in-up { animation: fadeInUp 0.3s ease-out; }
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(25px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
