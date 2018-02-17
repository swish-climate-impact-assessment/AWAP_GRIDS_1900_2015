'name:02-decompress-year-monthly'
setwd(projdir)
dir.create("data_derived_monthly")
setwd("data_provided_monthly")

st <- Sys.time()
for(year in years){
## year <- yy
    print(year)

  filelist <- dir(pattern = "grid.Z$")
  filelist <- filelist[grep(sprintf("_%s", year), filelist)]
##  filelist
    for(fname in filelist){
        ##fname <- filelist[1]
        uncompress_linux(filename = fname)    
    }
filelist <- gsub(".Z", "", filelist)
compress_gtifs(indir = getwd(), subDir = "../data_derived_monthly", filelist = filelist)
ed <- Sys.time()
print(ed - st)
}
setwd(projdir)
