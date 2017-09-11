'name:AWAP_GRIDS-daily'
#library(githubinstall)
#githubinstall("awaptools[develop]")

#install.packages("devtools")
#library(devtools)
#install_github("swish-climate-impact-assessment/awaptools", ref = "develop")
require(awaptools)
source('code/compress_gtifs2.R')
library(raster)

setwd("data_2000_2012")
st <- Sys.time()
for(year in 2009:2012){
print(year)
  #setwd("../data_daily_derived_1961_1990")
#  year = 1992
  filelist <- dir(pattern = "grid$")
  filelist <- filelist[grep(sprintf("_%s", year), filelist)]
  filelist

# for(fl in filelist[-1]){
 #file.rename(fl, file.path("../data_daily_derived_1991_2015", fl))
 #}

compress_gtifs2(indir = getwd(), subDir = "../data_daily_derived_1991_2015", filelist = filelist)
ed <- Sys.time()
print(ed - st)
}
