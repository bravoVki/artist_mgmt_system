import { createRouter, createWebHistory } from "vue-router";
import Login from "../components/Login.vue";
import Register from "../components/Register.vue";
import Artists from "../components/artist/Artists.vue";
import ArtistSongs from "../components/songs/ArtistSongs.vue";

import Dashboard from "../components/Dashboard.vue";
import Users from "../components/user/Users.vue";

const routes = [
  { path: "/login", component: Login, meta: { guest: true } },
  { path: "/register", component: Register, meta: { guest: true } },
  {
    path: "/dashboard",
    component: Dashboard,
    redirect: "/dashboard/users",
    name: "dashboard",
    meta: { requiresAuth: true },
    children: [
      {
        path: "artists",
        component: Artists,
        meta: { requiresAuth: true },
      },

      { path: "users", component: Users, meta: { requiresAuth: true } },
      {
        path: "artists/:id/songs",
        name: "artist-songs",
        props: true,
        component: ArtistSongs,
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/:pathMatch(.*)*",
    redirect: "/login",
    meta: { guest: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// if already looged in then direct to dashboar page
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem("token");
  if (to.matched.some((record) => record.meta.requiresAuth) && !token) {
    next({ path: "/login" });
  } else if (to.matched.some((record) => record.meta.guest) && token) {
    next({ path: "/dashboard" });
  } else {
    next();
  }
});

export default router;
