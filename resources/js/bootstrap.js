import axios from 'axios';
window.axios = axios;

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

// 🔥 GLOBAL SESSION-EXPIRED HANDLER
axios.interceptors.response.use(
  response => response,
  error => {
    if (error.response) {
      // Session expired / unauthenticated
      if (error.response.status === 401) {
        window.location.href = '/login';
      }

      // Optional: forbidden
      if (error.response.status === 419) {
        window.location.reload();
      }
    }

    return Promise.reject(error);
  }
);
