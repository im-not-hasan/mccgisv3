<template>
  <DashboardLayout
    :fullname="fullname"
    :userLevel="userLevel"
    :title="'Trash'"
    class="animate-slide-in-top"
  >
    <div class="max-w-5xl mx-auto space-y-6">
        <!-- Students Trash -->
        <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
        <div class="md:flex md:justify-between items-center">
            <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">
            Students
            </h2>
        </div>
        <hr class="border-t border-gray-300 mb-4" />

        <table class="w-full border-separate border-spacing-y-2 table-fixed">
            <thead class="bg-mccblue text-white">
            <tr>
                <th class="px-4 py-2 w-1/3 text-left">Student ID</th>
                <th class="px-4 py-2 w-1/3 text-left">Name</th>
                <th class="px-4 py-2 w-1/3 text-right">Actions</th>
            </tr>
            </thead>
            <tbody>
            <!-- Loading -->
            <tr v-if="loadingStud">
                <td colspan="3" class="text-center py-4 text-gray-500">
                Loading students...
                </td>
            </tr>

            <!-- Items -->
            <tr
                v-else
                v-for="s in studentTrash"
                :key="s.id"
                class="bg-white text-gray-800 border hover:bg-gray-100 transition"
            >
                <td class="px-4 py-2">{{ s.studid }}</td>
                <td class="px-4 py-2">{{ s.fname }} {{ s.lname }}</td>
                <td class="px-4 py-2 text-right">
                <div class="flex justify-end items-center gap-4">
                    <!-- Restore -->
                    <button
                    @click="restoreStudent(s)"
                    class="text-green-600 hover:text-green-800 text-sm font-medium"
                    >
                    Restore
                    </button>

                    <!-- Delete Permanently -->
                    <button
                    @click="forceDeleteStudent(s)"
                    class="text-red-600 hover:text-red-800 text-sm font-medium"
                    >
                    Delete Permanently
                    </button>
                </div>
                </td>
            </tr>

            <!-- Empty -->
            <tr v-if="!loadingStud && studentTrash.length === 0">
                <td colspan="3" class="text-center py-4 text-gray-500">
                No student records in trash.
                </td>
            </tr>
            </tbody>
        </table>
        </div>

        <!-- Teachers Trash -->
        <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
          <div class="md:flex md:justify-between items-center">
            <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">
              Instructors
            </h2>
          </div>
          <hr class="border-t border-gray-300 mb-4" />

          <table class="w-full border-separate border-spacing-y-2 table-fixed">
            <thead class="bg-mccblue text-white">
              <tr>
                <th class="px-4 py-2 w-1/3 text-left">Instructor ID</th>
                <th class="px-4 py-2 w-1/3 text-left">Name</th>
                <th class="px-4 py-2 w-1/3 text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <!-- Loading -->
              <tr v-if="loadingInstructors">
                <td colspan="3" class="text-center py-4 text-gray-500">
                  Loading instructors...
                </td>
              </tr>

              <!-- Items -->
              <tr
                v-else
                v-for="t in instructorTrash"
                :key="t.id"
                class="bg-white text-gray-800 border hover:bg-gray-100 transition"
              >
                <td class="px-4 py-2">{{ t.teachid }}</td>
                <td class="px-4 py-2">{{ t.fname }} {{ t.lname }}</td>
                <td class="px-4 py-2 text-right">
                  <div class="flex justify-end items-center gap-4">
                    <button
                      @click="restoreInstructor(t)"
                      class="text-green-600 hover:text-green-800 text-sm font-medium"
                    >
                      Restore
                    </button>
                    <button
                      @click="forceDeleteInstructor(t)"
                      class="text-red-600 hover:text-red-800 text-sm font-medium"
                    >
                      Delete Permanently
                    </button>
                  </div>
                </td>
              </tr>

              <!-- Empty -->
              <tr v-if="!loadingInstructors && instructorTrash.length === 0">
                <td colspan="3" class="text-center py-4 text-gray-500">
                  No instructor records in trash.
                </td>
              </tr>
            </tbody>
          </table>
        </div>

      <!-- Academic Years Trash -->
      <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
        <div class="md:flex md:justify-between items-center">
          <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">
            Academic Years  
          </h2>
        </div>
        <hr class="border-t border-gray-300 mb-4" />

        <table class="w-full border-separate border-spacing-y-2 table-fixed">
          <thead class="bg-mccblue text-white">
            <tr>
              <th class="px-4 py-2 text-left w-1/3">Academic Year</th>
              <th class="px-4 py-2 text-center w-1/3">Semester</th>
              <th class="px-4 py-2 text-right w-1/3">Actions</th>
            </tr>
          </thead>
          <tbody>
            <!-- Loading row -->
            <tr v-if="loadingAY">
              <td colspan="3" class="text-center py-4 text-gray-500">
                Loading academic years...
              </td>
            </tr>

            <!-- Items -->
            <tr
              v-else
              v-for="year in ayTrash"
              :key="year.id"
              class="bg-white text-gray-800 border hover:bg-gray-100 transition"
            >
              <td class="px-4 py-2">
                {{ year.academicyear }}
              </td>
              <td class="px-4 py-2 text-center">
                {{
                  year.semester === '1'
                    ? 'First Semester'
                    : year.semester === '2'
                    ? 'Second Semester'
                    : 'Summer'
                }}
              </td>
              <td class="px-4 py-2 text-right">
                <div class="flex justify-end items-center gap-4">
                  <!-- Restore -->
                  <button
                    @click="restoreAY(year)"
                    class="text-green-600 hover:text-green-800 text-sm font-medium"
                    title="Restore from Trash"
                  >
                    Restore
                  </button>

                  <!-- Delete Permanently -->
                  <button
                    @click="forceDeleteAY(year)"
                    class="text-red-600 hover:text-red-800 text-sm font-medium"
                    title="Delete Permanently"
                  >
                    Delete Permanently
                  </button>
                </div>
              </td>
            </tr>

            <!-- Empty state -->
            <tr v-if="!loadingAY && ayTrash.length === 0">
              <td colspan="3" class="text-center py-4 text-gray-500">
                No academic years in trash.
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Curriculums Trash -->
      <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
        <div class="md:flex md:justify-between items-center">
          <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">
            Curriculums  
          </h2>
        </div>
        <hr class="border-t border-gray-300 mb-4" />

        <table class="w-full border-separate border-spacing-y-2 table-fixed">
          <thead class="bg-mccblue text-white">
            <tr>
              <th class="px-4 py-2 text-left w-2/3">Curriculum</th>
              <th class="px-4 py-2 text-right w-1/3">Actions</th>
            </tr>
          </thead>
          <tbody>
            <!-- Loading row -->
            <tr v-if="loadingCurr">
              <td colspan="2" class="text-center py-4 text-gray-500">
                Loading curriculums...
              </td>
            </tr>

            <!-- Items -->
            <tr
              v-else
              v-for="c in curriculumTrash"
              :key="c.id"
              class="bg-white text-gray-800 border hover:bg-gray-100 transition"
            >
              <td class="px-4 py-2">
                Curriculum {{ c.curriculum }}
              </td>
              <td class="px-4 py-2 text-right">
                <div class="flex justify-end items-center gap-4">
                  <!-- Restore -->
                  <button
                    @click="restoreCurriculum(c)"
                    class="text-green-600 hover:text-green-800 text-sm font-medium"
                    title="Restore from Trash"
                  >
                    Restore
                  </button>

                  <!-- Delete Permanently -->
                  <button
                    @click="forceDeleteCurriculum(c)"
                    class="text-red-600 hover:text-red-800 text-sm font-medium"
                    title="Delete Permanently"
                  >
                    Delete Permanently
                  </button>
                </div>
              </td>
            </tr>

            <!-- Empty state -->
            <tr v-if="!loadingCurr && curriculumTrash.length === 0">
              <td colspan="2" class="text-center py-4 text-gray-500">
                No curriculums in trash.
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Later: Add similar blocks here for Students / Instructors / etc -->
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import DashboardLayout from '@/Components/dashboard/DashboardLayout.vue'

