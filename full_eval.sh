#!/bin/bash

# DATA_PATH="/home/jaehong/dataset/models"
DATA_PATH="/home/jaehong/dataset"
MODEL_PATH="output"

python full_eval.py --output_path ${MODEL_PATH} --skip_training -m360 ${MODEL_PATH}/mipnerf360 -tat ${MODEL_PATH}/tandt -db ${MODEL_PATH}/db