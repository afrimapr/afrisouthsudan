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

library(mapview)
mapview(sf1)

# copied layer names & descriptions from googlesheet
# https://docs.google.com/spreadsheets/d/1KTMOhQtcdkM7d8_XxGVmyb3N8K5rc6YDgsuMxWbqS6k/edit#gid=0

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

# I added a shortdescription column named 'content' that can be used e.g. to select layers
# TODO I could also add a field for the primary attribute column to be used in default mapview maps!

lookupname <- system.file("extdata","ssd-layer-description-lookup.csv", package="afrisouthsudan", mustWork=TRUE)

dflayers <- read.csv(lookupname)


# trying to sort legends that present data values rather than pretty ranges
# for adm1 layer (but not adm2 layer)
layername <- 'ssd_admn_ad1_py_s0_c19ihdp_pp'
sflayer <- sf::st_read(filename, layer=layername)
mapview(sflayer, zcol='pop_61plus')

#can sf read the layer_styles layer ? yes it is just a dataframe, does have all the layernames in
layername <- 'layer_styles'
sflayerstyles <- sf::st_read(filename, layer=layername)
mapview(sflayer, zcol='pop_61plus')

#checking new travel distance buffers
layername <- 'ssd_tran_iso_py_s0_c19ihdp_pp_30min1m4kmbuf'
sflayerbuf1 <- sf::st_read(filename, layer=layername)
mapview(sflayerbuf1)

layername <- 'ssd_tran_iso_py_s0_c19ihdp_pp_30min1km4kmbuf'
sflayerbuf2 <- sf::st_read(filename, layer=layername)
mapview(sflayerbuf2)

# the colours on the map are correct it is just the legend that doesn't look good
# seems to be a mapview issue, when there are <11 unique values
# I submitted this to mapview & got it fixed
breweries30 <- breweries[1:30,]
breweries40 <- breweries[1:40,]
mapview(breweries30, zcol = "number.of.types")
mapview(breweries40, zcol = "number.of.types")
length(unique(breweries30$number.of.types))
length(unique(breweries40$number.of.types))


