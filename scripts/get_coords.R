#!/usr/bin/env Rscript

source("read_data.R")
source("geolocate.R")

output <- "../data/coords.csv"

for (i in 1:nrow(ttc)) {
  if(!is.na(ttc[i, "location"])) {
    r <-  getLocation(ttc$country[i], ttc$location[i],
                       ttc$state_province[i], ttc$county[i], delay=3)
    r$index <- i
    print(r)
    write.table(r, output, row.names=FALSE, append=TRUE, sep=",", col.names=FALSE)
  }
}

