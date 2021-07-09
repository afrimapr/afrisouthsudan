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




