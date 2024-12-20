import { TextureLoader } from "three";

export async function loadThreeTextures(textures) {
  console.debug("loadTextures");

  let loadedTextures = {};

  const loader = new TextureLoader();

  for (const [key, value] of Object.entries(textures)) {
    await loader.loadAsync(value).then((res) => {
      loadedTextures[key] = {};
      loadedTextures[key] = res;
    });
  }

  return loadedTextures;
}
