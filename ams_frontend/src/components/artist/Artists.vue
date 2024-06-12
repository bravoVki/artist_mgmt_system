<template>
  <div
    class="artistViewTable text-black relative overflow-x-auto shadow-md sm:rounded-lg"
  >
    <div class="border d">
      <div>
        <p>Artist List</p>

        <button
          @click="showAddArtist"
          class="addArtistBtn text-white bg-gradient-to-r from-cyan-400 via-cyan-500 to-cyan-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-cyan-300 dark:focus:ring-cyan-800 shadow-lg shadow-cyan-500/50 dark:shadow-lg dark:shadow-cyan-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-1 mb-3"
        >
          addArtist
        </button>
      </div>
      <div class="noData" v-if="!artists.length">
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
            <tr>
              <th class="border px-4 py-2">sn</th>
              <th class="border px-4 py-2">Name</th>
              <th class="border px-4 py-2">Gender</th>
              <th class="border px-4 py-2">Address</th>
              <th class="border px-4 py-2">DoB</th>
              <th class="border px-4 py-2">First Release Year</th>
              <th class="border px-4 py-2">No of Albums</th>
              <th class="border px-4 py-2">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr
              class="odd:bg-white text-black odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700"
              v-for="(artist, index) in artists"
              :key="artist.id"
            >
              <td class="border px-4 py-2">{{ index + 1 }}</td>
              <td class="border px-4 py-2">{{ artist.name }}</td>
              <td class="border px-4 py-2">{{ showGender(artist.gender) }}</td>
              <td class="border px-4 py-2">{{ artist.address }}</td>
              <td class="border px-4 py-2">{{ artist.dob.split("T")[0] }}</td>
              <td class="border px-4 py-2">{{ artist.first_release_year }}</td>
              <td class="border px-4 py-2">
                {{ artist.no_of_albums_released }}
              </td>
              <td class="border px-4 py-2">
                <button
                  type="button"
                  class="text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 shadow-lg shadow-purple-500/50 dark:shadow-lg dark:shadow-purple-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                  @click="showEditArtist(artist)"
                >
                  Edit
                </button>

                <button
                  type="button"
                  class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 shadow-lg shadow-red-500/50 dark:shadow-lg dark:shadow-red-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                  @click="deleteArtist(artist.id)"
                >
                  Delete
                </button>

                <router-link
                  :to="{
                    name: 'artist-songs',
                    params: { id: artist.id }, //routes ma id pathako uta routes ma params:true garera ani yata params pathaune
                  }"
                >
                  <button
                    type="button"
                    class="text-white bg-gradient-to-r from-green-400 via-green-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 shadow-lg shadow-green-500/50 dark:shadow-lg dark:shadow-green-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-3 mb-1"
                  >
                    View Songs
                  </button>
                </router-link>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- div for pagination  -->
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
      v-if="deleteArtistFlag"
      class="overflow-y-auto overflow-x-hidden fixed top-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div class="relative mx-auto p-4 w-full max-w-md max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <button
            type="button"
            class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
            data-modal-hide="popup-modal"
            @click="this.deleteArtistFlag = false"
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
              @click="this.deleteArtistFlag = false"
            >
              No, cancel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Add/Edit Artist Modal -->
    <div
      id="artist-modal"
      v-if="addArtistFlag || editArtistFlag"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div class="relative p-4 w-full max-w-md max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <div
            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
          >
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
              {{ editArtistFlag ? "Edit Artist" : "Add Artist" }}
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
              @submit.prevent="editArtistFlag ? updateArtist() : addArtist()"
              class="space-y-4"
            >
              <div>
                <label
                  for="name"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >Name</label
                >
                <input
                  type="text"
                  v-model="name"
                  id="name"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="Artist Name"
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
                  >Address</label
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
              <div>
                <label
                  for="dob"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >Date of Birth</label
                >
                <input
                  type="date"
                  v-model="dob"
                  id="dob"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  required
                />
              </div>
              <div>
                <label
                  for="first_release_year"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >First Release Year</label
                >
                <select
                  v-model="first_release_year"
                  id="first_release_year"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  required
                >
                  <option disabled value="">Select Year</option>
                  <option v-for="year in getYears()" :key="year" :value="year">
                    {{ year }}
                  </option>
                </select>
              </div>
              <div>
                <label
                  for="no_of_albums_released"
                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >No of Albums Released</label
                >
                <input
                  type="number"
                  v-model="no_of_albums_released"
                  id="no_of_albums_released"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="No of Albums Released"
                  required
                />
              </div>
              <button
                type="submit"
                class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
              >
                {{ editArtistFlag ? "Update Artist" : "Add Artist" }}
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
import ArtistSongs from "../songs/ArtistSongs.vue";

