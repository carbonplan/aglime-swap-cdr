#!/usr/bin/env bash

# requires s3 credentials and s5cmd package
# https://github.com/peak/s5cmd

# --- this script syncs src (hub) files with dst (s3)
#     * if on src and not dst, src file added to dst
#     * if on src and dst but contents differ, src file overwrites dst
#     * if not on src but on dst, do nothing

# --- then removes files from src that are not excluded
#     * exclude and do not sync files that were updated recently (in case still running)


# --- start venv # (might need to run conda activate cdr-scepter1p0_env in terminal first)
conda run -n cdr-scepter1p0_env

# Set the source S3 bucket and destination path
SOURCE_BUCKET="s3://carbonplan-carbon-removal/SCEPTER/scepter_output_scratch/"
DESTINATION_PATH="/home/tykukla/SCEPTER/scepter_output/"

# --- List directories in the source bucket and filter for "spinup" in the name
# (include spintuneup)
s5cmd ls "$SOURCE_BUCKET" | grep "spintuneup" | while read -r line; do
# (exclude spintuneup)
# s5cmd ls "$SOURCE_BUCKET" | grep -v "spintuneup" | while read -r line; do

    # Extract the directory path from the listing
    DIR_PATH=$(echo "$line" | awk '{print $NF}')

    # Move each matching directory to the destination
    echo "Syncing ${SOURCE_BUCKET}${DIR_PATH}* to ${DESTINATION_PATH}${DIR_PATH}"
    s5cmd sync "${SOURCE_BUCKET}${DIR_PATH}*" "${DESTINATION_PATH}${DIR_PATH}"
    # s5cmd --dry-run sync "${SOURCE_BUCKET}${DIR_PATH}*" "${DESTINATION_PATH}${DIR_PATH}"

    # echo "moving ${SOURCE_BUCKET}${DIR_PATH}* to ${DESTINATION_PATH}${DIR_PATH}"
    # s5cmd mv "${SOURCE_BUCKET}${DIR_PATH}*" "${DESTINATION_PATH}${DIR_PATH}"
    # s5cmd --dry-run mv "${SOURCE_BUCKET}${DIR_PATH}*" "${DESTINATION_PATH}${DIR_PATH}"
done




# --- delete dirs that are now empty
# find $src -mindepth 1 -type d -empty -not -path "$MAIN_DIR" -delete



# --- sync dirs
# s5cmd --dry-run sync --include "*spintuneup*" 's3://carbonplan-carbon-removal/SCEPTER/scepter_output_scratch/' '/home/tykukla/SCEPTER/scepter_output/'
# s5cmd --dry-run sync --include "*.log" --exclude "access_*" --include "*.txt" 's3://carbonplan-carbon-removal/SCEPTER/scepter_output_scratch/*' .
# s5cmd --dry-run sync $exc_list $src $dst
# s5cmd --dry-run mv $inc_list $src $dst
# s5cmd mv $exc_list $src $dst


# --- delete dirs that are now empty
# find $src -mindepth 1 -type d -empty -not -path "$MAIN_DIR" -delete
