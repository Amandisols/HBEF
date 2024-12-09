
#Author: Amanda Pennino
#Date: December 2, 2024

library(sf)
library(terra)
library(raster)


#Input
# * Latest HPU map: https://doi.org/10.6073/pasta/a000ef8c9274155b5b2b4bf9622ead23 (Accessed 2024-11-13).
# * Watershed boundaries

#Output
# * Watershed 3 HPU map
# * Watershed 3 outline
# * Watershed 3 outline with 50m buffer

#Workflow
#01-Soil map creation
#02-DEM processing (for hydrologic analysis)
#03-Identify events (precipitation)
#04-Water levels & wells (extract gw behavior during events)
#05-Soil descriptions and chemistry
#06-Chemistry (water)


ws <- vect("vectors/hbef_wsheds.shp")

plot(ws)

## crop to watershed of interest, add 100m buffer
ws3 <- ws[ws$WS == "WS3", ]
ws3_50 <- buffer(ws3, 50)

plot(ws3)
plot(ws3_50)

#1- Bh
#2- Bhs
#3- Bimodal
#4- E podzol
#5- Histosol
#6- Inceptisol
#7- O
#8- Typical

# Navigate to wherever the model is stores
soils <- rast("~/projects/DSS/HBEF/data/GIS/hpu_map2024/modelout2024-02-21.tif")

plot(soils)

## verses mask
ws3_hpu <- crop(soils, ws3_50)
ws3_hpu <- mask(ws3_hpu, ws3_50)

plot(ws3_hpu)
plot(ws3, add = TRUE)


## save 
writeRaster(ws3_hpu, filename = 'rasters/hpu_ws3.tif', overwrite = TRUE)
writeVector(ws3, filename = 'vectors/ws3.shp', overwrite = TRUE)
writeVector(ws3_50, filename = 'vectors/ws3_50m-buffer.shp', overwrite = TRUE)

