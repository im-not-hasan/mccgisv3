<template>
  <WavyBackground>
    <div class="flex w-full mx-auto md:flex-row flex-col items-center justify-between gap-x-60 md:px-20">
      <!-- Left Section -->
      <div class="flex flex-col justify-center items-center md:w-1/2 px-6 py-10 md:-mt-20 animate-slide-in-top z-30">
        <div class="w-full max-w-md text-center">
          <img
            src="/logo.png"
            alt="Logo"
            class="h-52 select-none md:h-80 mb-[-70px] md:mb-[-35px] mx-auto"
          />
          <p class="hidden md:block text-lg md:text-xl text-mccmidnightblue mt-0">
            Monitor your grades in real-time with MCC’s official grading and info system.
          </p>
        </div>
      </div>

      <!-- Right Section (Login Card) -->
      <div class="w-full md:w-1/2 flex items-center justify-center py-8 animate-slide-in-top">
        <div
          class="relative w-[90%] md:max-w-sm bg-white p-6 rounded-lg shadow-xl border border-gray-200 overflow-hidden"
          style="height: 310px; width: 300px;"
        >
          <!-- Loading bar -->
          <div
            v-show="isLoading"
            class="absolute top-0 left-0 h-[3px] bg-mccblue transition-all duration-700 ease-in-out"
            :style="{ width: loadingProgress + '%' }"
          ></div>

          <div class="flex items-center justify-center h-full">
            <Transition
              enter-active-class="transition duration-500 ease-in-out transform"
              enter-from-class="translate-x-full opacity-0"
              enter-to-class="translate-x-0 opacity-100"
              leave-active-class="transition duration-500 ease-in-out transform absolute w-full"
              leave-from-class="translate-x-0 opacity-100"
              leave-to-class="-translate-x-full opacity-0"
              mode="out-in"
            >
              <!-- LOGIN FORM -->
              <form
                v-if="step === 'login'"
                key="login"
                @submit.prevent="submit"
                class="w-full space-y-4"
              >
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

                <div class="relative">
                  <input
                    v-model="form.Password"
                    :type="showPassword ? 'text' : 'password'"
                    id="password"
                    class="peer w-full rounded-md border border-gray-300 bg-white text-gray-800 px-3 pt-6 pb-2 placeholder-transparent focus:outline-none focus:ring-2 focus:ring-mccblue focus:border-mccblue transition"
                    placeholder=""
                    required
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

                  <button
                    v-if="form.Password"
                    type="button"
                    @click="togglePassword"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-mccblue transition"
                  >
                    <svg
                      v-if="!showPassword"
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-5 w-5"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-.728 2.314-2.254 4.33-4.293 5.657M15 12a3 3 0 01-6 0" />
                    </svg>
                    <svg
                      v-else
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-5 w-5"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a10.036 10.036 0 013.262-4.572M9.88 9.88a3 3 0 104.24 4.24M6.1 6.1l11.8 11.8" />
                    </svg>
                  </button>
                </div>
                <button
                  type="submit"
                  :disabled="isProcessing"
                  class="w-full select-none bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 rounded-md transition duration-200 disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  Log In
                </button>
                
                <div class="text-center">
                  <a
                    href="#"
                    @click.prevent="handleForgotPassword"
                    class="text-mccblue hover:underline text-sm transition"
                  >
                    Forgot Password?
                  </a>
                  <p class="text-xs text-gray-500 text-center mt-2">
                    By continuing, you agree to our
                    <a href="/terms" class="text-mccblue hover:underline">Terms and Privacy Policy</a>.
                  </p>
                </div>
              </form>

              <!-- FORGOT PASSWORD -->
              <form
                v-else-if="step === 'forgot'"
                key="forgot"
                @submit.prevent="confirmEmail"
                class="w-full space-y-4 text-center"
              >
                <p class="text-gray-600 text-sm mb-3">Confirm the email linked to this account:</p>
                <p class="text-gray-800 font-semibold">{{ partialEmail }}</p>
                <input
                  v-model="confirmEmailInput"
                  type="email"
                  class="w-full border rounded-md px-3 py-2 text-gray-800"
                  placeholder="Enter your full email"
                  required
                />
                <button
                  type="submit"
                  :disabled="isProcessing"
                  class="w-full bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 rounded-md transition duration-200 disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  Verify Email
                </button>
                <a
                  href="#"
                  @click.prevent="step = 'login'"
                  class="block text-mccblue hover:underline text-sm mt-2"
                >
                  Back to Login
                </a>
              </form>

              <!-- OTP -->
              <form
                v-else-if="step === 'otp'"
                key="otp"
                @submit.prevent="verifyOtp"
                class="w-full space-y-4 text-center"
              >
                <p class="text-gray-600 text-sm mb-3">Enter the 6-digit code sent to your email.</p>
                <input
                  v-model="otp"
                  type="text"
                  maxlength="6"
                  class="w-full border rounded-md px-3 py-2 text-center text-lg tracking-widest"
                  placeholder="••••••"
                  required
                />
                <button
                  type="submit"
                  :disabled="isProcessing"
                  class="w-full bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 rounded-md transition duration-200 disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  Verify Code
                </button>

                <!-- Resend OTP -->
                <button
                  type="button"
                  @click="resendOtp"
                  :disabled="isProcessing || resendCooldown > 0"
                  class="w-full bg-gray-200 text-gray-600 font-semibold py-2 rounded-md transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Resend OTP <span v-if="resendCooldown > 0">({{ resendCooldown }}s)</span>
                </button>

                <a
                  href="#"
                  @click.prevent="step = 'login'"
                  class="block text-mccblue hover:underline text-sm mt-2"
                >
                  Back to Login
                </a>
              </form>

              <!-- 🔹 RESET PASSWORD -->
              <form
                v-else-if="step === 'reset'"
                key="reset"
                @submit.prevent="resetPassword"
                class="w-full space-y-4 text-center"
              >
                <p class="text-gray-600 text-sm mb-3">Enter your new password below:</p>

                <div class="relative">
                  <input
                    v-model="newPassword"
                    :type="showNewPassword ? 'text' : 'password'"
                    class="w-full border rounded-md px-3 py-2 text-gray-800"
                    placeholder="New password"
                    required
                  />
                  <button
                    type="button"
                    @click="showNewPassword = !showNewPassword"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-mccblue transition"
                  >
                    <svg v-if="!showNewPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                      viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-.728 2.314-2.254 4.33-4.293 5.657" />
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                      viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a10.036 10.036 0 013.262-4.572M9.88 9.88a3 3 0 104.24 4.24M6.1 6.1l11.8 11.8" />
                    </svg>
                  </button>
                </div>

                <div class="relative">
                  <input
                    v-model="confirmPassword"
                    :type="showNewPassword ? 'text' : 'password'"
                    class="w-full border rounded-md px-3 py-2 text-gray-800"
                    placeholder="Confirm password"
                    required
                  />
                  <button
                    type="button"
                    @click="showNewPassword = !showNewPassword"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-mccblue transition"
                  >
                    <svg v-if="!showNewPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                      viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-.728 2.314-2.254 4.33-4.293 5.657" />
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                      viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a10.036 10.036 0 013.262-4.572M9.88 9.88a3 3 0 104.24 4.24M6.1 6.1l11.8 11.8" />
                    </svg>
                  </button>
                </div>

                <button
                  type="submit"
                  class="w-full bg-mccblue hover:bg-mccdarkblue text-white font-semibold py-2 rounded-md transition duration-200"
                >
                  Reset Password
                </button>

                <a
                  href="#"
                  @click.prevent="step = 'login'"
                  class="block text-mccblue hover:underline text-sm mt-2"
                >
                  Back to Login
                </a>
              </form>

            </Transition>
          </div>
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

