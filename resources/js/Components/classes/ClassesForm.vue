<template>
  <div>
    <!-- Trigger Button -->
    <button
      @click="openModal"
      class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-lg shadow-md transition"
    >
      <p class="text-xs md:text-base select-none">+ Add Class</p>
    </button>

    <!-- Modal -->
    <Transition name="fade">
      <teleport to="body">
        <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div class="bg-white w-[90%] max-w-2xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">
            <h2 class="text-xl font-bold mb-4 text-mccblue select-none">
              {{ editMode ? 'Edit Class' : 'Add New Class' }}
            </h2>

            <!-- Form -->
            <form @submit.prevent="handleSubmit" class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <!-- Class Name -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Class Name</label>
                <input
                  type="text"
                  v-model="form.name"
                  placeholder="e.g. BSIT 1-North"
                  class="select-none w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <!-- Course -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Course</label>
                <select
                  v-model="form.course"
                  class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                >
                  <option value="" disabled>Select Course</option>
                  <option v-for="course in courses" :key="course" :value="course">{{ course }}</option>
                </select>
              </div>

              <!-- Year -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Year</label>
                <select
                  v-model="form.year"
                  class="w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                >
                  <option value="" disabled>Select Year</option>
                  <option value="1">1st Year</option>
                  <option value="2">2nd Year</option>
                  <option value="3">3rd Year</option>
                  <option value="4">4th Year</option>
                </select>
              </div>

              <!-- Section -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Section</label>
                <input
                  type="text"
                  v-model="form.section"
                  placeholder="e.g. A"
                  class="select-none w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <!-- Buttons -->
              <div class="md:col-span-2 flex justify-end gap-4 pt-4">
                <button type="button" @click="cancelEdit" class="text-gray-600 hover:text-red-500 transition">Cancel</button>
                <button type="submit" class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition">Save</button>
              </div>
            </form>

            <!-- Close Icon -->
            <button @click="cancelEdit" class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition">
              &times;
            </button>
          </div>
        </div>
      </teleport>
    </Transition>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const emit = defineEmits(['submitted', 'cancelEdit'])
const props = defineProps({
  editMode: Boolean,
  classToEdit: Object,
})

const courses = ['BSIT', 'BSBA', 'BSHM', 'BSED', 'BEED']
const isOpen = ref(false)
const form = ref({ name: '', course: '', year: '', section: '' })

const openModal = () => {
  if (!props.editMode) {
    resetForm()
    isOpen.value = true
  }
}

const cancelEdit = () => {
  isOpen.value = false
  resetForm()
  emit('cancelEdit')
}

const resetForm = () => {
  form.value = { name: '', course: '', year: '', section: '' }
}

watch(() => props.classToEdit, (c) => {
  if (props.editMode && c) {
    form.value = { name: c.name, course: c.course, year: c.year, section: c.section }
    isOpen.value = true
  }
}, { immediate: true })

const handleSubmit = async () => {
  try {
    if (props.editMode && props.classToEdit?.id) {
      await axios.put(`/classes/${props.classToEdit.id}`, form.value)
      Swal.fire({ icon: 'success', title: 'Class Updated', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
    } else {
      await axios.post('/classes', form.value)
      Swal.fire({ icon: 'success', title: 'Class Added', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
    }
    resetForm()
    isOpen.value = false
    emit('submitted')
  } catch (error) {
    Swal.fire('Error', 'Failed to save class.', 'error')
  }
}
</script>

<style scoped>
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
</style>