const fullname = ref('')
const userLevel = ref('')
const username = ref('')

const studentTrash = ref([])
const instructorTrash = ref([])
const ayTrash = ref([])
const curriculumTrash = ref([])

const loadingStud = ref(false)
const loadingInstructors = ref(false)
const loadingAY = ref(false)
const loadingCurr = ref(false)


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


const fetchStudentTrash = async () => {
  try {
    loadingStud.value = true
    const { data } = await axios.get('/students/settings/archived')
    studentTrash.value = Array.isArray(data) ? data : []
  } catch (e) {
    console.error('Failed to fetch student trash:', e)
  } finally {
    loadingStud.value = false
  }
}

const fetchInstructorTrash = async () => {
  try {
    loadingInstructors.value = true
    console.log('[Trash] fetchInstructorTrash called')
    const { data } = await axios.get('/instructors/settings/archived')
    console.log('[Trash] /instructors/settings/archived response:', data)
    instructorTrash.value = Array.isArray(data) ? data : []
  } catch (e) {
    console.error('Failed to fetch instructor trash:', e)
  } finally {
    loadingInstructors.value = false
  }
}

const fetchAYTrash = async () => {
  try {
    loadingAY.value = true
    const { data } = await axios.get('/ay/archived')
    ayTrash.value = Array.isArray(data) ? data : []
  } catch (e) {
    console.error('Failed to fetch AY trash:', e)
  } finally {
    loadingAY.value = false
  }
}

const fetchCurriculumTrash = async () => {
  try {
    loadingCurr.value = true
    const { data } = await axios.get('/curriculums/archived')
    curriculumTrash.value = Array.isArray(data) ? data : []
  } catch (e) {
    console.error('Failed to fetch curriculum trash:', e)
  } finally {
    loadingCurr.value = false
  }
}