const form = reactive({ Username: '', Password: '', recaptcha_token: '', remember: false })
const showPassword = ref(false)
const siteKey = "6LdfZ8srAAAAADvFR2fb8TaU1F-7GEmsk9qu9Sdt"
const step = ref('login')
const otp = ref('')
const isLoading = ref(false)
const loadingProgress = ref(0)
let loadingInterval = null
const isProcessing = ref(false)
const partialEmail = ref('')
const confirmEmailInput = ref('')
const level = ref('')
const resetToken = ref('')
const newPassword = ref('')
const confirmPassword = ref('')
const otpContext = ref('')
const resendCooldown = ref(0)
const resendTimer = ref(null)
const showNewPassword = ref(false)

function togglePassword() { showPassword.value = !showPassword.value }

function startLoading() {
  isLoading.value = true
  loadingProgress.value = 0
  clearInterval(loadingInterval)
  loadingInterval = setInterval(() => {
    if (loadingProgress.value < 95) {
      loadingProgress.value += Math.random() * 5
    }
  }, 200)
  isProcessing.value = true
}

function stopLoading() {
  clearInterval(loadingInterval)
  // Smoothly fill to 100%
  loadingProgress.value = 100
  setTimeout(() => {
    isLoading.value = false
    isProcessing.value = false
    loadingProgress.value = 0
  }, 600) 
}

