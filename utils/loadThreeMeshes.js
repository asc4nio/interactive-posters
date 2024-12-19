import { GLTFLoader } from "three/addons/loaders/GLTFLoader";

export async function loadThreeMeshes(meshes) {
  console.debug("loadThreeMeshes", meshes);

  let loadedMeshes = {};

  // SET DRACO DECODER
  // const DRACO = new DRACOLoader();
  // DRACO.setDecoderPath("/decoder/");

  // SET GLTF LOADER
  const loader = new GLTFLoader();
  // gltfLoader.setDRACOLoader(DRACO);

  // LOAD MESHES
  for (const [key, value] of Object.entries(meshes)) {
    await loader.loadAsync(value).then((res) => {
      loadedMeshes[key] = {};
      loadedMeshes[key] = res;
    });
  }

  return loadedMeshes;
}
