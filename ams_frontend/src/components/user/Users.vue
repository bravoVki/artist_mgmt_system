<template>
  <div
    class="userViewTable text-black relative overflow-x-auto shadow-md sm:rouserlg"
  >
    <div class="border d">
      <div>
        <p>User List</p>
        <button
          @click="showAddUser"
          class="addUserBtn text-white bg-gradient-to-r from-cyan-400 via-cyan-500 to-cyan-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-cyan-300 dark:focus:ring-cyan-800 shadow-lg shadow-cyan-500/50 dark:shadow-lg dark:shadow-cyan-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-1 mb-3"
        >
          addUser
        </button>
      </div>
      <div class="noData" v-if="!users.length">
        <h3
          class="mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white"
        >
          No data to show, Add some
        </h3>
      </div>
      <div class="showData" v-else>
        <table
          class="w-full text-left rtl:text-right text-gray-500 dark:text-gray-400"
        >
          <thead
            class="text-s text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
          >
            <th class="border px-4 py-2">sn</th>
            <th class="border px-4 py-2">Name</th>
            <th class="border px-4 py-2">Email</th>
            <th class="border px-4 py-2">Phone</th>
            <th class="border px-4 py-2">Address</th>
            <th class="border px-4 py-2">Gender</th>
            <th class="border px-4 py-2">DoB</th>
            <th class="border px-4 py-2">action</th>
          </thead>
          <tbody>
            <tr
              class="odd:bg-white text-black odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700"
              v-for="(user, index) in usersWithFullName"
              :key="user.id"
            >
              <td class="border px-4 py-2">{{ index + 1 }}</td>
              <td class="border px-4 py-2">{{ user.fullName }}</td>
              <td class="border px-4 py-2">{{ user.email }}</td>
              <td class="border px-4 py-2">{{ user.phone }}</td>
              <td class="border px-4 py-2">{{ user.address }}</td>
              <td class="border px-4 py-2">{{ showGender(user.gender) }}</td>
              <!-- <td class="border px-4 py-2">{{  user.dob.split("T")[0] }}</td> -->
              <td class="border px-4 py-2">{{ datePublish(user.dob) }}</td>

              <td class="border px-4 py-4">
                <button
                  type="button"
                  class="text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 shadow-lg shadow-purple-500/50 dark:shadow-lg dark:shadow-purple-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                  @click="showEditUser(user)"
                >
                  Edit
                </button>
                <button
                  type="button"
                  class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 shadow-lg shadow-red-500/50 dark:shadow-lg dark:shadow-red-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                  @click="deleteUser(user.id)"
                >
                  Delete
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="meta.total_pages > 1" class="pagination">
        <button
          class="text-white bg-gradient-to-r from-teal-400 via-teal-500 to-teal-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-teal-300 dark:focus:ring-teal-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
          type="button"
          @click="fetchPage(meta.prev_page)"
          :disabled="!meta.prev_page"
        >
          Prev
        </button>
        <span id="paginationSpan"
          >Page {{ meta.current_page }}/{{ meta.total_pages }}</span
        >
        <button
          class="text-white bg-gradient-to-r from-teal-400 via-teal-500 to-teal-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-teal-300 dark:focus:ring-teal-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
          type="button"
          @click="fetchPage(meta.next_page)"
          :disabled="!meta.next_page"
        >
          Next
        </button>
      </div>
    </div>

    <!-- to delete user  -->
    <div
      v-if="deleteUserFlag"
      class="overflow-y-auto overflow-x-hidden fixed top-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div class="m-auto mr-30 relative p-5 w-full max-w-md max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <button
            type="button"
            class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
            data-modal-hide="popup-modal"
            @click="this.deleteUserFlag = false"
          >
            <svg
              class="w-3 h-3"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 14 14"
            >
              <path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
              />
            </svg>
            <span class="sr-only">Close modal</span>
          </button>
          <div class="p-4 md:p-5 text-center">
            <svg
              class="mx-auto mb-4 text-gray-400 w-12 h-12 dark:text-gray-200"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 20 20"
            >
              <path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M10 11V6m0 8h.01M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
              />
            </svg>
            <h3
              class="mb-5 text-lg font-normal text-gray-500 dark:text-gray-400"
            >
              Are you sure, you want to delete this user?
            </h3>
            <button
              data-modal-hide="popup-modal"
              type="button"
              class="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center"
              @click="confirmDelete"
            >
              Yes, I'm sure
            </button>
            <button
              data-modal-hide="popup-modal"
              type="button"
              class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
              @click="this.deleteUserFlag = false"
            >
              No, cancel
            </button>
          </div>
        </div>
      </div>
    </div>
    <!-- to edit or add user  -->
    <div
      id="user-modal"
      v-if="addUserFlag || editUserFlag"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div class="relative p-4 w-full max-w-md max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <div
            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
          >
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
              {{ editUserFlag ? "Edit User" : "Add User" }}
            </h3>
            <button
              type="button"
              class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              @click="closeModal"
            >
              <svg
                class="w-3 h-3"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 14"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
                />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <div class="p-4 md:p-5">
            <form
              @submit.prevent="editUserFlag ? updateUser() : addUser()"
              class="space-y-4"
            >
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
                  required
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
                  required
                />
              </div>
              <div>
                <label
                  for="email"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >Email</label
                >
                <input
                  type="text"
                  v-model="email"
                  id="email"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="Email"
                  :disabled="!addUserFlag"
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
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="password"
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
                  type="number"
                  v-model="phone"
                  id="phone"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="Phone"
                  required
                />
              </div>
              <div>
                <label
                  for="dob"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >DoB</label
                >
                <input
                  type="date"
                  v-model="dob"
                  id="dob"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="Date of Birth "
                  required
                />
              </div>

              <div>
                <label
                  for="gender"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Select Gender</label
                >
                <select
                  v-model="gender"
                  id="gender"
                  class="w-full px-3 py-2 border border-gray-300 text-gray-900 bg-gray-50 rounded-lg focus:outline-none focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  required
                >
                  <option value="m">Male</option>
                  <option value="f">Female</option>
                  <option value="o">Other</option>
                </select>
              </div>

              <div>
                <label
                  for="address"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Address</label
                >
                <input
                  type="text"
                  v-model="address"
                  id="address"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="Address"
                  required
                />
              </div>
              <button
                type="submit"
                class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
              >
                {{ editUserFlag ? "Update User" : "Add User" }}
              </button>
            </form>
          </div>
        </div>
      </div>
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
      users: [],
      meta: {},
      addUserFlag: false,
      editUserFlag: false,
      deleteUserFlag: false,
      selectedUserId: null,

      // for user add/edit form
      first_name: "",
      last_name: "",
      email: "",
      password: "",
      phone: "",
      dob: "",
      gender: "",
      address: "",
      error: "",
    };
  },
  computed: {
    usersWithFullName() {
      return this.users.map((user) => ({
        ...user,
        fullName: `${user.first_name} ${user.last_name}`,
      }));
    },
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    fetchUsers(page = 1) {
      const token = localStorage.getItem("token");
      if (!token) {
        this.$router.push("/login");
      } else {
        axios
          .get(`/api/users?page=${page}`, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          })
          .then((response) => {
            this.users = response.data.data;
            this.meta = response.data.meta;
          })
          .catch((error) => {
            console.error("There was an error!", error);
          });
      }
    },
    fetchPage(page) {
      if (page) {
        this.fetchUsers(page);
      }
    },
    showAddUser() {
      this.addUserFlag = true;
      this.editUserFlag = false;
    },
    showEditUser(user) {
      this.editUserFlag = true;
      this.addUserFlag = false;

      this.selectedUserId = user.id;

      this.first_name = user.first_name;
      this.last_name = user.last_name;
      this.email = user.email;
      this.phone = user.phone;
      this.dob = user.dob.split("T")[0]; // Formatting the date
      this.gender = user.gender; // Map gender value from API
      this.address = user.address;
      this.error = "";
    },
    // mapGenderToApi(apiGender) {
    //   const genderMap = {
    //     m: 0,
    //     f: 1,
    //     o: 2,
    //   };
    //   return genderMap[apiGender];
    // },

    addUser() {
      axios
        .post("/api/register", {
          user: {
            first_name: this.first_name,
            last_name: this.last_name,
            email: this.email,
            password: this.password,
            phone: this.phone,
            dob: this.dob,
            // gender: this.mapGenderToApi(this.gender), // Map gender value to API
            gender: this.gender,
            address: this.address,
          },
        })
        .then((response) => {
          if (response.data.status === "Success") {
            console.log("user added:", response.data);
            this.resetForm();
            this.addUserFlag = false;
            this.$toast.success("User Added Successfully !", {
              position: "top-right",
            });
            // Reload the page
            // window.location.reload();
            this.fetchUsers();
          } else {
            // console.log("User not registered:", response.data.message);

            this.$toast.error(`Email ${response.data.message.email}`, {
              position: "top-right",
            });
          }
        })
        .catch((error) => {
          this.error = error.response.data.errors;
          console.log(error);
        });
    },
    updateUser() {
      const token = localStorage.getItem("token");

      axios
        .put(
          `/api/users/${this.selectedUserId}`,
          {
            user: {
              first_name: this.first_name,
              last_name: this.last_name,
              email: this.email,
              phone: this.phone,
              dob: this.dob,
              // gender: this.mapGenderToApi(this.gender), // Map gender value to API
              gender: this.gender,
              address: this.address,
            },
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        )
        .then((response) => {
          // this.$toast.success(response.data.message);
          // console.log("User updated:", response.data);

          this.resetForm();
          this.editUserFlag = false;
          // window.location.reload();

          if (response.data.status === "success") {
            this.$toast.success("User Updated Successfully", {
              position: "top-right",
            });
          } else {
            this.$toast.error(`Phone ${response.data.error.phone}`, {
              position: "top-right",
            });
          }

          this.fetchUsers();
        })
        .catch((error) => {
          this.error = error.response.data.errors;
          console.log(error);
        });
    },

    deleteUser(userId) {
      // console.log("deleteuser", userId);
      this.selectedUserId = userId;
      this.deleteUserFlag = true;
      // console.log("deleteuser", this.deleteUserFlag);
    },
    confirmDelete() {
      const token = localStorage.getItem("token");

      axios
        .delete(`/api/users/${this.selectedUserId}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        })
        .then((response) => {
          //reload page
          // window.location.reload();
          this.deleteUserFlag = false;

          // console.log("user deleted:", response.data);
          if (response.data.message === "Admin") {
            this.$toast.error("Admin lai delete na garau", {
              position: "top-right",
            });
          } else {
            this.$toast.success("User Deleted", { position: "top-right" });
          }

          // window.location.reload();
          this.fetchUsers();
        })
        .catch((error) => {
          console.log(error);
          this.$toast.error("Admin lai delete na garau", {
            position: "top-right",
          });
        });
    },
    resetForm() {
      this.first_name = "";
      this.last_name = "";
      this.email = "";
      this.password = "";
      this.phone = "";
      this.dob = "";
      this.gender = "";
      this.address = "";
    },

    closeModal() {
      this.addUserFlag = false;
      this.editUserFlag = false;
      this.resetForm();
    },

    resetForm() {
      this.first_name = "";
      this.last_name = "";
      this.email = "";
      this.password = "";
      this.phone = "";
      this.dob = "";
      this.gender = "";
      this.address = "";
      this.error = "";
    },
    showGender(userGender) {
      if (userGender === "m") {
        return "Male";
      } else if (userGender === "f") {
        return "Female";
      } else {
        return "Other";
      }
    },
    datePublish(dob) {
      if (dob != null) {
        return dob.split("T")[0];
      } else {
        return "no dob";
      }
    },
  },
};
</script>
<style scoped>
.pagination {
  margin-top: 6px;
  /* padding: 2px; */
}
#paginationSpan {
  margin-right: 8px;
}
.userViewTable {
  position: relative;
}
.addUserBtn {
  position: absolute;
  top: 10px; /* Adjust as needed */
  right: 10px; /* Adjust as needed */
}
p {
  padding-top: 6px;
  padding-bottom: 10px;
  margin-bottom: 5px;
  font-size: 25px;
}
.pagination button {
  background-color: #007bff;
  padding: 10px 10px;
  border-radius: 5px;
  cursor: pointer;
}
.pagination button:disabled {
  cursor: not-allowed;
}
</style>
