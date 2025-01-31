Setup:
  site: site_311a
  cdvar: cdr_dif
  group_vars: ['dustrate_ton_ha_yr_constant', 'dustrad', 'runname']
  csv_sil: meanAnn_gbas_shortRun_hiFert_gs+apprate_v0.csv
  csv_cc: meanAnn_liming_shortRun_hiFert_fixedRate_v2.csv
  multiyear_sil: False
  multiyear_cc: False

Removal accounting:
  time_horizon: 15
  cc_apprate_fixed: 0.8
  cc_dustrad_fixed: 150

Emissions:
  p80_input: 1300.0
  truck_km: 0.0
  truck_km_cc: 3000
  barge_km: 100.0
  barge_diesel_km: 0
  Efactor_org: MRO

