import { RGBELoader } from "three/addons/loaders/RGBELoader.js";
export async function loadThreeHDR(url) {
  console.debug("loadThreeHDR", url);

  let loadedHDR = {};

  const loader = new RGBELoader();

  await loader.loadAsync(url).then((res) => {
    loadedHDR = res;
  });

  return loadedHDR;
}
