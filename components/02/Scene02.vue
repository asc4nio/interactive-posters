<script setup>
// https://github.com/mrdoob/three.js/blob/master/examples/webgl_volume_cloud.html

const props = defineProps({
  assets: Object,
});

// console.warn(props.assets);

import { OrbitControls } from "@tresjs/cientos";

import {
  Vector3,
  Color,
  MathUtils,
  BackSide,
  Data3DTexture,
  RedFormat,
  LinearFilter,
  GLSL3,
} from "three";

import { ImprovedNoise } from "three/addons/math/ImprovedNoise.js";
import { Sky } from "three/addons/objects/Sky.js";

import vertexShader from "./cloudVertex.glsl";
import fragmentShader from "./cloudFragment.glsl";

const { fitSize, width, height } = useWindowSize();
const { scene, camera, renderer } = useTres();
const { onBeforeRender, render } = useLoop();

const sky = new Sky();
const cloudRef = shallowRef();

sky.scale.setScalar(450000);
const phi = MathUtils.degToRad(90);
const theta = MathUtils.degToRad(180);
const sunPosition = new Vector3().setFromSphericalCoords(
  1,
  phi * -0.75,
  theta * 1
);
sky.material.uniforms.sunPosition.value = sunPosition;
// scene.add(sky);

const size = 128;
const data = new Uint8Array(size * size * size);

let i = 0;
const scale = 0.05;
const perlin = new ImprovedNoise();
const vector = new Vector3();

for (let z = 0; z < size; z++) {
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const d =
        1.0 -
        vector
          .set(x, y, z)
          .subScalar(size / 2)
          .divideScalar(size)
          .length();
      data[i] =
        (128 +
          128 * perlin.noise((x * scale) / 1.5, y * scale, (z * scale) / 1.5)) *
        d *
        d;
      i++;
    }
  }
}

const texture = new Data3DTexture(data, size, size, size);
texture.format = RedFormat;
texture.minFilter = LinearFilter;
texture.magFilter = LinearFilter;
texture.unpackAlignment = 1;
texture.needsUpdate = true;

const uniforms = {
  // base: { value: new Color(0xccf7ff) },
  base: { value: new Color(0xb9e4ff) },
  map: { value: texture },
  cameraPos: { value: new Vector3() },
  threshold: { value: 0.25 },
  opacity: { value: 0.25 },
  range: { value: 0.1 },
  steps: { value: 100 },
  frame: { value: 0 },
};

onBeforeRender(({ delta, elapsed }) => {
  uniforms.cameraPos.value.copy(camera.value.position);
  uniforms.frame.value++;
  // if (cloudRef.value) {
  //   cloudRef.value.rotation.x -= delta * 0.05;
  // }
});

// render(({ renderer, scene, camera }) => {
//   composer.render();
// });

onMounted(() => {});

// onUnmounted(() => {
//   canvas.removeEventListener("pointermove", onPointerMove, false);
//   canvas.removeEventListener("pointerdown", onPointerDown, false);
//   canvas.removeEventListener("pointerup", onPointerUp, false);
// });
</script>

<template>
  <PixelPerspectiveCamera :perspective="0">
    <OrbitControls makeDefault />

    <TresMesh :position="[0, 0, -4 * fitSize]" :scale="1.5 * fitSize">
      <TresSphereGeometry :args="[0.75, 16, 32]" />
      <TresMeshStandardMaterial />
    </TresMesh>
  </PixelPerspectiveCamera>

  <primitive :object="sky" />

  <TresGroup name="scene001" :scale="fitSize">
    <!-- CLOUD -->
    <TresMesh ref="cloudRef" :position="[0, -0.5, 0]" :scale="1.5">
      <TresBoxGeometry :args="[1, 1, 1]" />
      <TresRawShaderMaterial
        :glslVersion="GLSL3"
        :uniforms="uniforms"
        :vertexShader="vertexShader"
        :fragmentShader="fragmentShader"
        :side="BackSide"
        :transparent="true"
      />
    </TresMesh>
  </TresGroup>

  <TresAmbientLight :intensity="1" />
  <TresDirectionalLight :position="[1, 1, 1]" :intensity="1" />
</template>
