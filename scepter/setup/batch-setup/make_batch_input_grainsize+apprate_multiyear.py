# %%
# ---------------------------------------------------
# 
# Generate batch input .csv files for SCEPTER run
# using the rock_buff_dust_ts-multiyear.py script
# 
# provide var vectors and assume we want every 
# combination of them, or by site
# 
# T Kukla (CarbonPlan, 2024)
# 
# ---------------------------------------------------
import os
import numpy as np
import pandas as pd
import itertools
import batch_helperFxns as bhf

# %% 
# --- USER INPUTS
# [1] vars to update, constant for all runs
fertLevel = "no"    # name for how much fertilizer is applied
dustsp = "cc"      # name for dust species to apply (must be from accepted list)
pref = f"{fertLevel}Fert_{dustsp}_multiyear"
clim_tag = None   # [string] year-span (e.g., 1950-2020) for clim input if climate files are used
                  # (if clim files are not used, set to None)
# save vars
file_prefix = f"meanAnn_{dustsp}_shortRun_dustMultiyr_{fertLevel}Fert_gs+apprate"  # prefix of output run names
fn = file_prefix + "_v0.csv"
savepath_batch = "/home/tykukla/aglime-swap-cdr/scepter/batch-inputs"
multi_run_split = False   # whether to split the csv into multiple files
max_iters_per_set = 20    # [int] the number of runs per csv (only used if multi_run_split is True)

const_dict = {
    "duration": 15,  # duration of run (starts from earliest year)
    # -- dust timeseries inputs
    "dust_ts_dir": "/home/tykukla/aglime-swap-cdr/scepter/dust-inputs",
    "dust_ts_fn": f"{dustsp}_15yr_1app_no2nd_001.csv",
    # -- 
    "dustsp": dustsp,
    "dustsp_2nd": "amnt",
    "dustrate_2nd": 0,
    "add_secondary": False,
    "imix": 1,
    "singlerun_seasonality": False,
    "include_psd_full": False,
    "include_psd_bulk": False,
    "climatedir": "NA"
}

# %% 
# [2] vars to vary by site
sites = ['site_311a', 'site_311b']
by_site = {   # values must have same order as 'sites' var
    "cec": [21.10329, 6.96125],
    "spinrun": ["site_311a_pr9_spintuneup4", "site_311b_pr9_spintuneup4"],
    "climatefiles": ["site_311a", "site_311b"]  # these serve as the site name when there is no cliamte file to use
}

# %% 
# [3] vars to vary within site (we'll get every combination of these two)
dustrate_ton_ha_yr = [0.3, 0.6, 1, 2, 5, 7, 10, 15, 25, 35, 45, 60, 100]
all_combinations = {
    "dustrate": [x * 100 for x in dustrate_ton_ha_yr],  # [ton ha-1 yr-1 * 100 = g m-2]   
    "dustrad": [1, 10, 30, 50, 75, 100, 125, 150, 200]  # [diameter, microns] i think this gets applied to gbas and amnt equally (though amnt is fast-reacting so maybe not a big deal? )
}


# %% 
# --- BUILD DATAFRAME AND SAVE
df = bhf.build_df(pref, const_dict, sites, by_site, all_combinations, add_ctrl=True)
df
# %%
# save 
bhf.save_df(df, savepath_batch, fn, multi_run_split, max_iters_per_set)
# %%