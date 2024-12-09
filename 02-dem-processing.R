#Author: Amanda Pennino
#Date: December 2, 2024

library(sf)
library(terra)
library(whitebox)
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
ws3_dem <- crop(hb_dem, ws3)
ws3_dem <- mask(ws3_dem, ws3)

#plot(ws3_dem)
writeRaster(ws3_dem, filename = 'rasters/dem1m_ws3.tif', overwrite = TRUE)


# Create temp dir for intermediate steps (to save on data storage)
dir_temp <- tempdir()


wbt_fill_depressions_wang_and_liu(
  dem = "rasters/dem1m_ws3.tif",
  output = "rasters/ws3_fill.tif"
)


wbt_feature_preserving_smoothing(
  dem = "rasters/ws3_fill.tif",
  output = "rasters/ws3_fillsmooth.tif", 
  filter = 11, norm_diff = 15, num_iter = 10
)


wbt_breach_depressions_least_cost(
  dem = "rasters/ws3_fillsmooth.tif",
  output = "rasters/ws3_fillsmoothbreach.tif",
  dist = 5
)

ws3_dem2 <- rast("rasters/ws3_fillsmoothbreach.tif")
plot(ws3_dem2)

# Flow accumulation rasters 
## d8-flow accumulation
wbt_d8_flow_accumulation(
  "rasters/ws3_fillsmoothbreach.tif",
  output = "rasters/ws3_d8.tif",
  out_type = "cells"
)

## Multiple direction flow accumulation.
wbt_md_inf_flow_accumulation(
  "rasters/ws3_fillsmoothbreach.tif",
  output = "rasters/ws3_mdinf.tif",
  out_type = "sca"
)

wbt_md_inf_flow_accumulation(
  "rasters/ws3_fillsmoothbreach.tif",
  output = "rasters/ws3_mdinf_log.tif",
  out_type = "sca",
  log = TRUE
)


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

