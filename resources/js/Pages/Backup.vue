<template>
  <div class="min-h-screen flex items-center justify-center p-6">
    <div class="w-full max-w-lg text-center">
      <h1 class="text-2xl font-bold mb-4">Database Backup</h1>
      <p v-if="loading">Checking session…</p>

      <p v-if="!loading && !isAdmin" class="text-red-600">
        You are not authorized to access this page. Redirecting…
      </p>

      <div v-if="isAdmin && !loading" class="mt-4">
        <p class="mb-2">You are an admin. Click below to download the database backup.</p>
        <button @click="startDownload" class="px-4 py-2 rounded bg-blue-600 text-white">
          Download Backup Now
        </button>
      </div>

      <div v-if="error" class="mt-4 text-red-500">{{ error }}</div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      loading: true,
      isAdmin: false,
      error: null,
    };
  },
  created() {
    this.checkSession();
  },
  methods: {
    async checkSession() {
      try {
        const res = await fetch('/session', { headers: { 'Accept': 'application/json' }});
        if (!res.ok) {
          // If session endpoint returns 401, redirect
          this.loading = false;
          this.isAdmin = false;
          // Redirect after short delay
          setTimeout(() => { window.location = '/'; }, 1200);
          return;
        }
        const json = await res.json();
        // Adjust to the shape your /session returns:
        // e.g. { user: { id: 1, role: 'admin' }, user_level: 'admin' }
        const userLevel = json.user?.role || json.user_level || json.level || null;
        if (userLevel === 'admin' || json.is_admin === true) {
          this.isAdmin = true;
          // Immediately start download OR show UI button
          // auto-start:
        } else {
          this.isAdmin = false;
          setTimeout(() => { window.location = '/'; }, 1200);
        }
      } catch (err) {
        this.error = 'Failed to check session';
        console.error(err);
        setTimeout(() => { window.location = '/'; }, 1200);
      } finally {
        this.loading = false;
      }
    },
    startDownload() {
      // Start download by hitting the server endpoint that actually streams the dump.
      // Use location so that browser will present "Save as" dialog.
      window.location = '/ldpukcabbd';
      // If you prefer fetch + blob:
      // fetch('/secret_backup/download').then(r => r.blob()).then(b => { const u = URL.createObjectURL(b); const a = document.createElement('a'); a.href = u; a.download = 'mccgis.sql'; a.click(); URL.revokeObjectURL(u); });
    }
  }
}
</script>

<style scoped>
/* minimal styling — use your tailwind classes / theme instead */
</style>
