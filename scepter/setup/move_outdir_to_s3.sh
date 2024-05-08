#!/usr/bin/env bash

# requires s3 credentials and s5cmd package
# https://github.com/peak/s5cmd

# --- this script syncs src (hub) files with dst (s3)
#     * if on src and not dst, src file added to dst
#     * if on src and dst but contents differ, src file overwrites dst
#     * if not on src but on dst, do nothing

# --- then removes files from src that are not excluded


# define source and destination
src = "/home/tykukla/SCEPTER/scepter_output/"
dst = "s3://carbonplan-carbon-removal/SCEPTER/scepter_output"


s5cmd sync --exclude  src dst