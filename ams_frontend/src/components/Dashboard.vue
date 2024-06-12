<template>
  <div class="flex h-screen font-sans bg-gray-100">
    <aside class="w-64 bg-gray-800 text-white flex flex-col">
      <div class="p-6 text-center font-bold text-xl border-b border-gray-700">
        Admin Dashboard
      </div>
      <nav class="flex-1 mt-8">
        <ul>
          <li class="mb-2">
            <router-link
              to="/dashboard/artists"
              class="block py-2 px-4 text-white rounded hover:bg-gray-700"
            >
              <i class="fas fa-user-tie mr-2"></i> Artists
            </router-link>
          </li>
          <li class="mb-2">
            <router-link
              to="/dashboard/users"
              class="block py-2 px-4 text-white rounded hover:bg-gray-700"
            >
              <i class="fas fa-users mr-2"></i> Users
            </router-link>
          </li>
        </ul>
      </nav>
      <button
        @click="logout"
        class="m-6 py-2 px-4 bg-red-600 rounded hover:bg-red-700"
      >
        Logout
      </button>
    </aside>
    <main class="flex-1 p-10 overflow-y-auto">
      <div class="text-2xl font-semibold mb-4">
        Welcome to Artist Management System
      </div>
      <router-view />
    </main>
  </div>
</template>

<script>
export default {
  name: "Dashboard",
  data() {
    return {
      songs: [],
    };
  },
  mounted() {
    const token = localStorage.getItem("token");
    if (!token) {
      this.$router.push("/login");
    }
  },
  methods: {
    logout() {
      localStorage.removeItem("token");
      this.$router.push("/login");
    },
  },
};
</script>

<style scoped></style>
