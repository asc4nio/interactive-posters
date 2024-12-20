import { SVGLoader } from "three/addons/loaders/SVGLoader.js";

export async function loadThreeSVGs(svgs) {
  console.debug("loadThreeSVGs");

  let loadedSVGs = {};

  const loader = new SVGLoader();

  for (const [key, value] of Object.entries(svgs)) {
    await loader.loadAsync(value).then((res) => {
      loadedSVGs[key] = {};
      loadedSVGs[key] = res;
    });
  }

  return loadedSVGs;
}
