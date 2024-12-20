<script lang="ts" setup>
if (import.meta.server) {
  console.log("import.meta.server");
} else if (import.meta.client) {
  console.log("import.meta.client");
} else if (import.meta.browser) {
  console.log("import.meta.browser");
} else if (import.meta.dev) {
  console.log("import.meta.dev");
} else if (import.meta.test) {
  console.log("import.meta.test");
} else if (import.meta.prerender) {
  console.log("import.meta.prerender");
}
</script>

<template>
  <div>
    {{ $config.public.base || "no value" }}
    <h1 class="text-3xl">Home</h1>
    <RouterLink to="/001" class="underline">Go to 001</RouterLink>
  </div>
</template>

<style scoped></style>
