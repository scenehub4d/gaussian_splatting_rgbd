#!/bin/bash

DATA_PATH="/home/jaehong/dataset" 
MODEL_PATH="output"
# MODEL_PATH="/home/jaehong/dataset/models" 

m360_dataset=("bicycle" "counter" "bonsai" "garden" "room" "kitchen" "stump")
db_dataset=("drjohnson" "playroom")
tandt_dataset=("train" "truck")

iteration=30000

dataset_type=("mipnerf360" "db" "tandt")

# Loop over each dataset type
for dataset in "${dataset_type[@]}"; do
    # Select the appropriate dataset array based on the dataset type
    case $dataset in
        "mipnerf360")
            dirs=("${m360_dataset[@]}")
            ;;
        "db")
            dirs=("${db_dataset[@]}")
            ;;
        "tandt")
            dirs=("${tandt_dataset[@]}")
            ;;
        *)
            echo "Unknown dataset type: $dataset"
            continue
            ;;
    esac

    # Loop over each directory in the selected dataset array
    for dir in "${dirs[@]}"; do
        python train.py -s ${DATA_PATH}/${dataset}/${dir} --eval --model_path ${MODEL_PATH}/${dataset}/${dir}
        python render.py --iteration $iteration -m ${MODEL_PATH}/${dataset}/${dir} -s ${DATA_PATH}/${dataset}/${dir}
        python metrics.py -m ${MODEL_PATH}/${dataset}/${dir}
    done
done