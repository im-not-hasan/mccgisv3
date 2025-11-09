<script setup>
const props = defineProps({
  title: { type: String, default: '' },
  rows: { type: Array, default: () => [] },
})
</script>

<template>
  <div class="bg-white rounded-lg shadow-sm border border-slate-100">
    <div class="px-4 py-3 border-b flex items-center justify-between">
      <h3 class="text-sm font-semibold text-slate-700">{{ title }}</h3>
      <span class="text-[10px] text-slate-400">{{ rows.length }} subject(s)</span>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-xs">
        <thead class="bg-slate-50">
          <tr>
            <th class="text-left px-3 py-2 border-b text-slate-500">Subject Code</th>
            <th class="text-left px-3 py-2 border-b text-slate-500">Descriptive Title</th>
            <th class="text-center px-3 py-2 border-b text-slate-500 w-20">Total Units</th>
            <th class="text-center px-3 py-2 border-b text-slate-500 w-20">Grade</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="!rows || rows.length === 0">
            <td colspan="4" class="text-center text-slate-400 py-4">
              No subjects found for this year.
            </td>
          </tr>
          <tr v-for="(row, idx) in rows" :key="idx" class="hover:bg-slate-50 transition">
            <td class="px-3 py-2 border-b border-slate-50 text-slate-700">{{ row.code }}</td>
            <td class="px-3 py-2 border-b border-slate-50 text-slate-500">{{ row.title }}</td>
            <td class="px-3 py-2 border-b border-slate-50 text-center">
              {{ row.total_units ?? '—' }}
            </td>
            <td class="px-3 py-2 border-b border-slate-50 text-center">
              <span v-if="row.grade">{{ row.grade }}</span>
              <span v-else class="text-slate-300">—</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
