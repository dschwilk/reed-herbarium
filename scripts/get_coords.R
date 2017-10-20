#!/usr/bin/env Rscript

source("geolocate.R")
source("read_data.R")

output <- "../data/coords.csv"

ttc <- read.csv("../data/ttc_redo.csv")
for (i in 1:nrow(ttc)) {
  print(i)
  if (is.na(ttc$locality[i])) {
    loc <- ttc$verbatimLocality[i]
  } else {
    loc <- ttc$locality[i]
  }

  if(!is.na(loc)) {
    r <-  getLocation(ttc$country[i], loc,
                      ttc$stateProvince[i], ttc$county[i], delay=2)
    r$catalogNumber <- ttc$catalogNumber[i]
    print(r)
    write.table(r, output, row.names=FALSE, append=TRUE, sep=",", col.names=FALSE)
  }
}
