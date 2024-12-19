// to use only on client side

export default function useWindowSize() {
    const width = ref(window.innerWidth);
    const height = ref(window.innerHeight);
  
    // const coverSize = computed(() => {
    //   return Math.max(width.value, height.value);
    // });
    // const minAllowed = 420;
    // const fitSize = computed(() => {
    //   return Math.max(minAllowed, Math.min(width.value, height.value));
    // });
  
    function onResize() {
      width.value = window.innerWidth;
      height.value = window.innerHeight;
    }
  
    onMounted(() => {
      window.addEventListener("resize", onResize);
    });
    onUnmounted(() => window.removeEventListener("resize", onResize));
  
    return { width, height };
    // return { width, height, coverSize, fitSize };
  }