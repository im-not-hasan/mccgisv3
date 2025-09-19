<template>
  <WavyBackground>
  <div class="flex w-full  mx-auto md:flex-row flex-col items-center justify-between gap-x-60 md:px-20">
    <!-- Left Section -->
  <div class="flex flex-col justify-center items-center md:w-1/2 px-6 py-10 md:-mt-20 animate-slide-in-top">
    <div class="w-full max-w-md text-center">
      <img src="/logo.png" alt="Logo" class="h-52 select-none md:h-80 mb-[-70px] md:mb-[-35px] mx-auto" />
      <p class="hidden md:block text-lg md:text-xl text-mccmidnightblue mt-0">
        Monitor your grades in real-time with MCC’s official grading and info system.
      </p>
    </div>
  </div>


    <!-- Right Section (Login Card) -->
    <div class="w-full md:w-1/2 flex items-center justify-center py-8 animate-slide-in-top">
      <div class="w-[90%] md:max-w-sm bg-white p-6 rounded-lg shadow-xl border border-gray-200">
        <form @submit.prevent="submit" class="space-y-4">
          <!-- Username -->
          <div class="relative">
            <input
              v-model="form.Username"
              type="text"
              id="username"
              class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 pt-6 pb-2 placeholder-transparent focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
              placeholder=""
              required
            />
            <label
              for="username"
              class="select-none absolute left-3 top-1 text-sm text-gray-500 transition-all 
                peer-placeholder-shown:top-4 peer-placeholder-shown:text-base 
                peer-placeholder-shown:text-gray-400 
                peer-focus:top-1 peer-focus:text-sm peer-focus:text-mccblue" 
            >
              Username
            </label>
          </div>

          <!-- Password -->
          <div class="relative">
            <input
              v-model="form.Password"
              :type="showPassword ? 'text' : 'password'"
              id="password"
              class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 pt-6 pb-2 placeholder-transparent focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
              placeholder=""
              required
              @input="updateEyeIcon"
            />
            <label
              for="password"
              class="select-none absolute left-3 top-1 text-sm text-gray-500 transition-all 
                peer-placeholder-shown:top-4 peer-placeholder-shown:text-base 
                peer-placeholder-shown:text-gray-400 
                peer-focus:top-1 peer-focus:text-sm peer-focus:text-mccblue"
            >
              Password
            </label>

            <!-- Eye Toggle Icon -->
            <button
              v-if="form.Password"
              type="button"
              @click="togglePassword"
              class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-mccblue transition"
            >
              <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                  viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-.728 2.314-2.254 4.33-4.293 5.657M15 12a3 3 0 01-6 0" />
              </svg>
              <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                  viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a10.036 10.036 0 013.262-4.572M9.88 9.88a3 3 0 104.24 4.24M6.1 6.1l11.8 11.8" />
              </svg>
            </button>
          </div>

          <!-- Login Button -->
          <button
            type="submit"
            class="w-full select-none bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 rounded-md transition duration-200"
          >
            Log In
          </button>

          <!-- Forgot Password -->
          <div class="text-center">
            <a href="#" class="text-mccblue hover:underline text-sm transition">Forgot Password?</a>
          </div>

          </form>
      </div>
    </div>
    </div>
  </WavyBackground>
</template>







<script setup>
import Swal from 'sweetalert2'
import axios from 'axios'
import { reactive, ref, onMounted } from 'vue'
import WavyBackground from '@/Components/InspiraUI/WavyBackground.vue'

const form = reactive({
  Username: '',
  Password: '',
  recaptcha_token: '',
  remember: false,
})

const showPassword = ref(false)
let siteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY || ''

function togglePassword() {
  showPassword.value = !showPassword.value
}

function updateEyeIcon() {}

onMounted(() => {
  if (siteKey && !window.grecaptcha) {
    const script = document.createElement('script')
    script.src = `https://www.google.com/recaptcha/api.js?render=${siteKey}`
    script.async = true
    script.defer = true
    document.head.appendChild(script)
  }
})

async function getRecaptchaToken(action = 'login') {
  if (!window.grecaptcha || !siteKey) {
    console.warn('reCAPTCHA not loaded or siteKey missing')
    return null
  }
  await new Promise(resolve => window.grecaptcha.ready(resolve))
  return await window.grecaptcha.execute(siteKey, { action })
}

async function submit() {
  if (!form.Username || !form.Password) {
    return Swal.fire({
      icon: 'error',
      title: 'Oops...',
      text: 'Please fill in both Username and Password.',
    })
  }

  try {
    // 🔑 Step 1: Get token from Google
    const token = await getRecaptchaToken('login')
    if (!token) {
      return Swal.fire('reCAPTCHA Failed', 'Please refresh and try again.', 'error')
    }

    // 🔑 Step 2: Send form + token to backend
    const response = await axios.post('/custom-login', {
      ...form,
      recaptcha_token: token,
    })

    // Success
    const fullname = response.data.fullname || 'User'
    Swal.fire({
      icon: 'success',
      title: 'Login Successful!',
      text: 'Welcome, ' + fullname + '!',
      timer: 1800,
      showConfirmButton: false,
    }).then(() => {
      window.location.href = response.data.redirect
    })
  } catch (error) {
    const status = error.response?.status
    const data = error.response?.data

    if (status === 422 && data?.error === 'recaptcha_failed') {
      Swal.fire('reCAPTCHA Failed', 'Verification failed. Please try again.', 'error')
    } else if (status === 404 && data?.error === 'not_found') {
      Swal.fire('User Not Found', 'No account with that Username.', 'error')
    } else if (status === 401 && data?.error === 'wrong_password') {
      Swal.fire('Incorrect Password', `Wrong password. ${data.attempts} attempt(s) remaining.`, 'error')
    } else if (status === 429 && data?.error === 'locked') {
      lockoutCountdown()
    } else {
      Swal.fire('Login Failed', 'Something went wrong. Please try again.', 'error')
    }
  }
}

function lockoutCountdown() {
  let seconds = 60
  Swal.fire({
    title: 'Too Many Attempts',
    html: `Try again in <b>${seconds}</b> seconds.`,
    allowOutsideClick: false,
    allowEscapeKey: false,
    showConfirmButton: false,
    didOpen: () => {
      const content = Swal.getHtmlContainer().querySelector('b')
      const timer = setInterval(() => {
        seconds--
        content.textContent = seconds
        if (seconds <= 0) {
          clearInterval(timer)
          location.reload()
        }
      }, 1000)
    },
  })
}
</script>


