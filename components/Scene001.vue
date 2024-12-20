<script setup>
const props = defineProps({
  assets: Object,
});

// console.warn(props.assets);

// import { OrbitControls } from "@tresjs/cientos";
import { DoubleSide, EquirectangularReflectionMapping, Vector2 } from "three";
import { Group, MeshBasicMaterial, ShapeGeometry, Mesh } from "three";

import { SVGLoader } from "three/addons/loaders/SVGLoader.js";

import { EffectComposer } from "three/addons/postprocessing/EffectComposer.js";
import { RenderPass } from "three/addons/postprocessing/RenderPass.js";
import { UnrealBloomPass } from "three/addons/postprocessing/UnrealBloomPass.js";
import { OutputPass } from "three/addons/postprocessing/OutputPass.js";

const { fitSize, width, height } = useWindowSize();
const { scene, camera, renderer } = useTres();
const { onBeforeRender, render } = useLoop();

props.assets.hdr.mapping = EquirectangularReflectionMapping;
scene.value.environment = props.assets.hdr;

const diamondRef = shallowRef();
const textMesh = createSvgMesh(props.assets.svgs.text);

let renderScene, bloomPass, outputPass, composer;

function createSvgMesh(data) {
  const paths = data.paths;
  const group = new Group();
  for (let i = 0; i < paths.length; i++) {
    const path = paths[i];
    const material = new MeshBasicMaterial({
      color: path.color,
      side: DoubleSide,
      depthWrite: false,
    });
    const shapes = SVGLoader.createShapes(path);
    for (let j = 0; j < shapes.length; j++) {
      const shape = shapes[j];
      const geometry = new ShapeGeometry(shape);
      const mesh = new Mesh(geometry, material);
      group.add(mesh);
    }
  }

  return group;
}

const pointer = ref({
  isDown: false,
  x: 0,
  y: 0,
});

const canvas = renderer.value.domElement;

const onPointerMove = (e) => {
  if (!pointer.value.isDown) {
    return;
  }
  //console.log('drag')
  e.preventDefault();
  var deltaX = e.clientX - pointer.value.x,
    deltaY = e.clientY - pointer.value.y;
  pointer.value.x = e.clientX;
  pointer.value.y = e.clientY;

  // DO SOMETHING HERE WITH X and Y
  diamondRef.value.rotation.x += deltaY * 0.01;
  diamondRef.value.rotation.y += deltaX * 0.01;
};
const onPointerDown = (e) => {
  e.preventDefault();
  pointer.value.isDown = true;
  pointer.value.x = e.clientX;
  pointer.value.y = e.clientY;
};

const onPointerUp = (e) => {
  e.preventDefault();
  pointer.value.isDown = false;
};

onBeforeRender(({ delta, elapsed }) => {
  if (diamondRef.value) {
    diamondRef.value.rotation.y += delta * 0.1;
  }
});

render(({ renderer, scene, camera }) => {
  composer.render();
});

onMounted(() => {
  renderScene = new RenderPass(scene.value, camera.value);
  bloomPass = new UnrealBloomPass(
    new Vector2(width.value, height.value),
    0.3, // strength
    1, // radius
    1 // threshold
  );

  outputPass = new OutputPass();

  composer = new EffectComposer(renderer.value);
  composer.addPass(renderScene);
  composer.addPass(bloomPass);
  composer.addPass(outputPass);

  canvas.addEventListener("pointermove", onPointerMove, false);
  canvas.addEventListener("pointerdown", onPointerDown, false);
  canvas.addEventListener("pointerup", onPointerUp, false);
});

onUnmounted(() => {
  canvas.removeEventListener("pointermove", onPointerMove, false);
  canvas.removeEventListener("pointerdown", onPointerDown, false);
  canvas.removeEventListener("pointerup", onPointerUp, false);
});
</script>

<template>
  <PixelPerspectiveCamera :perspective="200">
    <!-- <OrbitControls makeDefault /> -->
  </PixelPerspectiveCamera>

  <TresGroup name="scene001" :scale="fitSize">
    <primitive
      :object="textMesh"
      :position="[-0.45, 0.5, 0]"
      :scale="[0.001, -0.001, 1]"
    />

    <!-- PLANE -->
    <!-- <TresMesh :position="[0, 0, -2]" :scale="2.5">
      <TresPlaneGeometry :args="[1, 1]" />
      <TresMeshBasicMaterial
        :map="props.assets.textures[1024]"
        :needsUpdate="true"
      />
    </TresMesh> -->

    <!-- DIAMOND -->
    <TresMesh
      ref="diamondRef"
      :scale="0.2"
      :rotation="[Math.PI * 0.05, 0, 0]"
      :geometry="props.assets.meshes.diamond.scene.children[0].geometry"
    >
      <TresMeshPhysicalMaterial
        :color="0xeffaff"
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
  <TresDirectionalLight :position="[1, 1, 1]" :intensity="1" />
</template>
