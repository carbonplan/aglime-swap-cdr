#! /usr/bin/bash

# name of run script
# runscript="$1/tunespin_manual-test_defaultdict.py"
runscript="$1/tunespin_4_manual-test_defaultdict.py"

# model directory
modeldir="$1"
# output directory
outdir="$modeldir/scepter_output/"
# default dictionary
default_dict="$5"  # see SCEPTER/defaults/dict_singlerun.py

# --- COLLECT INPUTS ---
# input csv 
input_dir=$2
input_name=$3
input_index=$4
((input_index++))  # add one to skip column names

# check if directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Directory '$input_dir' does not exist."
    exit 1
fi
# check if file exists
file_path="$input_dir/$input_name"
if [ ! -f "$file_path" ]; then
    echo "Error: File '$file_path' does not exist."
    exit 1
fi
# read data from the specified row number
row_data=$(sed "${input_index}q;d" "$file_path")
echo "Data from row $row_number: $row_data"

# read the header row to get column names
header_row=$(head -n 1 "$file_path")
IFS=$' , ' read -r -a columns <<< "$header_row"
# assign values to variables using column names
IFS=$' , ' read -r -a values <<< "$row_data"
declare -A params
for ((i=0; i<${#columns[@]}; i++)); do
    column_name="${columns[i]}"
    value="${values[i]}"
    declare "$column_name"="$value"
    params["$column_name"]="$value"
done

# make sure the row of data isn't empty
if [ -z "$spinname" ]; then
    echo "spinname is empty. Exiting script."
    exit 1
fi

# build the Python command
python_cmd="python3 $runscript --modeldir $modeldir --outdir $outdir --default_dict $default_dict"
for key in "${!params[@]}"; do
    python_cmd+=" --$key ${params[$key]}"
done

# Run the Python script
echo "running python script with command:"
echo "$python_cmd" # troubleshoot
eval "$python_cmd"