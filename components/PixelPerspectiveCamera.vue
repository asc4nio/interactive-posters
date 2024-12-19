<script setup>
const props = defineProps({
  perspective: { type: Number, default: 0 },
});

const { height, fitSize, coverSize } = useWindowSize();

const fov = computed(() => {
  return (
    2 *
    Math.atan(height.value / 2 / (fitSize.value + props.perspective)) *
    (180 / Math.PI) *
    1
  );
});
</script>

<template>
  <TresPerspectiveCamera
    :look-at="[0, 0, 0]"
    :position="[0, 0, fitSize + perspective]"
    :fov="fov"
    :near="0.1"
    :far="10000"
    visible
  >
    <slot></slot>
  </TresPerspectiveCamera>
</template>
