#!/usr/bin/env bash

# --------------------------------------- # 
# define batch input
batch_base="batch-test-base.yaml"
# --------------------------------------- # 


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


# --- generate secondary yaml files
param_dir_orig="parameters/$filebase"  # baseline param_dir
param_dir="parameters/$filebase"   # updated param_dir
counter=1  # suffix if needed
while [ -d "$param_dir" ];   # add counter to directory when we get one that doesn't exist
do
    ((counter++))
    param_dir="${param_dir_orig}_${counter}"
done
mkdir -p "$param_dir"  # create directory
output_yaml_prefix="${batch_base%%-base*}_"  # create secondary yaml prefix (deletes "batch")
# loop through to create secondary yamls
for ((i = 1; i <= num_rows; i++)); 
do
    output_yaml="$param_dir/$output_yaml_prefix$(printf "%02d" $i).yaml"
    cp "parameters/$batch_base" "$output_yaml"
    echo -e "\nbatch-index: $i" >> "$output_yaml"
done


# --- loop through secondary yaml file submissions
for f in $param_dir/batch*.yaml;
do
    echo "Running ${f}"
    argo submit scepter-workflow.yaml --parameter-file ${f}
done

