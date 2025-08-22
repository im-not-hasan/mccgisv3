<template>
  <div>
    <!-- Trigger Button -->
    <button
      @click="openModal"
      class="bg-green-600 hover:bg-green-700 text-white  px-4 py-2 rounded-lg shadow-md transition"
    >
      <p class="text-xs md:text-base select-none">+ Add Instructor</p>
    </button>

    <!-- Modal -->
    <Transition name="fade">
      <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-whitebg w-full max-w-3xl p-6 rounded-xl shadow-lg relative animate-fade-in-up">
          <h2 class="text-xl font-bold mb-4 text-mccblue  select-none">
            {{ editMode ? 'Edit Instructor' : 'Add New Instructor' }}
          </h2>

          <!-- Form -->
          <form @submit.prevent="handleSubmit" class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm text-black  mb-1 select-none">Teacher ID</label>
              <input
                type="text"
                v-model="form.teachid"
                placeholder="e.g. 2000-2000"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
                required
              />
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">First Name</label>
              <input
                type="text"
                v-model="form.fname"
                placeholder="e.g. Juan"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
                required
              />
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">Middle Name</label>
              <input
                type="text"
                v-model="form.mname"
                placeholder="Leave blank if N/A"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
              />
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">Last Name</label>
              <input
                type="text"
                v-model="form.lname"
                placeholder="e.g. Dela Cruz"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
                required
              />
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">Gender</label>
              <select
                v-model="form.sex"
                class="w-full border border-black px-3 py-2 bg-white text-black  focus:border-mccblue focus:outline-none focus:ring-0  "
                required
              >
                <option value="" disabled>Select gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">Age</label>
              <input
                type="number"
                v-model="form.age"
                min="18"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
              />
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">Email</label>
              <input
                type="email"
                v-model="form.email"
                placeholder="e.g. juandelacruz@example.com"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
              />
            </div>

            <div>
              <label class="block text-sm text-black  mb-1 select-none">Phone</label>
              <input
                v-model="form.phone"
                placeholder="e.g. 09123456789"
                class="w-full border border-black px-3 py-2 bg-white text-black placeholder-gray-300 focus:border-mccblue focus:outline-none focus:ring-0  "
              />
            </div>


            <!-- Actions -->
            <div class="md:col-span-2 flex justify-end gap-4 pt-4">
              <button
                type="button"
                @click="cancelEdit"
                class="text-black  hover:text-red-500 transition"
              >
                Cancel
              </button>
              <button
                type="submit"
                class="bg-mccblue hover:bg-mccdarkblue text-white  px-4 py-2 rounded-md  transition"
              >
                Save
              </button>
            </div>
          </form>

          <!-- Close Button -->
          <button
            @click="cancelEdit"
            class="absolute top-4 right-4 text-black  text-2xl hover:text-red-500 transition"
          >
            &times;
          </button>
        </div>
      </div>
    </Transition>
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
        department: department, // override whatever's coming from instructor
      }

      isOpen.value = true
    }
  },
  { immediate: true }
)

const handleSubmit = async () => {
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
</style>
