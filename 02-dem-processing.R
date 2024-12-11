#Author: Amanda Pennino
#Date: December 2, 2024

library(sf)
library(terra)
library(whitebox)
library(raster)
whitebox::wbt_init()

## NOTES ##
#Processing DEM for hydrologic analysis using WhiteBox tools.
#Only re-run this again if changing watershed outline

#Input
# * DEM
# * Watershed boundaries

#Output
# * Watershed 3 DEM -raw
# * Filled 

#Workflow
#01-Soil map creation
#02-DEM processing (for hydrologic analysis)
#03-Identify events (precipitation)
#04-Water levels & wells (extract gw behavior during events & delineate watersheds, topographic metrics)
#05-Soil descriptions and soil chemistry
#06-Chemistry (water)



hb_dem <- rast("~/projects/DSS/HBEF/data/GIS/grids/dem1m.tif")
#plot(hb_dem)

ws3 <- vect("vectors/ws3.shp")
dem1m_ws3 <- crop(hb_dem, ws3)
dem1m_ws3 <- mask(dem1m_ws3, ws3)

dem5m_ws3 <- aggregate(dem1m_ws3, fact=5, fun="mean")

#writeRaster(dem1m_ws3, filename = 'rasters/dem1m_ws3.tif', overwrite = TRUE)
#writeRaster(dem5m_ws3, filename = 'rasters/dem5m_ws3.tif', overwrite = TRUE)


# Create temp dir for intermediate steps (to save on data storage)
dir_temp <- tempdir()


wbt_fill_depressions_wang_and_liu(
  dem = "rasters/dem5m_ws3.tif",
  output = paste0(dir_temp, "fill.tif")
)


wbt_feature_preserving_smoothing(
  dem = paste0(dir_temp, "fill.tif"),
  output = paste0(dir_temp, "fill_smooth.tif"), 
  filter = 11, norm_diff = 15, num_iter = 10
)


wbt_breach_depressions_least_cost(
  dem = paste0(dir_temp, "fill_smooth.tif"),
  output = "rasters/dem5m_ws3_hydro.tif",
  dist = 5
)

dem_hydro <- rast("rasters/dem5m_ws3_hydro.tif")

# Flow accumulation rasters 
## d8-flow accumulation
wbt_d8_flow_accumulation(
  input = "rasters/dem5m_ws3_hydro.tif",
  output = paste0(dir_temp, "5m_d8.tif"),
  out_type = "cells"
)

## Multiple direction flow accumulation.
wbt_md_inf_flow_accumulation(
  "rasters/dem5m_ws3_hydro.tif",
  output = "rasters/mdinf5m_ws3.tif",
  out_type = "sca"
)


## Look at difference

flowgrid <- rast(paste0(dir_temp, "1m_d8.tif"))
flowgrid[flowgrid < 5e2] <- NA
flowgrid <- flowgrid*0+1 # Set all NAs = 0, all streams = 1
flownet <- rasterToPolygons(flowgrid, dissolve = TRUE)
flownet1m <- st_as_sf(flownet)

plot(flowgrid)

flowgrid <- rast(paste0(dir_temp, "5m_d8.tif"))
flowgrid[flowgrid < 5e2] <- NA
flowgrid <- flowgrid*0+1 # Set all NAs = 0, all streams = 1
flownet <- raster::rasterToPolygons(flowgrid, dissolve = TRUE)
flownet5m <- st_as_sf(flownet)


??rasterToPolygons


plot(flownet1m)
plot(flownet5m)



writeRaster(flowgrid, filename = "rasters/flowgrid_5e2_dem1m.tif", overwrite = TRUE)
st_write(flownet, "vectors/flownet_5e2_dem1m.shp")


# Create a flow network using multiple (where a stream would likely be)
## For 1m DEM use flowgrid <5e3, for 3m use <90
flowgrid <- raster("rasters/ws3_d8.tif")
flowgrid[flowgrid < 5e2] <- NA
flowgrid <- flowgrid*0+1 # Set all NAs = 0, all streams = 1
flownet <- rasterToPolygons(flowgrid, dissolve = TRUE)
flownet <- st_as_sf(flownet)

plot(flownet)

writeRaster(flowgrid, filename = "rasters/flowgrid_5e2_dem1m.tif", overwrite = TRUE)
st_write(flownet, "vectors/flownet_5e2_dem1m.shp")

