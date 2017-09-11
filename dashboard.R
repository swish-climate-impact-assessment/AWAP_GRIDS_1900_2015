system("df -h")
datadir <- "data_daily_derived_1991_2015"
dat <- dir(datadir, pattern=".tif$", full.names = F)
dat <- data.frame(gridname = as.character(dat))
#head(dat)
dat$gridname <- as.character(dat$gridname)
dat$date <- matrix(unlist(strsplit(dat$gridname, "_")), ncol = 3, byrow=TRUE)[,3]
dat$date <- paste(substr(dat$date,1,4), substr(dat$date,5,6), substr(dat$date,7,8), sep = "-")
dat$measure <- matrix(unlist(strsplit(dat$gridname, "_")), ncol = 3, byrow=TRUE)[,2]
#head(dat)
dat$year <- substr(dat$date,1,4)
#head(dat)
#table(dat$year)
table(dat$year, dat$measure)
setwd("..")
