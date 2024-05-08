#!/usr/bin/env bash


# ----------------------------------------- # 
# ... define batch input
batch_base="tuneup_all.yaml"
# ----------------------------------------- # 


# --- find number of rows
filepath=$(grep 'batch-input-dir:' "parameters/$batch_base" | sed 's/.*: *//')
filename=$(grep 'batch-input:' "parameters/$batch_base" | sed 's/.*: *//')
filebase=${filename%.*}
# check if file exists
if [ ! -f "$filepath/$filename" ]; then
    echo "File not found!"
    exit 1
fi
# use wc to count lines
num_rows=$(wc -l < "$filepath/$filename")


# --- loop through rows
paramfile="parameters/$batch_base"
for ((i = 1; i <= num_rows; i++)); 
do
    echo "Running ${i}"
    argo submit scepter-workflow.yaml --parameter-file $paramfile -p batch-index="${i}"
done





