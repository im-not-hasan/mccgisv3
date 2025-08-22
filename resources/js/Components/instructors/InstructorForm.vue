<template>
  <div>
    <!-- Trigger Button -->
    <button
      @click="openModal"
      class="bg-mccblue hover:bg-mccdarkblue text-white px-4 py-2 rounded-lg shadow-md transition"
    >
      + Add Instructor
    </button>

    <!-- Modal Teleport -->
    <teleport to="body">
      <Transition name="fade">
        <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div class="bg-white w-full max-w-3xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">
            <h2 class="text-xl font-bold mb-4 text-mccblue select-none">
              {{ editMode ? 'Edit Instructor' : 'Add New Instructor' }}
            </h2>

            <!-- Form -->
            <form @submit.prevent="handleSubmit" class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Teacher ID</label>
                <input
                type="text"
                v-model="form.teachid"
                placeholder="e.g. 20001234"
                maxlength="8" 
                class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                required
              />

              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">First Name</label>
                <input
                  type="text"
                  v-model="form.fname"
                  placeholder="e.g. Juan"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Middle Name</label>
                <input
                  type="text"
                  v-model="form.mname"
                  placeholder="Leave blank if N/A"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Last Name</label>
                <input
                  type="text"
                  v-model="form.lname"
                  placeholder="e.g. Dela Cruz"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Gender</label>
                <select
                  v-model="form.sex"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                  required
                >
                  <option value="" disabled>Select gender</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Age</label>
                <input
                  type="number"
                  v-model="form.age"
                  min="18"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Email</label>
                <input
                  type="email"
                  v-model="form.email"
                  placeholder="e.g. juandelacruz@example.com"
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1 select-none">Phone</label>
                <input
                  v-model="form.phone"
                  @input="formatPhone"
                  placeholder="e.g. 09123456789"
                  maxlength="11" 
                  class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 py-2 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                />

              </div>

              <!-- Actions -->
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

const emit = defineEmits(['submitted', 'cancelEdit'])

const props = defineProps({
  course: String, // department
  editMode: Boolean,
  instructorToEdit: Object,
})

const isOpen = ref(false)
const department = props.course

const form = ref({
  teachid: '',
  fname: '',
  mname: '',
  lname: '',
  sex: '',
  age: '',
  email: '',
  phone: '',
  department: department,
})

const resetForm = () => {
  form.value = {
    teachid: '',
    fname: '',
    mname: '',
    lname: '',
    sex: '',
    age: '',
    email: '',
    phone: '',
    department: department,
  }
}

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

watch(
  () => props.instructorToEdit,
  (instructor) => {
    if (props.editMode && instructor) {
      form.value = {
        teachid: instructor.teachid,
        fname: instructor.fname,
        mname: instructor.mname,
        lname: instructor.lname,
        sex: instructor.sex,
        age: instructor.age,
        email: instructor.email,
        phone: instructor.phone,
        department: department, 
      }
      isOpen.value = true
    }
  },
  { immediate: true }
)

const formatPhone = () => {
  form.value.phone = form.value.phone.replace(/\D/g, '') // remove non-digits
}


// Check if teachid exists
const checkTeachidExists = async (teachid) => {
  try {
    const res = await axios.get(`/api/instructors/check/${teachid}`)
    return res.data.exists
  } catch (error) {
    console.error('Failed to check teachid:', error)
    return false
  }
}

const handleSubmit = async () => {
  // Check if teachid exists only when adding new
  if (!props.editMode) {
    const exists = await checkTeachidExists(form.value.teachid)
    if (exists) {
      Swal.fire('Error', 'Teacher ID already exists. Please use a unique ID.', 'error')
      return
    }
  }

  try {
    if (props.editMode && props.instructorToEdit?.id) {
      await axios.put(`/instructors/${props.instructorToEdit.id}`, form.value)
      Swal.fire({
        icon: 'success',
        title: 'Instructor Updated',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } else {
      await axios.post('/instructors', form.value)
      Swal.fire({
        icon: 'success',
        title: 'Instructor Added',
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
    Swal.fire('Error', 'Could not save instructor', 'error')
    console.error('Instructor save error:', error)
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
z