function startResendCooldown() {
  resendCooldown.value = 120
  clearInterval(resendTimer.value)
  resendTimer.value = setInterval(() => {
    resendCooldown.value--
    if (resendCooldown.value <= 0) clearInterval(resendTimer.value)
  }, 1000)
}

onMounted(() => {
  const stored = localStorage.getItem('lockout_expires_at')
  if (stored) lockoutCountdown(stored)
  if (siteKey && !window.grecaptcha) {
    const script = document.createElement('script')
    script.src = `https://www.google.com/recaptcha/api.js?render=${siteKey}`
    script.async = true
    script.defer = true
    document.head.appendChild(script)
  }
})

async function getRecaptchaToken(action = 'login') {
  if (!window.grecaptcha || !siteKey) return null
  await new Promise(resolve => window.grecaptcha.ready(resolve))
  return await window.grecaptcha.execute(siteKey, { action })
}

async function submit() {
  if (!form.Username || !form.Password) {
    document.getElementById('username').reportValidity()
    return
  }
  startLoading()
  try {
    const token = await getRecaptchaToken('login')
    const res = await axios.post('/custom-login', { ...form, recaptcha_token: token })

    if (res.data.require_otp) {
      Swal.fire('OTP Sent', 'A verification code was sent to your registered email.', 'info')
      step.value = 'otp'
      level.value = res.data.level
      otpContext.value = 'login'
      startResendCooldown()
    } else {
      Swal.fire({
        icon: 'success',
        title: 'Login Successful!',
        text: `Welcome, ${res.data.fullname || 'User'}!`,
        timer: 1800,
        showConfirmButton: false,
      }).then(() => window.location.href = res.data.redirect)
    }
  } catch (error) {
    const status = error.response?.status, data = error.response?.data
    if (status === 404 && data?.error === 'not_found')
      Swal.fire('User Not Found', 'No account with that Username.', 'error')
    else if (status === 401 && data?.error === 'wrong_password')
      Swal.fire('Incorrect Password', `Wrong password. ${data.attempts} attempt(s) remaining.`, 'error')
    else if (status === 429 && data?.error === 'locked') {
      if (data?.lockout_expires_at) {
        localStorage.setItem('lockout_expires_at', data.lockout_expires_at)
      }
      lockoutCountdown(data?.lockout_expires_at)
    }
    else if (data?.error === 'mail_failed')
      Swal.fire('Error', 'Failed to send OTP email. Please try again.', 'error')
    else Swal.fire('Login Failed', 'Something went wrong. Please try again.', 'error')
  } finally {
    stopLoading()
  }
}

async function handleForgotPassword() {
  if (!form.Username) { document.getElementById('username').reportValidity(); return }
  startLoading()
  try {
    const res = await axios.post('/check-user-email', { username: form.Username })
    if (!res.data.email) return Swal.fire('No email found', 'No email found for the inputted username.', 'error')
    partialEmail.value = res.data.partial
    level.value = res.data.level
    step.value = 'forgot'
  } catch {
    Swal.fire('Error', 'Something went wrong while fetching user email.', 'error')
  } finally {
    stopLoading()
  }
}

