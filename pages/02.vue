<script setup>
const config = useRuntimeConfig();

import { NoToneMapping } from "three";

const ready = ref(false);
const assets = ref({});

// const meshes = {
//   diamond: config.public.base + "/models/diamond.glb",
// };
// const textures = {
//   1024: config.public.base + "/textures/001_1024.jpg",
// };
// const svgs = {
//   text: config.public.base + "/svgs/001-text.svg",
// };
// const hdr = config.public.base + "/textures/qwantani_dusk_2_1k.hdr";

onMounted(async () => {
  // assets.value.textures = await loadThreeTextures(textures);
  // assets.value.svgs = await loadThreeSVGs(svgs);
  // assets.value.meshes = await loadThreeMeshes(meshes);
  // assets.value.hdr = await loadThreeHDR(hdr);

  ready.value = true;
});
</script>

<template>
  <main>
    <TresCanvas
      v-if="ready"
      clear-color="#000000"
      window-size
      :toneMapping="NoToneMapping"
    >
      <Scene02 :assets="assets"></Scene02>
    </TresCanvas>
    <!-- <div id="overlay">
      <div class="scene-text" v-if="ready">
        <p>DIAMONDS ARE FOREVER LIKE</p>
        <p>OR REAL RAP SONGS LIKE C.R.E.A.M. OR MY MELODY</p>
      </div>
      <div class="scene-loading" v-else>
        <p>Loading...</p>
      </div>
    </div> -->
  </main>
</template>

<style scoped>
#overlay {
  @apply fixed top-0 left-0 w-full h-full;
  @apply p-4;
  @apply pointer-events-none touch-none select-none;
}
#overlay div {
  @apply w-full h-full;
  @apply flex flex-col items-center;
}

.scene-text {
  @apply justify-between;
}
.scene-loading {
  @apply justify-center;
}

p {
  @apply text-center font-bold leading-4;
}
</style>
