<script setup>
const props = defineProps({
  assets: Object,
});
import { OrbitControls } from "@tresjs/cientos";
import { DoubleSide, EquirectangularReflectionMapping } from "three";

const { scene } = useTres();

props.assets.hdr.mapping = EquirectangularReflectionMapping;
scene.value.environment = props.assets.hdr;
</script>

<template>
  <TresPerspectiveCamera :position="[0, 0, 5]" :look-at="[0, 0, 0]">
    <TresMesh :position="[0, 0, -15]" :scale="10">
      <TresPlaneGeometry :args="[1, 1]" />
      <TresMeshBasicMaterial
        :map="props.assets.textures[1024]"
        :needsUpdate="true"
      />
    </TresMesh>
  </TresPerspectiveCamera>
  <OrbitControls />

  <TresMesh :geometry="props.assets.meshes.diamond.scene.children[0].geometry">
    <TresMeshPhysicalMaterial
      :color="0xffffff"
      :metalness="0"
      :roughness="0"
      :ior="2.4"
      :transmission="1"
      :specularIntensity="1"
      :specularColor="0xffffff"
      :opacity="1"
      :side="DoubleSide"
      :transparent="true"
      :thickness="2"
      :envMap="loadedHDR"
      :envMapIntensity="1"
      :reflectivity="1"
      :clearcoat="1"
      :clearcoatRoughness="0"
    />
  </TresMesh>

  <TresAmbientLight :intensity="1" />
  <TresDirectionalLight :position="[0, 0, 1]" :intensity="1000" />
</template>
