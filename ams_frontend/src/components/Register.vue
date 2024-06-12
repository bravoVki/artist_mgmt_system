<template>
  <div class="flex justify-center items-center min-h-screen bg-gray-100">
    <div
      class="w-full max-w-4xl p-8 bg-white rounded-lg shadow dark:bg-gray-700"
    >
      <div
        class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
      >
        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
          Register User
        </h3>
      </div>
      <form @submit.prevent="register" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label
              for="first_name"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >First Name</label
            >
            <input
              type="text"
              v-model="first_name"
              id="first_name"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="First Name"
            />
          </div>
          <div>
            <label
              for="last_name"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Last Name</label
            >
            <input
              type="text"
              v-model="last_name"
              id="last_name"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="Last Name"
            />
          </div>
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
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="Email"
              required
            />
          </div>
          <div v-if="!editUserFlag">
            <label
              for="password"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Password</label
            >
            <input
              type="password"
              v-model="password"
              id="password"
              minlength="6"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="Password"
              required
            />
          </div>
          <div>
            <label
              for="phone"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Phone Number</label
            >
            <input
              type="tel"
              minlength="6"
              maxlength="15"
              v-model="phone"
              id="phone"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="+977-98********"
              required
            />
          </div>
          <div>
            <label
              for="dob"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Date of Birth</label
            >
            <input
              type="date"
              min="1960-04-01"
              max="2024-06-12"
              v-model="dob"
              id="dob"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
            />
          </div>
          <div>
            <label
              for="gender"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Gender</label
            >
            <select
              v-model="gender"
              id="gender"
              class="w-full px-3 py-2 border border-gray-300 text-gray-900 bg-gray-50 rounded-lg focus:outline-none focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
            >
              <option value="0">Male</option>
              <option value="1">Female</option>
              <option value="2">Other</option>
            </select>
          </div>
          <div class="md:col-span-2">
            <label
              for="address"
              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
              >Address</label
            >
            <input
              type="text"
              v-model="address"
              id="address"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
              placeholder="Address"
            />
          </div>
        </div>
        <div class="text-center">
          <button
            type="submit"
            class="w-full md:w-auto px-6 py-2 text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
          >
            Register
          </button>
        </div>
      </form>
      <p class="mt-4 text-center text-sm text-gray-600">
        Already have an account?
        <router-link
          to="/login"
          class="font-medium text-indigo-600 hover:text-indigo-500"
          >Login</router-link
        >
      </p>
      <p v-if="error" class="mt-2 text-center text-sm text-red-600">
        {{ error }}
      </p>
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
      first_name: "",
      last_name: "",
      email: "",
      password: "",
      phone: "",
      dob: "",
      gender: "",
      address: "",
      error: "",
      editUserFlag: false,
    };
  },
  methods: {
    register() {
      axios
        .post("/api/register", {
          user: {
            first_name: this.first_name,
            last_name: this.last_name,
            email: this.email,
            password: this.password,
            phone: this.phone,
            dob: this.dob,
            gender: Number(this.gender),
            address: this.address,
          },
        })
        .then((response) => {
          if (response.data.status === "Success") {
            // console.log("User registered:", this.response.data.message);
            this.$toast.success("User Created", { position: "top-right" });
            this.$router.push("/login");
          } else {
            // console.log("User not registered:", response.data.message);
            if (response.data.message.email) {
              this.$toast.error(`Email ${response.data.message.email}`, {
                position: "top",
              });
            } else {
              this.$toast.error(`Phone ${response.data.message.phone}`, {
                position: "top",
              });
            }
          }
        })
        .catch((error) => {
          // this.error = error.response.data.errors.join(", ");
          console.log(error);
          this.$toast.error("User not Created", { position: "top" });
        });
    },
  },
};
</script>

<style scoped>
/* Tailwind CSS classes are already in use, additional scoped styles can be added here if needed */
</style>
