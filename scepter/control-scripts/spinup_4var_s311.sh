#! /usr/bin/bash

# --- site 311 scepter tune up (great plains)
mat=8.22219             # [degC] mean annual temperature
soilmoisture=0.282727   # [m3/m3] mean annual soil moisture 
qrun=0.3513611          # [m/yr] mean annual runoff
tsom=2.051667           # [wt%] target soil organic matter
erosion=0.001013        # [m/yr] erosion
nitrif=1.005952         # [gN/m2/yr] NO3 production rate via nitrification
tph=6.058007            # [] target soil pH
cec=21.10329            # [cmol/kg] cation exchange capacity
tec=20.98031            # [%CEC] target exchangeable acidity (acid saturation = 100 - base saturation %)
tsoilco2=-1.80371       # [log10 atm] target soil pco2 
poro=0.447              # field porosity
alpha=2.                # [] pH dependence of CEC coefficients (see Appelo, 1994) -- value from Yoshi (pers. comm.)

# spinup name
spinname=site_311_spintuneup       # name of spinup run

# initial guess (name of prior spinup)
initguess=none          # [none, spinup_run_name] will search output directory for a folder with 
                        # an initial guess to speed up tuning

# define output directory
outdir="$1/scepter_output/"
# default dictionary
default_dict="$5"  # see SCEPTER/defaults/dict_singlerun.py

# name of run script
runscript="$1/tunespin_4_newton_inert_buff_v2_defaultdict.py"

# ----------------------------------------------------
# --- NAVIGATE TO MODEL DIRECTORY
# cd "$1" || exit  # exit if the directory doesn't exist
# --- RUN 
python3 $runscript --spinname $spinname --cec $cec --tph $tph --tec $tec --tsom $tsom --mat $mat --soilmoisture $soilmoisture --qrun $qrun --erosion $erosion --nitrif $nitrif --tsoilco2 $tsoilco2 --poro $poro --alpha $alpha --initguess $initguess --outdir $outdir --default_dict $default_dict
