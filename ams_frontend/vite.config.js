import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      "/api": {
        target: "http://localhost:3000",
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path.replace(/^\/api/, ""),
        // rewrite: (path) => path.replace(/^\/api/, ""), this will convert all things anythingBefore/api to jocalhost....
      },
    },
  },
});
