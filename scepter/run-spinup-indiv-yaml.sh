#!/usr/bin/env bash

# NOTE: you can either put the CLI command in a bash script (e.g., here) or enter it directly in the terminal.
# Putting it in a bash script is nice for reproducibility.
for f in parameters/tuneup*.yaml;
do
    echo "Running ${f}"
    argo submit scepter-workflow.yaml --parameter-file ${f}
done
