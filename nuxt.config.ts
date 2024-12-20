// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-11-01",
  devtools: { enabled: true },
  // ssr: false,
  app: {
    baseURL: '/interactive-posters/',
    cdnURL: 'https://asc4nio.github.io/interactive-posters/' //absolute URL to serve the public folder from (production-only).
  },
  modules: ["@tresjs/nuxt", "@nuxtjs/tailwindcss"],
  components: [
    {
      path: "~/components",
      pathPrefix: false,
    },
  ],
  tres: {
    devtools: true,
    glsl: true,
  },
});
