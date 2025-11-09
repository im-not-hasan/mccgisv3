<template>
  <!-- Overlay -->
  <div
    v-if="isOpen"
    @click="toggleSidebar"
    class="fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity"
  ></div>

  <!-- Sidebar -->
  <aside
    :class="[
      'fixed top-0 left-0 h-full bg-mccblue text-white w-64 p-4 z-50 flex flex-col transition-transform duration-300 ease-in-out',
      isOpen ? 'translate-x-0' : '-translate-x-full',
    ]"
  >
    <div class="flex items-center gap-3">
      <!-- Close Button -->
      <button
        @click="toggleSidebar"
        class="mb-6 p-2 rounded-3xl hover:bg-mccdarkblue transition self-start"
        aria-label="Close sidebar"
      >
        <svg
          class="w-6 h-6 text-white"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          viewBox="0 0 24 24"
        >
          <line x1="3" y1="12" x2="21" y2="12" />
          <line x1="3" y1="6" x2="21" y2="6" />
          <line x1="3" y1="18" x2="21" y2="18" />
        </svg>
      </button>

      <img src="/logo.png" alt="Logo" class="h-[40px] scale-125 mt-[-24px]" />
    </div>

    <!-- Navigation -->
    <nav class="flex flex-col gap-3 flex-grow  text-white text-[17px] font-medium">
      <!-- Admin Sidebar -->
<template v-if="userLevel === 'admin'">
  <SidebarLink name="Dashboard" href="/dashboard">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M3 12l2-2m0 0l7-7 7 7m-9 2v8m4 0h4a2 2 0 002-2v-5a2 2 0 00-2-2h-1" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Students" href="/students">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 20h5v-2a4 4 0 00-4-4h-1M7 20H2v-2a4 4 0 014-4h1
                   m4-4a4 4 0 110-8 4 4 0 010 8zm6 4a4 4 0 10-8 0" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Instructors" href="/instructors">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 20h5v-2a4 4 0 00-4-4h-1M7 20H2v-2a4 4 0 014-4h1
                   m4-4a4 4 0 110-8 4 4 0 010 8zm6 4a4 4 0 10-8 0" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Classes" href="/classes">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 14l9-5-9-5-9 5 9 5z
                 M12 14l6.16-3.422A12.083 12.083 0 0121 10.78v6.72a2 2 0 01-2 2H5
                 a2 2 0 01-2-2v-6.72c.888.28 1.833.614 2.84 1.056L12 14z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Subjects" href="/subjects">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 20l-9-5 9-5 9 5-9 5z
                 M12 12l-9-5 9-5 9 5-9 5z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Consultation" href="/consultation">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8 10h.01M12 10h.01M16 10h.01
                 M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Settings" href="/settings">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4
                 m0-12a8 8 0 100 16 8 8 0 000-16z" />
      </svg>
    </template>
  </SidebarLink>
</template>

<!-- Teacher Sidebar -->
<template v-else-if="userLevel === 'teacher'">
  <SidebarLink name="Dashboard" href="/dashboard">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M3 12l2-2m0 0l7-7 7 7m-9 2v8m4 0h4a2 2 0 002-2v-5a2 2 0 00-2-2h-1" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="My Subjects" href="/subjects">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 20l-9-5 9-5 9 5-9 5z
                 M12 12l-9-5 9-5 9 5-9 5z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="My Classes" href="/classes">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 20h5v-2a4 4 0 00-4-4h-1
                 M7 20H2v-2a4 4 0 014-4h1
                 m4-4a4 4 0 110-8 4 4 0 010 8z
                 m6 4a4 4 0 10-8 0" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Consultation" href="/consultation">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8 10h.01M12 10h.01M16 10h.01
                 M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Settings" href="/settings">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4
                 m0-12a8 8 0 100 16 8 8 0 000-16z" />
      </svg>
    </template>
  </SidebarLink>
</template>

<!-- Student Sidebar -->
<template v-else-if="userLevel === 'student'">
  <SidebarLink name="Dashboard" href="/dashboard">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M3 12l2-2m0 0l7-7 7 7m-9 2v8m4 0h4a2 2 0 002-2v-5a2 2 0 00-2-2h-1" />
      </svg>
    </template>
  </SidebarLink>

   <SidebarLink name="View Grades" href="/viewgrades">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 14l9-5-9-5-9 5 9 5z
                 M12 14l6.16-3.422A12.083 12.083 0 0121 10.78v6.72a2 2 0 01-2 2H5
                 a2 2 0 01-2-2v-6.72c.888.28 1.833.614 2.84 1.056L12 14z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Consultation" href="/consultation">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8 10h.01M12 10h.01M16 10h.01
                 M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Settings" href="/settings">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4
                 m0-12a8 8 0 100 16 8 8 0 000-16z" />
      </svg>
    </template>
  </SidebarLink>
</template>

<!-- Registrar Sidebar -->
<template v-if="userLevel === 'registrar'">
  <SidebarLink name="Dashboard" href="/dashboard">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M3 12l2-2m0 0l7-7 7 7m-9 2v8m4 0h4a2 2 0 002-2v-5a2 2 0 00-2-2h-1" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Classes" href="/classes">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 14l9-5-9-5-9 5 9 5z
                 M12 14l6.16-3.422A12.083 12.083 0 0121 10.78v6.72a2 2 0 01-2 2H5
                 a2 2 0 01-2-2v-6.72c.888.28 1.833.614 2.84 1.056L12 14z" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Students" href="/students">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 20h5v-2a4 4 0 00-4-4h-1M7 20H2v-2a4 4 0 014-4h1
                   m4-4a4 4 0 110-8 4 4 0 010 8zm6 4a4 4 0 10-8 0" />
      </svg>
    </template>
  </SidebarLink>

  <SidebarLink name="Settings" href="/settings">
    <template #icon>
      <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4
                 m0-12a8 8 0 100 16 8 8 0 000-16z" />
      </svg>
    </template>
  </SidebarLink>
</template>


    </nav>
  </aside>
</template>

<script setup>
import { h } from 'vue'

const props = defineProps({
  isOpen: Boolean,
  userLevel: String,
})

const emit = defineEmits(['toggle-sidebar'])

function toggleSidebar() {
  emit('toggle-sidebar')
}

const SidebarLink = (props, { slots }) => {
  return h('a', {
    href: props.to || '#', 
    class: 'flex items-center gap-3 rounded-md p-2 hover:bg-mccdarkblue transition-colors'
  }, [
    h('span', { class: 'ml-[0.5px] w-5 h-5' }, slots.icon ? slots.icon() : null),
    h('span', { class: 'ml-2' }, props.name)
  ])
}

SidebarLink.props = {
  name: String,
  to: {
    type: String,
    default: '#',
  },
}

</script>
