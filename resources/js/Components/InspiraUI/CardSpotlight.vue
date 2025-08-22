<template>
  <div
    :style="{ backgroundColor: bgColor }"
    class="group relative flex justify-between items-center w-full h-[150px] overflow-hidden rounded-xl border shadow-md text-white px-6 py-4 hover:scale-[1.05] transition-transform cursor-pointer"
    @mousemove="handleMouseMove"
    @mouseleave="handleMouseLeave"
  >
    <!-- Left side: label and count -->
    <div class="z-10 text-left">
      <div class="text-base font-medium select-none">{{ label }}</div>
      <div class="text-3xl font-bold select-none mt-2">{{ count }}</div>
    </div>

    <!-- Right side: icon -->
    <div class="z-10">
      <component
        v-if="useSvg && iconComponent"
        :is="iconComponent"
        class="w-16 h-16 text-white opacity-90"
      />
      <img
        v-else
        :src="`/icons/${iconName}.png`"
        alt="Icon"
        class="w-16 h-16 object-contain"
      />
    </div>

    <!-- Click to view overlay 
    <div class="pointer-events-none absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition text-white text-sm font-semibold bg-black bg-opacity-20 rounded-xl">
      Click to view
    </div>-->

    <!-- Bottom-right arrow indicator --->
    <div class="absolute bottom-3 right-4 flex items-center gap-1 opacity-80 group-hover:translate-x-1 group-hover:opacity-100 transition z-10">
      <span class="text-xs font-medium"></span>
      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
      </svg>
    </div>

    <!-- Spotlight effect -->
    <div
      class="pointer-events-none absolute inset-0 rounded-xl opacity-0 transition-opacity duration-300 group-hover:opacity-100"
      :style="{
        background: backgroundStyle,
        opacity: gradientOpacity,
      }"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, defineProps } from 'vue'
import { cn } from '@/lib/utils'

// Lucide icon imports
import { User, Users, BookOpen, ClipboardList } from 'lucide-vue-next'

const props = withDefaults(
  defineProps<{
    label: string
    count: number | string
    iconName: string
    useSvg: boolean
    gradientSize?: number
    gradientColor?: string
    gradientOpacity?: number
    bgColor?: string
  }>(),
  {
    bgColor: '#85cee8',
    gradientSize: 200,
    gradientColor: '#cdeaf4',
    gradientOpacity: 0.4,
  },
)

const iconMap: Record<string, any> = {
  students: Users,
  teachers: User,
  grades: ClipboardList,
  subjects: BookOpen,
}

const iconComponent = computed(() => iconMap[props.iconName.toLowerCase()] || null)

const mouseX = ref(-props.gradientSize * 10)
const mouseY = ref(-props.gradientSize * 10)

function handleMouseMove(e: MouseEvent) {
  const target = e.currentTarget as HTMLElement
  const rect = target.getBoundingClientRect()
  mouseX.value = e.clientX - rect.left
  mouseY.value = e.clientY - rect.top
}

function handleMouseLeave() {
  mouseX.value = -props.gradientSize * 10
  mouseY.value = -props.gradientSize * 10
}

onMounted(() => {
  mouseX.value = -props.gradientSize * 10
  mouseY.value = -props.gradientSize * 10
})

const backgroundStyle = computed(() => {
  return `radial-gradient(
    circle at ${mouseX.value}px ${mouseY.value}px,
    ${props.gradientColor} 0%,
    rgba(0, 0, 0, 0) 70%
  )`
})
</script>
