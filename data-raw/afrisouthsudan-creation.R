## afrisouthsudan-creation.R

## complete record of package creation

## Github first repo

## RStudio create new project from repo

librray(usethis)
usethis::create_package(path=getwd())

usethis::use_data_raw()

## rename DATASET.R to this afrisouthsudan-creation.R

#mkdir("inst//extdata")

# copy geopackage into inst//extdata//ssd_ihdp_c19_s0_pp.gpkg

use_package("sf", "Imports")
use_package("mapview", "Suggests")

# RStudio, Build, Install & Restart

filename <- system.file("extdata","ssd_ihdp_c19_s0_pp.gpkg", package="afrisouthsudan", mustWork=TRUE)

library(sf)
layers <- sf::st_layers(filename)
layernames <- layers$name

sf1 <- st_read(filename, layer=layernames[1])

mapview(sf1)

# copied layer names & descriptions from googlesheet
# saved to inst\\extdata\\ssd-layer-description-lookup.csv
# ssd_admn_ad0_py_s0_c19ihdp_pp,Country boundary
# ssd_admn_ad1_py_s0_c19ihdp_pp,State boundary
# ssd_admn_ad2_py_s0_c19ihdp_pp,County boundary
# ssd_tran_air_pt_s0_c19ihdp_pp,Airports
# ssd_heal_med_pt_s0_c19ihdp_pp,Medical facilities
# ssd_tran_net_ln_s0_c19ihdp_pp,Major roads and rivers
# ssd_tran_rds_ln_s0_c19ihdp_pp,Roads
# ssd_pois_poi_pt_s0_c19ihdp_pp,General points of interest
# ssd_stle_stl_pt_s0_c19ihdp_pp,Settlements
# ssd_stle_stl_pt_s0_c19ihdp_pp_dist,Settlements including the distance of the settlements population to the nearest road hospital airport and river
# ssd_phys_riv_ln_s0_c19ihdp_pp,Rivers
# ssd_tran_poi_pt_s0_c19ihdp_pp,Transport points of interest
# ssd_tran_air_ln_s0_c19ihdp_pp_unhas,United Nations humanitarian air service routes

lookupname <- system.file("extdata","ssd-layer-description-lookup.csv", package="afrisouthsudan", mustWork=TRUE)

dflayers <- read.csv(lookupname)