const restoreStudent = async (student) => {
  const confirm = await Swal.fire({
    title: 'Restore from Trash?',
    text: `Restore student ${student.fname} ${student.lname} (ID: ${student.studid})?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#16a34a',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Restore',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.post(`/students/settings/${student.id}/restore`)
    await fetchStudentTrash()
    Swal.fire({
      icon: 'success',
      title: 'Restored from Trash',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not restore student', 'error')
  }
}

const forceDeleteStudent = async (student) => {
  const confirm = await Swal.fire({
    title: 'Delete Permanently?',
    html: `
      <p class="text-sm text-gray-700">
        This will <b>permanently delete</b> student ${student.fname} ${student.lname}
        (ID: ${student.studid}).<br>
        This action cannot be undone.
      </p>
    `,
    icon: 'error',
    showCancelButton: true,
    confirmButtonColor: '#b91c1c',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Delete Permanently',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.delete(`/students/settings/${student.id}/force-delete`)
    await fetchStudentTrash()
    Swal.fire({
      icon: 'success',
      title: 'Permanently Deleted',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not permanently delete student', 'error')
  }
}

const restoreInstructor = async (t) => {
  const confirm = await Swal.fire({
    title: 'Restore from Trash?',
    text: `Restore instructor ${t.fname} ${t.lname} (ID: ${t.teachid})?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#16a34a',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Restore',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.post(`/instructors/settings/${t.id}/restore`)
    await fetchInstructorTrash()
    Swal.fire({
      icon: 'success',
      title: 'Restored from Trash',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not restore instructor', 'error')
  }
}

const forceDeleteInstructor = async (t) => {
  const confirm = await Swal.fire({
    title: 'Delete Permanently?',
    html: `
      <p class="text-sm text-gray-700">
        This will <b>permanently delete</b> instructor ${t.fname} ${t.lname}
        (ID: ${t.teachid}).<br>
        This action cannot be undone.
      </p>
    `,
    icon: 'error',
    showCancelButton: true,
    confirmButtonColor: '#b91c1c',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Delete Permanently',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.delete(`/instructors/settings/${t.id}/force-delete`)
    await fetchInstructorTrash()
    Swal.fire({
      icon: 'success',
      title: 'Permanently Deleted',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not permanently delete instructor', 'error')
  }
}

const restoreAY = async (year) => {
  const confirm = await Swal.fire({
    title: 'Restore from Trash?',
    text: `Restore Academic Year ${year.academicyear} (${
      year.semester === '1'
        ? 'First Semester'
        : year.semester === '2'
        ? 'Second Semester'
        : 'Summer'
    }) back to the active list?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#16a34a',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Restore',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.post(`/ay/${year.id}/restore`)
    await fetchAYTrash()
    Swal.fire({
      icon: 'success',
      title: 'Restored from Trash',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not restore academic year', 'error')
  }
}

const forceDeleteAY = async (year) => {
  const confirm = await Swal.fire({
    title: 'Delete Permanently?',
    html: `
      <p class="text-sm text-gray-700">
        This will <b>permanently delete</b> Academic Year ${year.academicyear}.<br>
        This action cannot be undone.
      </p>
    `,
    icon: 'error',
    showCancelButton: true,
    confirmButtonColor: '#b91c1c',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Delete Permanently',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.delete(`/ay/${year.id}/force-delete`)
    await fetchAYTrash()
    Swal.fire({
      icon: 'success',
      title: 'Permanently Deleted',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not permanently delete academic year', 'error')
  }
}

const restoreCurriculum = async (c) => {
  const confirm = await Swal.fire({
    title: 'Restore from Trash?',
    text: `Restore Curriculum ${c.curriculum} back to the active list?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#16a34a',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Restore',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.post(`/curriculums/${c.id}/restore`)
    await fetchCurriculumTrash()
    Swal.fire({
      icon: 'success',
      title: 'Restored from Trash',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not restore curriculum', 'error')
  }
}

const forceDeleteCurriculum = async (c) => {
  const confirm = await Swal.fire({
    title: 'Delete Permanently?',
    html: `
      <p class="text-sm text-gray-700">
        This will <b>permanently delete</b> Curriculum ${c.curriculum}.<br>
        This action cannot be undone.
      </p>
    `,
    icon: 'error',
    showCancelButton: true,
    confirmButtonColor: '#b91c1c',
    cancelButtonColor: '#6b7280',
    confirmButtonText: 'Delete Permanently',
  })

  if (!confirm.isConfirmed) return

  try {
    await axios.delete(`/curriculums/${c.id}/force-delete`)
    await fetchCurriculumTrash()
    Swal.fire({
      icon: 'success',
      title: 'Permanently Deleted',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (e) {
    Swal.fire('Error', 'Could not permanently delete curriculum', 'error')
  }
}

onMounted(async () => {
  await fetchSession()
  if (userLevel.value !== 'admin') {
    window.location.href = '/'
    return
  }
  fetchStudentTrash()
  fetchInstructorTrash()
  fetchAYTrash()
  fetchCurriculumTrash()
  
})
</script>
