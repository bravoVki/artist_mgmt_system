<template>
  <div class="expImp">
    <button
      @click="exportSongs"
      class="exportBtn text-white bg-gradient-to-r from-purple-400 via-red-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 shadow-lg shadow-green-500/50 dark:shadow-lg dark:shadow-green-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-1 mb-3"
    >
      ExportToCSV
    </button>
    <button
      @click="
        {
          {
            this.importFlag
              ? (this.importFlag = flase)
              : (this.importFlag = true);
          }
        }
      "
      class="exportBtn text-white bg-gradient-to-r from-cyan-400 via-cyan-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 shadow-lg shadow-green-500/50 dark:shadow-lg dark:shadow-green-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-1 mb-3"
    >
      Import CSV
    </button>
    <!-- <input
      type="file"
      @change="handleFileUpload"
      class="fileInput"
      accept=".csv"
    /> -->
    <div class="uploadCsv" v-if="importFlag">
      <label
        class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
        for="file_input"
        >Upload file</label
      >
      <input
        class="block w-full text-sm text-gray-1500 border border-gray-500 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
        id="file_input"
        type="file"
        @change="handleFileUpload"
        accept=".csv"
      />
    </div>
  </div>

  <div>
    <div
      class="userViewtable text-black relative overflow-x-auto shadow-md sm:rounded-lg"
    >
      <div class="border d">
        <div>
          <p>Songs List</p>

          <button
            @click="showAddSong"
            class="addSongBtn text-white bg-gradient-to-r from-cyan-400 via-cyan-500 to-cyan-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-cyan-300 dark:focus:ring-cyan-800 shadow-lg shadow-cyan-500/50 dark:shadow-lg dark:shadow-cyan-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-1 mb-3"
          >
            Add Song
          </button>
        </div>
        <div class="no" v-if="!songs.length">
          <h3
            class="mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white"
          >
            No data to show, Add some
          </h3>
        </div>
        <div class="showD" v-else>
          <table
            class="w-full text-left rtl:text-right text-gray-500 dark:text-gray-400"
          >
            <thead
              class="text-s text-black uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
            >
              <tr>
                <th class="border px-4 py-2">SN</th>
                <th class="border px-4 py-2">Song Title</th>
                <th class="border px-4 py-2">Album Name</th>
                <th class="border px-4 py-2">Genere</th>
                <th class="border px-4 py-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr
                class="text-black odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700"
                v-for="(song, index) in songs"
                :key="song.id"
              >
                <td class="border px-4 py-2">{{ index + 1 }}</td>
                <td class="border px-4 py-2">{{ song.title }}</td>
                <td class="border px-4 py-2">{{ song.album_name }}</td>
                <td class="border px-4 py-2">{{ song.genere }}</td>
                <td class="border px-4 py-2">
                  <button
                    type="button"
                    class="text-white bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-purple-300 dark:focus:ring-purple-800 shadow-lg shadow-purple-500/50 dark:shadow-lg dark:shadow-purple-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                    @click="showEditSong(song)"
                  >
                    Edit
                  </button>
                  <button
                    type="button"
                    class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 shadow-lg shadow-red-500/50 dark:shadow-lg dark:shadow-red-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                    @click="deleteSong(song.id)"
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
      <div
        v-if="deleteSongFlag"
        class="overflow-y-auto overflow-x-hidden fixed top-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
      >
        <div class="relative mx-auto p-4 w-full max-w-md max-h-full">
          <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
            <button
              type="button"
              class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="popup-modal"
              @click="this.deleteSongFlag = false"
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
                Are you sure, you want to delete this song?
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
                @click="this.deleteSongFlag = false"
              >
                No, cancel
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Add/Edit Song Modal -->
      <div
        id="artist-modal"
        v-if="addSongFlag || editSongFlag"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
      >
        <div class="relative p-4 w-full max-w-md max-h-full">
          <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
            <div
              class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
            >
              <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                {{ editSongFlag ? "Edit Song" : "Add Song" }}
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
                @submit.prevent="editSongFlag ? updateSong() : addSong()"
                class="space-y-4"
              >
                <div>
                  <label
                    for="title"
                    class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                    >Song Name</label
                  >
                  <input
                    type="text"
                    v-model="title"
                    id="title"
                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                    placeholder="Song Name"
                    required
                  />
                </div>
                <div>
                  <label
                    for="genere"
                    class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                    >Select Genere</label
                  >
                  <select
                    v-model="genere"
                    id="genere"
                    class="w-full px-3 py-2 border border-gray-300 text-gray-900 bg-gray-50 rounded-lg focus:outline-none focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                    required
                  >
                    <option value="0">Rock</option>
                    <option value="1">Jazz</option>
                    <option value="2">Classic</option>
                    <option value="3">RNB</option>
                    <option value="4">Country</option>
                  </select>
                </div>
                <div>
                  <label
                    for="album_name"
                    class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                    >Album Name</label
                  >
                  <input
                    type="text"
                    v-model="album_name"
                    id="album_name"
                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                    placeholder="Album_name"
                    required
                  />
                </div>
                <button
                  type="submit"
                  class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                >
                  {{ editSongFlag ? "Update Song" : "Add Song" }}
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div></div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toast-notification";
import "vue-toast-notification/dist/theme-sugar.css";