async function confirmEmail() {
  if (!confirmEmailInput.value.trim()) { document.querySelector('input[type="email"]').reportValidity(); return }
  startLoading()
  try {
    const res = await axios.post('/forgot-password', { email: confirmEmailInput.value, username: form.Username, level: level.value })
    if (res.data.success) {
      Swal.fire('Success', 'An OTP has been sent to your email.', 'success')
      step.value = 'otp'
      otpContext.value = 'forgot'
      startResendCooldown()
    } else Swal.fire('Error', res.data.message || 'Unable to send OTP.', 'error')
  } catch {
    Swal.fire('Error', 'Something went wrong while sending OTP.', 'error')
  } finally {
    stopLoading()
  }
}

async function resendOtp() {
  if (resendCooldown.value > 0) return
  startLoading()
  try {
    const res = await axios.post('/forgot-password', { email: confirmEmailInput.value, username: form.Username, level: level.value })
    if (res.data.success) {
      Swal.fire('OTP Sent', 'A new OTP has been sent to your email.', 'success')
      startResendCooldown()
    } else {
      Swal.fire('Error', res.data.message || 'Unable to resend OTP.', 'error')
    }
  } catch {
    Swal.fire('Error', 'Something went wrong while resending OTP.', 'error')
  } finally {
    stopLoading()
  }
}

async function verifyOtp() {
  startLoading()
  try {
    const res = await axios.post('/verify-otp', {
      otp: otp.value,
      username: form.Username,
      context: otpContext.value,
    })

    if (res.data.success) {
      if (res.data.context === 'forgot') {
        Swal.fire('Success', 'OTP verified. You may now reset your password.', 'success')
        resetToken.value = res.data.reset_token
        step.value = 'reset'
      } else {
        Swal.fire('Success', 'OTP verified. Logging in...', 'success')
        setTimeout(() => (window.location.href = res.data.redirect), 1000)
      }
    } else {
      Swal.fire('Invalid OTP', 'Please check your code and try again.', 'error')
    }
  } catch {
    Swal.fire('Error', 'OTP verification failed.', 'error')
  } finally {
    stopLoading()
  }
}

async function resetPassword() {
  if (newPassword.value.trim() === '' || confirmPassword.value.trim() === '')
    return Swal.fire('Error', 'Please fill out both password fields.', 'error')
  if (newPassword.value !== confirmPassword.value)
    return Swal.fire('Error', 'Passwords do not match.', 'error')

  startLoading()
  try {
    const res = await axios.post('/reset-password', {
      username: form.Username,
      token: resetToken.value,
      new_password: newPassword.value,
      new_password_confirmation: confirmPassword.value,
    })

    if (res.data.success) {
      Swal.fire('Success', 'Your password has been reset. Please log in.', 'success')
      step.value = 'login'
      newPassword.value = ''
      confirmPassword.value = ''
      otp.value = ''
      resetToken.value = ''
    } else {
      Swal.fire('Error', res.data.message || 'Password reset failed.', 'error')
    }
  } catch (error) {
    const msg = error.response?.data?.errors?.new_password?.[0] ||
                error.response?.data?.message ||
                'Something went wrong during reset.'
    Swal.fire('Error', msg, 'error')
  } finally {
    stopLoading()
  }
}

function lockoutCountdown(lockoutExpiresAt = null) {
  const stored = lockoutExpiresAt || localStorage.getItem('lockout_expires_at');
  if (!stored) return;

  const expireTime = new Date(stored);
  const now = new Date();
  let seconds = Math.floor((expireTime - now) / 1000);
  if (seconds <= 0) {
    localStorage.removeItem('lockout_expires_at');
    return;
  }

  Swal.fire({
    title: 'Too Many Attempts',
    html: `Try again in <b>${seconds}</b> seconds.`,
    allowOutsideClick: false,
    allowEscapeKey: false,
    showConfirmButton: false,
    didOpen: () => {
      const content = Swal.getHtmlContainer().querySelector('b');
      const timer = setInterval(() => {
        seconds--;
        content.textContent = seconds;
        if (seconds <= 0) {
          clearInterval(timer);
          localStorage.removeItem('lockout_expires_at');
          Swal.close();
        }
      }, 1000);
    },
  });
}

</script>

<style scoped>
@keyframes loading-line { 0% { width: 0%; } 100% { width: 100%; } }
.animate-loading-line { animation: loading-line 1.2s ease-in-out; }
</style>
