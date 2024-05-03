#! /usr/bin/bash

# --- site 411 scepter tune up (southeast)
mat=18.52789            # [degC] mean annual temperature
soilmoisture=0.231552   # [m3/m3] mean annual soil moisture 
qrun=0.2434256          # [m/yr] mean annual runoff
tsom=2.276667           # [wt%] target soil organic matter
erosion=0.00084         # [m/yr] erosion
nitrif=0.831883         # [gN/m2/yr] NO3 production rate via nitrification
tph=5.200242            # [] target soil pH
cec=1.96125             # [cmol/kg] cation exchange capacity
tec=46.91557            # [%CEC] target exchangeable acidity (acid saturation = 100 - base saturation %)
tsoilco2=-1.61194       # [log10 atm] target soil pco2 
poro=0.419              # field porosity
alpha=2.                # [] pH dependence of CEC coefficients (see Appelo, 1994) -- value from Yoshi (pers. comm.)

# spinup name
spinname=site_411_spintuneup       # name of spinup run

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
