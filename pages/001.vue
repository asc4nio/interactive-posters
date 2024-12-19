<script setup>
import { NoToneMapping } from "three";

const ready = ref(false);
const assets = ref({});

const meshes = {
  diamond: "/models/diamond.glb",
};
const textures = {
  1024: "/textures/001_1024.jpg",
};
const hdr = "/textures/qwantani_dusk_2_1k.hdr";

onMounted(async () => {
  assets.value.textures = await loadThreeTextures(textures);
  assets.value.meshes = await loadThreeMeshes(meshes);
  assets.value.hdr = await loadThreeHDR(hdr);

  ready.value = true;
});
</script>

<template>
  <div>
    <TresCanvas clear-color="#FFFFFF" window-size :toneMapping="NoToneMapping">
      <Scene001 v-if="ready" :assets="assets"></Scene001>
    </TresCanvas>
  </div>
</template>

<style></style>