const $toast = useToast();
export default {
  // props:{
  // artist:{
  //   type:
  //   required:
  // }

  data() {
    return {
      artists: [],
      meta: {},
      addArtistFlag: false,
      editArtistFlag: false,
      deleteArtistFlag: false,
      selectedArtistId: null,
      name: "",
      gender: "",
      address: "",
      dob: "",
      first_release_year: "",
      no_of_albums_released: "",
    };
  },
  mounted() {
    this.fetchArtists();
  },
  methods: {
    fetchArtists(page = 1) {
      const token = localStorage.getItem("token");
      axios
        .get(`/api/artists?page=${page}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        })
        .then((response) => {
          this.artists = response.data.data;
          this.meta = response.data.meta;
        })
        .catch((error) => {
          console.error("There was an error!", error);
        });
    },
    fetchPage(page) {
      if (page) {
        this.fetchArtists(page);
      }
    },
    showAddArtist() {
      this.addArtistFlag = true;
      this.editArtistFlag = false;
      // this.resetForm();
    },
    showEditArtist(artist) {
      this.editArtistFlag = true;
      this.addArtistFlag = false;
      this.selectedArtistId = artist.id;
      this.name = artist.name;
      this.gender = artist.gender;
      this.address = artist.address;
      this.dob = artist.dob.split("T")[0];
      this.first_release_year = artist.first_release_year;
      this.no_of_albums_released = artist.no_of_albums_released;
    },
    closeModal() {
      this.addArtistFlag = false;
      this.editArtistFlag = false;
      this.resetForm();
    },
    resetForm() {
      this.name = "";
      this.gender = "m";
      this.address = "";
      this.dob = "";
      this.first_release_year = "";
      this.no_of_albums_released = "";
    },

    addArtist() {
      const token = localStorage.getItem("token");
      axios
        .post(
          "/api/artists",
          {
            name: this.name,
            gender: this.gender,
            address: this.address,
            dob: this.dob,
            first_release_year: this.first_release_year,
            no_of_albums_released: this.no_of_albums_released,
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        )
        .then((response) => {
          // this.artists.push(response.data);
          this.closeModal();
          this.$toast.success("Artist added successfully !", {
            position: "top-right",
          });
          this.fetchArtists();
        })
        .catch((error) => {
          this.$toast.error("Artist not added  !", { position: "top-right" });
          console.error("There was an error!", error);
        });
    },
    updateArtist() {
      // Update logic here
      const token = localStorage.getItem("token");
      axios
        .put(
          `/api/artists/${this.selectedArtistId}`,
          {
            artist: {
              name: this.name,
              gender: this.gender,
              dob: this.dob,
              first_release_year: this.first_release_year,
              no_of_albums_released: this.no_of_albums_released,
            },
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        )
        .then((response) => {
          console.log("User updated:", response.data);
          this.closeModal();
          // window.location.reload();
          this.$toast.success("Artist Updated !", { position: "top" });
          this.fetchArtists();
        })
        .catch((error) => {
          console.log(error);
        });
    },
    deleteArtist(artistId) {
      this.selectedArtistId = artistId;
      this.deleteArtistFlag = true;
    },

    confirmDelete() {
      const token = localStorage.getItem("token");
      axios
        .delete(`/api/artists/${this.selectedArtistId}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        })
        .then((response) => {
          // this.artists = this.artists.filter(
          //   (artist) => artist.id !== artistId
          // );vayeko array bata nikal dine ho
          // this.artists.push(response.data);
          // response ma aako array set garne ho
          window.location.reload();

          this.deleteArtistFlag = false;
          // this.$toast.success("Artist Deleted Successfylly !");
          // this.fetchArtists();
        })
        .catch((error) => {
          console.error("There was an error!", error);
        });
    },

    getYears() {
      const currentYear = new Date().getFullYear();
      const startYear = 1900; // or any starting year you prefer
      let years = [];
      for (let year = currentYear; year >= startYear; year--) {
        years.push(year);
      }
      return years;
    },
    showGender(artistGender) {
      if (artistGender === "m") {
        return "Male";
      } else if (artistGender === "f") {
        return "Female";
      } else {
        return "Other";
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
/* Add any custom styles here */
.artistViewTable {
  position: relative;
}

.addArtistBtn {
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
/* .pagination {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  margin: 10px 0;
}
  */
.pagination button {
  background-color: #007bff;
  padding: 10px 10px;
  border-radius: 5px;
  cursor: pointer;
}
.pagination button:disabled {
  cursor: not-allowed;
}
#paginationSpan {
  margin-right: 8px;
}
</style>
