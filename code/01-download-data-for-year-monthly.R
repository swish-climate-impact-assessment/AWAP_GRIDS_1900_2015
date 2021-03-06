projdir <- "~/ResearchData/AWAP_GRIDS/AWAP_GRIDS_1900_2015"
projdir
setwd(projdir)
library(awaptools)
dir()
dir.create("data_provided_monthly")
setwd("data_provided_monthly")
# get weather data, beware that each grid is a couple of megabytes
years <- 1900:1919
for(yy in years){
    ## yy <- 1900
    load_monthly(start = sprintf('%s-01-01', yy),end = sprintf('%s-12-1', yy))
}

setwd(projdir)
