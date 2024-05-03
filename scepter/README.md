# Demo for running SCEPTER via argo workflows

This repository contains an example for running the SCEPTER model via argo workflows. For detailed
instructions on using argo, view the "workflow orchestration (argo)" section of the Nebari/JuptyerHub
guide under the Open Source Team on the CarbonPlan Notion.

## Contents

| File | Description |
|----------|----------|
| [scepter-workflow.yaml](scepter-workflow.yaml) | Example argo workflow for running SCEPTER|
| [run-spinup.sh](run-multiple.sh)  | Example bash script for submitting a SCEPTER tuneup run |
| [run-multiple.sh](run-multiple.sh)  | Example bash script for submitting multiple individual SCEPTER models to run in parallel |
| [parameter files](parameters/)  | Parameter files specifying where to find the SCEPTER model and run script |

## Useful commands

| Command | Description |
|----------|----------|
| `argo submit <workflow>`   | Submit the workflow  |
| `argo list`  | List current workflows |
| `argo delete <workflow>`  | Deletes the workflow (kills the pod) |
