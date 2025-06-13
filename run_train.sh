#!/bin/bash

# DATA_PATH=/shiraz/final_IMC_3D/shared_3d_capture/rgbd_data/arena/arena_scene4_200
DATA_PATH=/shiraz/final_IMC_3D/rgbd_data/arena/arena_scene0
INTRINSIC_PATH=/shiraz/final_IMC_3D/intrinsics/arena_config.json
EXTRINSIC_PATH=/shiraz/final_IMC_3D/extrinsics/global_extrinsics_arena.npy

python train.py \
  -s $DATA_PATH \
  --eval \
  --model_path output/arena_downsample \
  --save_iterations 7000 30000 \
  --resolution 1 \
  --test_iterations 1000 \
  --intrinsic_path $INTRINSIC_PATH \
  --extrinsic_path $EXTRINSIC_PATH \
  --ptcl_downsample 0.05 \
  --frame_idx 2 


# python render.py \
#     --iteration 30000 \
#     --model_path output/arena_downsample 