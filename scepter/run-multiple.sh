#!/usr/bin/env bash

# ----------------------------------------- # 
# ... define batch input
# batch_base="batch-tph-oneiter-base.yaml"
# batch_base="batch-no_app-base.yaml"
# batch_base="batch-tph-liming_noFert-multiyear-base.yaml"
# batch_base="batch-liming_fixedRate-base.yaml"
# batch_base="batch-basalt_fixedRate-base.yaml"
batch_base="batch-meanAnnliming_fert_fixedRate-base.yaml"
# batch_base="batch-meanAnnliming_fixedRate-base.yaml"
# batch_base="batch-meanAnnbasalt_fixedRate-base.yaml"
# batch_base="batch-meanAnndolomite_fixedRate-base.yaml"
# batch_base="batch-meanAnnCao_fixedRate-base.yaml"
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

# --- loop through rows in .csv
paramfile="parameters/$batch_base"
for ((i = 1; i <= num_rows; i++)); 
do
    echo "Running ${i}"
    argo submit scepter-workflow.yaml --parameter-file $paramfile -p batch-index="${i}"
    # [TROUBLESHOOT]
    sleep 1m  # take a break between submitted jobs :)
done





