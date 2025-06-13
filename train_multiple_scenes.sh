#!/usr/bin/env bash
set -euo pipefail
DATA_SOURCE=/shiraz/final_IMC_3D
OUTPUT_SOURCE=output_3dgs
#EXTRINSIC_SUFFIX="_scaniverse_aligned" # set to "" for no aligned
EXTRINSIC_SUFFIX="_photogram_aligned" # set to "" for no aligned
# EXTRINSIC_SUFFIX="" # set to "" for no aligned

SAVE_ITERS=(7000 30000)
TOTAL_ITERS=30000
RESOLUTION=1
# PTCL_DOWNSAMPLE=0.05
PTCL_DOWNSAMPLE=0
TEST_ITERS=5000

run_training() {
  local SCENE=$1
  local DATA_NAME=$2

  local FRAME_COUNT=1
  if [[ "${DATA_NAME}" == *_scene0 ]]; then
    FRAME_COUNT=1
  fi

  local MODEL_PATH=${OUTPUT_SOURCE}/${DATA_NAME}

  local DATA_DIR=${DATA_SOURCE}/rgbd_data/${SCENE}/${DATA_NAME}
  local INTRINSIC_PATH=${DATA_SOURCE}/intrinsics/${SCENE}_config.json
  local EXTRINSIC_PATH=${DATA_SOURCE}/extrinsics/global_extrinsics_${SCENE}${EXTRINSIC_SUFFIX}.npy

  if [[ "$DATA_NAME" == "arena_scene0" ]]; then
    # EXTRINSIC_PATH=${DATA_SOURCE}/extrinsics/global_extrinsics_arena_static_scene${EXTRINSIC_SUFFIX}.npy
    EXTRINSIC_PATH=${DATA_SOURCE}/extrinsics/global_extrinsics_arena_static_scene.npy
  fi

  local OUTPUT_DIR=${OUTPUT_SOURCE}/${DATA_NAME}
  mkdir -p ${OUTPUT_DIR}

  mkdir -p "${MODEL_PATH}"
  echo "▶ Training on ${DATA_NAME} (frames 0..$((FRAME_COUNT-1)))"

  for ((FRAME_IDX=1; FRAME_IDX<FRAME_COUNT+1; FRAME_IDX++)); do
    echo "   • frame_idx=${FRAME_IDX}"
    python train.py \
      -s "${DATA_DIR}" \
      --eval \
      --model_path "${MODEL_PATH}" \
      --iteration  ${TOTAL_ITERS} \
      --save_iterations ${SAVE_ITERS[@]} \
      --resolution ${RESOLUTION} \
      --test_iterations ${TEST_ITERS} \
      --intrinsic_path "${INTRINSIC_PATH}" \
      --extrinsic_path "${EXTRINSIC_PATH}" \
      --ptcl_downsample ${PTCL_DOWNSAMPLE} \
      --frame_idx ${FRAME_IDX}
  done

  # python render.py \
  #   --iteration ${SAVE_ITERS[1]} \
  #   --model_path "${MODEL_PATH}"
}

declare -A SCENE_DATASETS=(
  ["mill19"]="mill19_scene0 mill19_scene1 mill19_scene2"
  ["arena"]="arena_scene0 arena_scene1 arena_scene2 arena_scene3 arena_scene4 arena_scene5 arena_scene6"
  ["couch"]="couch_scene0 couch_scene1 couch_scene2 couch_scene3"
  ["kitchen"]="kitchen_scene0 kitchen_scene1 kitchen_scene2 kitchen_scene3"
  ["whiteboard"]="whiteboard_scene0 whiteboard_scene1 whiteboard_scene2 whiteboard_scene3"
)

for SCENE in "${!SCENE_DATASETS[@]}"; do
  for DATA_NAME in ${SCENE_DATASETS[$SCENE]}; do
    run_training "${SCENE}" "${DATA_NAME}"
  done
done

echo "✅ All training jobs completed."