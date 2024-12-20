// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-11-01",
  devtools: { enabled: true },
  // ssr: false,
  runtimeConfig: {
    // The private keys which are only available within server-side
    // apiSecret: "", // can be overridden by NUXT_API_SECRET environment variable
    // Keys within public, will be also exposed to the client-side
    public: {
      base: "/interactive-posters/" , // can be overridden by NUXT_PUBLIC_BASE environment variable
      // base: process.env.NUXT_PUBLIC_BASE , // can be overridden by NUXT_PUBLIC_BASE environment variable
    },
  },
  app: {
    baseURL: "/interactive-posters/",
    // cdnURL: "https://asc4nio.github.io/interactive-posters/", //absolute URL to serve the public folder from (production-only).
  },
  // workspaceDir: '/interactive-posters/',
  // nitro: {
  //   baseURL: '/interactive-posters/',
  // },
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
