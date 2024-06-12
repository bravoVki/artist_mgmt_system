<template>
  <div class="flex justify-center items-center min-h-screen bg-gray-100">
    <div
      class="w-full max-w-md p-8 bg-white rounded-lg shadow dark:bg-gray-700"
    >
      <div class="text-center">
        <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white">
          LogIn
        </h1>
      </div>
      <form class="mt-8 space-y-6" @submit.prevent="login">
        <div class="space-y-6">
          <div>
            <label
              for="email"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Email</label
            >
            <input
              type="email"
              v-model="email"
              id="email"
              required
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="Email"
            />
          </div>
          <div>
            <label
              for="password"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Password</label
            >
            <input
              type="password"
              v-model="password"
              id="password"
              required
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="Password"
            />
          </div>
          <div class="text-center">
            <button
              type="submit"
              class="w-full px-6 py-2 text-white bg-indigo-600 hover:bg-indigo-700 focus:ring-4 focus:outline-none focus:ring-indigo-500 font-medium rounded-lg text-sm text-center dark:bg-indigo-700 dark:hover:bg-indigo-800 dark:focus:ring-indigo-900"
            >
              LogIn
            </button>
          </div>
          <p class="mt-4 text-center text-sm text-gray-600">
            Don't have an account?
            <router-link
              to="/register"
              class="font-medium text-indigo-600 hover:text-indigo-500"
              >Register</router-link
            >
          </p>
          <p v-if="error" class="mt-2 text-center text-sm text-red-600">
            {{ error }}
          </p>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toast-notification";
import "vue-toast-notification/dist/theme-sugar.css";
const $toast = useToast();
export default {
  data() {
    return {
      email: "",
      password: "",
      error: "",
    };
  },
  methods: {
    login() {
      axios
        .post("/api/auth/login", {
          email: this.email,
          password: this.password,
        })
        .then((response) => {
          localStorage.setItem("token", response.data.token);
          this.$toast.success("User LoggedIn", { position: "top" });

          this.$router.push("/dashboard");
        })
        .catch(() => {
          this.error = "Invalid email or password.";
        });
    },
  },
};
</script>

<style scoped>
/* Tailwind CSS classes are already in use, additional scoped styles can be added here if needed */
</style>
