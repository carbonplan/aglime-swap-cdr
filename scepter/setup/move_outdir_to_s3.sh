#!/usr/bin/env bash

# requires s3 credentials and s5cmd package
# https://github.com/peak/s5cmd

# --- this script syncs src (hub) files with dst (s3)
#     * if on src and not dst, src file added to dst
#     * if on src and dst but contents differ, src file overwrites dst
#     * if not on src but on dst, do nothing

# --- then removes files from src that are not excluded
#     * exclude and do not sync files that were updated recently (in case still running)


# define source and destination
src="/home/tykukla/SCEPTER/scepter_output/"
dst="s3://carbonplan-carbon-removal/SCEPTER/scepter_output_scratch/"

# array of strings not to move
exclude_strings=("spintuneup" "other")

# define the time horizon within which files are untouched
toonew=0  # [days]

# loop through source subdirectories and check for last update
# current time in seconds since epoch
NOW=$(date +%s)

# define an exclude list
exc_list=""

# loop through subdirectories
for subdir in "$src"/*; do
    # check if it's a directory
    if [ -d "$subdir" ]; then

        # echo "checking $subdir"
        # get the last modification time of the directory
        LAST_UPDATE=$(stat -c %Y "$subdir")
        # calculate the difference in seconds between now and the last update time
        TIME_DIFF=$((NOW - LAST_UPDATE))
        # convert time difference to days
        TIME_DIFF_DAYS=$((TIME_DIFF / 86400)) # 86400 seconds in a day

        # check if this has a string on the excluded list
        should_exclude=false
        for exclude_string in "${exclude_strings[@]}"; do
            if [[ "$subdir" == *"$exclude_string"* ]]; then
                # echo "$subdir"
                should_exclude=true
                break
            fi
        done


        # check if the directory hasn't been updated in toonew days
        if [ $TIME_DIFF_DAYS -lt $toonew ] || [ "$should_exclude" = true ]; then
            # update exclusion list
            # exc_list+="$subdir "
            exc_list+=" --exclude $subdir"

            # echo "excluding $subdir"
            # echo "$TIME_DIFF_DAYS -le $toonew"
        fi
    fi
done

# echo $exc_list

# --- start venv
conda run -n cdr-scepter1p0_env

# --- sync dirs
# s5cmd --dry-run sync $exc_list $src $dst
# s5cmd --dry-run mv $exc_list $src $dst
s5cmd mv $exc_list $src $dst

# --- delete dirs that are now empty
find $src -mindepth 1 -type d -empty -not -path "$MAIN_DIR" -delete
