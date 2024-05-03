#!/usr/bin/env bash

# location of download scripts
script_dir="/home/tykukla/aglime-swap-cdr/cesm2/download_scripts"
outdir="/home/tykukla/aglime-swap-cdr/cesm2/data/preprocessed/"

for f in "$script_dir"/cesm2le*.py;
do
    echo "now collecting ${f}"
    python3 ${f}
done

# move all files to the data directory
mv b.e21*.nc $outdir