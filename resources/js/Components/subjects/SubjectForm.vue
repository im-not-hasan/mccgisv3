<template>
  <div>
    <!-- Trigger Button -->
    <button
      @click="openModal"
      class="bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 px-4 rounded-md transition"
    >
      + Add Subject
    </button>

    <!-- Modal Teleport -->
    <teleport to="body">
      <Transition name="fade">
        <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div class="bg-white w-full max-w-2xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">
            <h2 class="text-xl font-bold mb-4 text-mccblue select-none">
              {{ editMode ? 'Edit Subject' : 'Add New Subject' }}
            </h2>

            <!-- Form -->
            <form @submit.prevent="handleSubmit" class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Subject Code</label>
                <input
                  type="text"
                  v-model="form.code"
                  placeholder="e.g. BSIT101"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Subject Title</label>
                <input
                  type="text"
                  v-model="form.title"
                  placeholder="e.g. Introduction to Computing"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Lecture Units</label>
                <input
                  type="number"
                  v-model.number="form.lecunit"
                  min="0"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Lab Units</label>
                <input
                  type="number"
                  v-model.number="form.labunit"
                  min="0"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Total Units</label>
                <input
                  type="number"
                  :value="Number(form.lecunit) + Number(form.labunit)"
                  disabled
                  class="peer w-full rounded-md border border-gray-300 bg-gray-100 text-gray-800 px-3 py-2 placeholder-gray-400"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Prerequisites</label>
                <input
                  type="text"
                  v-model="form.pre"
                  placeholder="e.g. None"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Year Level</label>
                <select
                  v-model="form.year"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                >
                  <option value="" disabled>Select Year</option>
                  <option value="1">1st Year</option>
                  <option value="2">2nd Year</option>
                  <option value="3">3rd Year</option>
                  <option value="4">4th Year</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Semester</label>
                <select
                  v-model="form.semester"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                >
                  <option value="" disabled>Select Semester</option>
                  <option value="1">1st Semester</option>
                  <option value="2">2nd Semester</option>
                  <option value="summer">Summer</option>
                </select>
              </div>

              <!-- Form Actions -->
              <div class="md:col-span-2 flex justify-end gap-4 pt-4">
                <button
                  type="button"
                  @click="cancelEdit"
                  class="text-gray-500 hover:text-red-500 transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-md transition"
                >
                  Save
                </button>
              </div>
            </form>

            <!-- Close Button -->
            <button
              @click="cancelEdit"
              class="absolute top-4 right-4 text-gray-500 text-2xl hover:text-red-500 transition"
            >
              &times;
            </button>
          </div>
        </div>
      </Transition>
    </teleport>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import { usePage } from '@inertiajs/vue3'

const emit = defineEmits(['submitted', 'cancelEdit'])
const { props } = usePage()

const isOpen = ref(false)

const propsExternal = defineProps({
  course: String,
  editMode: Boolean,
  subjectToEdit: Object,
})

const form = ref({
  code: '',
  title: '',
  lecunit: 0,
  labunit: 0,
  pre: '',
  year: '',
  semester: '',
})

const openModal = () => {
  if (!propsExternal.editMode) {
    resetForm()
    isOpen.value = true
  }
}

const resetForm = () => {
  form.value = {
    code: '',
    title: '',
    lecunit: 0,
    labunit: 0,
    pre: '',
    year: '',
    semester: '',
  }
}

const cancelEdit = () => {
  isOpen.value = false
  resetForm()
  emit('cancelEdit')
}

watch(
  () => propsExternal.subjectToEdit,
  (subject) => {
    if (propsExternal.editMode && subject) {
      form.value = {
        code: subject.code,
        title: subject.title,
        lecunit: subject.lecunit,
        labunit: subject.labunit,
        pre: subject.pre,
        year: subject.year,
        semester: subject.semester,
      }
      isOpen.value = true
    }
  },
  { immediate: true }
)

const handleSubmit = async () => {
  const payload = {
    code: form.value.code,
    title: form.value.title,
    lecunit: form.value.lecunit,
    labunit: form.value.labunit,
    pre: form.value.pre,
    year: form.value.year,
    semester: form.value.semester,
    course: propsExternal.course,
  }

  try {
    if (propsExternal.editMode && propsExternal.subjectToEdit?.id) {
      await axios.put(`/subjects/${propsExternal.subjectToEdit.id}`, payload)
      Swal.fire({
        icon: 'success',
        title: 'Subject Updated',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } else {
      await axios.post('/subjects', payload)
      Swal.fire({
        icon: 'success',
        title: 'Subject Added',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }

    resetForm()
    isOpen.value = false
    emit('submitted')
  } catch (error) {
    Swal.fire('Error', 'Could not save subject', 'error')
    console.error('Subject save error:', error)
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
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
