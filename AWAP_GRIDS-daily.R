
'name:AWAP_GRIDS-daily'
library(githubinstall)
githubinstall("awaptools[develop]")

#install.packages("devtools")
library(devtools)
install_github("swish-climate-impact-assessment/awaptools", ref = "develop")
require(awaptools)
source('code/compress_gtifs2.R')
library(raster)

setwd("data_daily")
# get weather data, beware that each grid is a couple of megabytes
vars <- c("maxave","minave","totals","vprph09","vprph15") #,"solarave") 
# solar only available after 1990
for(measure in vars)
{
  #measure <- vars[1]
  get_awap_data(start = '2017-09-08',end = '2017-09-08', measure)
}
st <- Sys.time()
for(year in 2017){
print(year)
#  setwd("../data_daily_derived_1961_1990")  
#  year = 1992
  filelist <- dir(pattern = "grid$")
  filelist <- filelist[grep(sprintf("_%s", year), filelist)]
  filelist

# for(fl in filelist[-1]){
# file.rename(fl, file.path("../data_daily_derived_1991_2015", fl))
# }  
  
compress_gtifs2(indir = getwd(), subDir = "../data_daily_derived_1961_1990", filelist = filelist)
ed <- Sys.time()
print(ed - st)
}


datadir <- "GTif"
library(rgdal)
library(plyr)
library(reshape) 
library(ggmap)

# get location
address2 <- c("1 Lineaus way acton canberra", "daintree forest queensland", "hobart",
              "bourke")
locn <- geocode(address2)

# this uses google maps API, better check this
locn

## Treat data frame as spatial points
epsg <- make_EPSG()
shp <- SpatialPointsDataFrame(cbind(locn$lon,locn$lat),data.frame(address = address2, locn),
                              proj4string=CRS(epsg$prj4[epsg$code %in% '4283']))

# TODO make this extraction a function, and optimise with raster package things like stack and brick
# now loop over grids and extract met data
cfiles <-  dir(datadir, pattern=".tif$", full.names = T)

for (i in seq_len(length(cfiles))) {
  #i <- 1 ## for stepping thru
  gridname <- cfiles[[i]]
  r <- raster(gridname)
  #image(r) # plot to look at
  e <- extract(r, shp, df=T)
  #str(e) ## print for debugging
  e1 <- shp
  e1@data$values <- e[,2]
  e1@data$gridname <- gridname
  # write to to target file
  write.table(e1@data,"output.csv",
              col.names = i == 1, append = i>1 , sep = ",", row.names = FALSE)
}
# further work is required to format the column with the gridname to get out the date and weather paramaters.

dat <- read.csv("output.csv", stringsAsFactors = F)
head(dat)
dat$date <- matrix(unlist(strsplit(dat$gridname, "_")), ncol = 3, byrow=TRUE)[,3]
dat$date <- paste(substr(dat$date,1,4), substr(dat$date,5,6), substr(dat$date,7,8), sep = "-")
dat$measure <- matrix(unlist(strsplit(dat$gridname, "_")), ncol = 3, byrow=TRUE)[,2]


dat <- arrange(dat[,c("address", "lon", "lat", "date", "measure", "values")], address, date, measure)
head(dat)

dat2 <- cast(dat, address +   date ~ measure, value = 'values',
             fun.aggregate= 'mean')
dat2
