<template>
  <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
    <div class="md:flex md:justify-between items-center">
      <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">Academic Year List</h2>
      <AcademicYearForm @submitted="fetchAY" class="md:mt-[-17px] mb-2 md:mb-0" />
    </div>
    <hr class="border-t border-gray-300 mb-4" />

    <table class="w-full border-separate border-spacing-y-2 table-fixed">
      <thead class="bg-mccblue text-white">
        <tr>
          <th class="px-4 py-2 text-left w-1/3">Academic Year</th>
          <th class="px-4 py-2 text-center w-1/3">Semester</th>
          <th class="px-4 py-2 text-right w-1/3">Display</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="year in ayList"
          :key="year.id"
          class="bg-white text-gray-800 border hover:bg-gray-100 transition"
        >
          <td class="px-4 py-2">{{ year.academicyear }}</td>
          <td class="px-4 py-2 text-center">
            {{ year.semester === '1' ? 'First Semester' : year.semester === '2' ? 'Second Semester' : 'Summer' }}
          </td>
          <td class="px-4 py-2 text-right">
            <div class="flex justify-end items-center gap-4">
              <!-- ✅ Custom Toggle -->
              <label class="inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  class="sr-only"
                  :checked="year.display"
                  @change="toggleDisplay(year)"
                />
                <span class="relative w-10 h-6 bg-gray-300 rounded-full transition-colors duration-300 block">
                  <span class="absolute top-[2px] left-[2px] w-5 h-5 bg-white rounded-full transition-transform duration-300 ball"></span>
                </span>
              </label>

              <!-- 🗑 Delete Icon -->
              <button
                @click="deleteAY(year)"
                class="text-red-500 hover:text-red-700"
                title="Delete"
              >
                🗑️
              </button>
            </div>
          </td>
        </tr>
        <tr v-if="ayList.length === 0">
          <td colspan="3" class="text-center py-4 text-gray-500">No academic years available.</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import AcademicYearForm from './AcademicYearForm.vue'

const fullname = ref('')
const userLevel = ref('')
const ayList = ref([])

const fetchSession = async () => {
  const { data } = await axios.get('/session')
  fullname.value = data.fullname
  userLevel.value = data.level
  if (!fullname.value || !userLevel.value) window.location.href = '/'
}

const fetchAY = async () => {
  const { data } = await axios.get('/ay')
  ayList.value = data
}

const toggleDisplay = async (year) => {
  try {
    const newDisplay = year.display ? 0 : 1
    await axios.post('/ay/toggle-display', {
      id: year.id,
      display: newDisplay,
    })
    year.display = newDisplay
    Swal.fire({
      icon: 'success',
      title: 'Academic Year Display Updated',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not update academic year', 'error')
  }
}

const deleteAY = async (year) => {
  const confirm = await Swal.fire({
    title: 'Are you sure?',
    text: `Delete Academic Year ${year.academicyear} - ${year.semester === '1' ? 'First Semester' : year.semester === '2' ? 'Second Semester' : 'Summer'}?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#e3342f',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes',
  })

  if (confirm.isConfirmed) {
    try {
      await axios.delete(`/ay/${year.id}`)
      ayList.value = ayList.value.filter((y) => y.id !== year.id)

      Swal.fire({
        icon: 'success',
        title: 'Academic Year Deleted',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } catch (error) {
      Swal.fire('Error', 'Could not delete academic year', 'error')
    }
  }
}

onMounted(() => {
  fetchSession()
  fetchAY()
})
</script>

<style scoped>
input[type="checkbox"]:checked + span {
  background-color: #22c55e; /* Tailwind green-500 */
}
input[type="checkbox"]:checked + span .ball {
  transform: translateX(20px);
}
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
