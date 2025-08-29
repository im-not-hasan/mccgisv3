<template>
  <div class="p-6 rounded-xl shadow-xl bg-white text-gray-800">
    <div class="md:flex md:justify-between items-center">
      <h2 class="text-2xl font-semibold mb-2 md:mb-4 ml-2 text-mccblue">Curriculum List</h2>
      <CurriculumForm @submitted="fetchCurriculums" class="md:mt-[-17px] mb-2 md:mb-0" />
    </div>
    <hr class="border-t border-gray-300 mb-4" />

    <table class="w-full border-separate border-spacing-y-2 table-fixed">
      <thead class="bg-mccblue text-white">
        <tr>
          <th class="px-4 py-2 text-left w-2/3">Curriculum</th>
          <th class="px-4 py-2 text-right w-1/3">Display</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="c in curriculumList"
          :key="c.id"
          class="bg-white text-gray-800 border hover:bg-gray-100 transition"
        >
          <td class="px-4 py-2">Curriculum {{ c.curriculum }}</td>
          <td class="px-4 py-2 text-right">
            <div class="flex justify-end items-center gap-4">
              <!-- ✅ Toggle Display -->
              <label class="inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  class="sr-only"
                  :checked="Boolean(c?.display)"
                  :disabled="saving.has(c.id)"
                  @change="toggleDisplay(c)"
                />
                <span class="relative w-10 h-6 bg-gray-300 rounded-full transition-colors duration-300 block">
                  <span class="absolute top-[2px] left-[2px] w-5 h-5 bg-white rounded-full transition-transform duration-300 ball"></span>
                </span>
              </label>

              <!-- 🗑 Delete -->
              <button
                @click="deleteCurriculum(c)"
                class="text-red-500 hover:text-red-700"
                title="Delete"
              >
                🗑️
              </button>
            </div>
          </td>
        </tr>

        <tr v-if="curriculumList.length === 0">
          <td colspan="2" class="text-center py-4 text-gray-500">No curriculums available.</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import CurriculumForm from './CurriculumForm.vue'

const curriculumList = ref([])
const saving = ref(new Set())

const fetchCurriculums = async () => {
  const { data } = await axios.get('/curriculums')
  // Expecting an array of { id, curriculum, display }
  curriculumList.value = Array.isArray(data) ? data : []
}

const toggleDisplay = async (c) => {
  if (!c || typeof c.display === 'undefined') return
  if (saving.value.has(c.id)) return
  saving.value.add(c.id)

  try {
    const newDisplay = c.display ? 0 : 1
    const res = await axios.post('/curriculums/toggle-display', {
      id: c.id,
      display: newDisplay,
    })

    // Authoritative server state (also ensures “only one active” rule reflects in UI)
    if (res.data?.curriculums) {
      curriculumList.value = res.data.curriculums
    } else {
      // fallback local update if server didn't return list
      curriculumList.value = curriculumList.value.map(row =>
        row.id === c.id ? { ...row, display: newDisplay } : (newDisplay ? { ...row, display: 0 } : row)
      )
    }

    Swal.fire({
      icon: 'success',
      title: 'Curriculum Display Updated',
      toast: true,
      position: 'top-end',
      timer: 1600,
      showConfirmButton: false,
    })
  } catch (e) {
    try { await fetchCurriculums() } catch {}
    Swal.fire('Error', 'Could not update curriculum', 'error')
  } finally {
    saving.value.delete(c.id)
  }
}

const deleteCurriculum = async (c) => {
  const confirm = await Swal.fire({
    title: 'Are you sure?',
    text: `Delete Curriculum ${c.curriculum}?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#e3342f',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes',
  })

  if (confirm.isConfirmed) {
    try {
      await axios.delete(`/curriculums/${c.id}`)
      curriculumList.value = curriculumList.value.filter((x) => x.id !== c.id)
      Swal.fire({
        icon: 'success',
        title: 'Curriculum Deleted',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    } catch {
      Swal.fire('Error', 'Could not delete curriculum', 'error')
    }
  }
}

onMounted(fetchCurriculums)
</script>

<style scoped>
input[type="checkbox"]:checked + span {
  background-color: #22c55e; /* Tailwind green-500 */
}
input[type="checkbox"]:checked + span .ball {
  transform: translateX(20px);
}
</style>
