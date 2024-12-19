<script setup>
const props = defineProps({
  assets: Object,
});
import { OrbitControls } from "@tresjs/cientos";
import { DoubleSide, EquirectangularReflectionMapping } from "three";

const { fitSize } = useWindowSize();
const { scene } = useTres();

props.assets.hdr.mapping = EquirectangularReflectionMapping;
scene.value.environment = props.assets.hdr;
</script>

<template>
  <PixelPerspectiveCamera :perspective="0">
    <TresMesh :position="[0, 0, -fitSize]" :scale="fitSize * 1.2">
      <TresPlaneGeometry :args="[1, 1]" />
      <TresMeshBasicMaterial
        :map="props.assets.textures[1024]"
        :needsUpdate="true"
      />
    </TresMesh>

    <OrbitControls makeDefault />
  </PixelPerspectiveCamera>

  <TresGroup name="scene001" :scale="fitSize">
    <!-- PLANE -->
    <!-- <TresMesh :position="[0, 0, -2]" :scale="3.5">
      <TresPlaneGeometry :args="[1, 1]" />
      <TresMeshBasicMaterial
        :map="props.assets.textures[1024]"
        :needsUpdate="true"
      />
    </TresMesh> -->

    <!-- DIAMOND -->
    <TresMesh
      :scale="0.3"
      :geometry="props.assets.meshes.diamond.scene.children[0].geometry"
    >
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
        :envMap="assets.hdr"
        :envMapIntensity="1"
        :reflectivity="1"
        :clearcoat="1"
        :clearcoatRoughness="0"
      />
    </TresMesh>
  </TresGroup>
  <TresAmbientLight :intensity="1" />
  <TresDirectionalLight :position="[0, 0, 1]" :intensity="1000" />
</template>
