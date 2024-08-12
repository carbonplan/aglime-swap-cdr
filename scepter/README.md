# Running SCEPTER with argo workflows

This directory includes all of the input files that, along with `carbonplan/SCEPTER`, can be used to reproduce our SCEPTER analysis.

SCEPTER---the Soil Cycles of Elements simulator for Predicting TERrestrial regulation of greenhouse gases---is a one-dimensional reactive  transport model of soil geochemistry with functionality for rock dust application similar to those used for agricultural liming practices and enhanced rock weathering. It was first presented in [Kanzaki et al., 2022](https://gmd.copernicus.org/articles/15/4959/2022/).

The CarbonPlan `aglime-swap-cdr` and `SCEPTER` repositories rely on SCEPTER version 1.0.1 which, at time of writing, is described in a preprint by [Kanzaki et al](https://gmd.copernicus.org/preprints/gmd-2023-137/).


## Basic argo workflow
We use [argo workflows](https://argo-workflows.readthedocs.io/en/latest/) to run multiple SCEPTER simulations at once. The results can be reproduced without argo by running the `conda run -n*` line (L46) in [scepter-workflow.yaml](scepter-workflow.yaml) and replacing the input parameters. The inputs within [scepter-workflow.yaml](scepter-workflow.yaml) are used unless over-written by the respective `parameters/*.yaml` file.

Every argo job is submitted using the `argo submit` command (see [run-multiple.sh](run-multiple.sh) and [run-spinup.sh](run-spinup.sh)). This compiles the parameters and runs line 46 of [scepter-workflow.yaml](scepter-workflow.yaml), which initializes a virtual environment and runs a "control script" (see the [control-scripts](control-scripts) directory). Each control script reads in a defined `.csv` file (see [batch-inputs](batch-inputs) where each row is a single SCEPTER run and the columns are inputs that will over-ride the defaults (see `carbonplan/SCEPTER/defaults`). The control script passes these inputs to Python script that makes and runs SCEPTER.


## Individual runs
The files and relevant input decisions for each set of runs can be found in the --TK: INSERT FILE-- file. After identifying the set of runs to conduct, running it requires three steps:

1. **Update the run script**. Identify the run script (*run_shell* column), find it in `aglime-swap-cdr/scepter` and open it. Set the `batch_base` variable equal to the parameter file (from the *parameter_file* column).
2. **Update the parameter file**. Navigate to the parameter file (in `aglime-swap-cdr/scepter/parameters/`). Set the `batch_input` parameter to the name of the `.csv` file in the *batch_csv* column. Ensure the `default-dict` matches the *dictionary* column.
3. **Run the model**. Open a terminal and navigate to the `aglime-swap-cdr/scepter` directory. Run `./<run script>` (e.g., `./run-multiple.sh` or `./run-spinup.sh`)