const $toast = useToast();
export default {
  data() {
    return {
      songs: [],
      meta: {},
      artistId: this.$route.params.id,
      addSongFlag: false,
      editSongFlag: false,
      deleteSongFlag: false,
      selectedSongId: null,
      title: "",
      album_name: "",
      genere: "",
      importFlag: false,
    };
  },
  mounted() {
    this.fetchSongs();
  },
  methods: {
    fetchSongs(page = 1) {
      const token = localStorage.getItem("token");
      axios
        .get(`/api/artists/${this.artistId}/songs?page=${page}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        })
        .then((response) => {
          this.songs = response.data.data;
          this.meta = response.data.meta;
        })
        .catch((error) => {
          console.log(error);
        });
    },
    fetchPage(page) {
      if (page) {
        this.fetchSongs(page);
      }
    },
    closeModal() {
      this.addSongFlag = false;
      this.editSongFlag = false;
      this.resetForm();
    },
    resetForm() {
      this.title = "";
      this.genere = "";
      this.album_name = "";
    },
    showAddSong() {
      this.addSongFlag = true;
      this.editSongFlag = false;
    },
    showEditSong(song) {
      this.editSongFlag = true;
      this.addSongFlag = false;
      this.selectedSongId = song.id;
      this.title = song.title;
      this.genere = song.genere;
      this.album_name = song.album_name;
    },
    addSong() {
      const token = localStorage.getItem("token");
      axios
        .post(
          `/api/artists/${this.artistId}/songs`,
          {
            artist_id: this.artistId,
            title: this.title,
            album_name: this.album_name,
            genere: Number(this.genere),
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        )
        .then((response) => {
          // this.songs.push(response.data.data);
          this.$toast.success("Song Added!", { position: "top-right" });
          this.resetForm();
          this.closeModal();
          this.fetchSongs();
        })
        .catch((error) => {
          console.error("There was an error!", error);
        });
    },
    updateSong() {
      const token = localStorage.getItem("token");
      axios
        .put(
          `/api/artists/${this.artistId}/songs/${this.selectedSongId}`,
          {
            song: {
              title: this.title,
              album_name: this.album_name,
              genere: Number(this.genere),
            },
          },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        )
        .then((response) => {
          this.$toast.success("song updated !", { position: "top-right" });
          this.editSongFlag = false;
          this.resetForm();
          this.fetchSongs();
        })
        .catch((error) => {
          console.error("There was an error!", error);
        });
    },

    deleteSong(songId) {
      this.selectedSongId = songId;
      this.deleteSongFlag = true;
    },

    confirmDelete() {
      const token = localStorage.getItem("token");
      axios
        .delete(`/api/artists/${this.artistId}/songs/${this.selectedSongId}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        })
        .then((response) => {
          this.$toast.success("Song Deleted!", { position: "top-right" });
          this.fetchSongs();
          this.deleteSongFlag = false;
          console.log(response.data.message);
        })
        .catch((error) => {
          console.error("There was an error!", error);
        });
    },
    exportSongs() {
      const token = localStorage.getItem("token");
      axios
        .get(`/api/artists/${this.artistId}/songs/export`, {
          headers: {
            Authorization: `Bearer ${token}`,
            Accept: "text/csv", // This line is added
          },
          responseType: "blob",
        })
        .then((response) => {
          const url = window.URL.createObjectURL(new Blob([response.data]));
          const link = document.createElement("a");
          link.href = url;
          link.setAttribute(
            "download",
            `songs-${this.artistId}-${new Date()
              .toISOString()
              .slice(0, 10)}.csv`
          );
          document.body.appendChild(link);
          link.click();
        })
        .catch((error) => {
          console.log(error);
        });
    },
    // ##########]]]222222222222222222222222222222222222222222222
    handleFileUpload(event) {
      const file = event.target.files[0];
      console.log("File selected for upload:", file);
      if (file) {
        this.uploadCSV(file);
      } else {
        console.error("No file selected");
      }
    },
    uploadCSV(file) {
      const token = localStorage.getItem("token");
      console.log("Selected file: ", file);
      const formData = new FormData();
      console.log(formData);
      formData.append("file", file);
      console.log("Uploading CSV file...");

      axios
        .post(`/api/artists/${this.artistId}/songs/upload`, formData, {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "multipart/form-data",
          },
        })
        .then((response) => {
          console.log("Upload response: ", response.data);
          this.$toast.success("CSV uploaded successfully!", {
            position: "top-right",
          });
          this.importFlag = false;
          this.fetchSongs(); // Refresh the song list
        })
        .catch((error) => {
          console.error("Error uploading CSV file: ", error);
          this.$toast.error("Failed to upload CSV file.", {
            position: "top-right",
          });
        });
    },
  },
};
</script>

<style scoped>
.pagination {
  margin-top: 6px;
  /* padding: 2px; */
}
/* .pagination {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  margin: 10px 0;
} */

#paginationSpan {
  margin-right: 8px;
}
.addSongBtn {
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
  /* background-color: #007bff; */
  padding: 10px 10px;
  border-radius: 5px;
  cursor: pointer;
}
.pagination button:disabled {
  cursor: not-allowed;
}
.expImp {
  position: relative;
  display: flex;
  flex-direction: ro-reverse;
  /* margin-right: -800px; */
}
.uploadCsv {
  margin-bottom: 3px;
}
</style>
