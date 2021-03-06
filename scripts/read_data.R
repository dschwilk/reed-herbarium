#!/usr/bin/env Rscript

library(dplyr)

# exports three data frames

# read linked tables
# these data files are tabbed-deliminated with no quoted fields and no tabs allowed
ttc <- read.csv("../data/ttc.csv", sep="\t", quote="", stringsAsFactors=FALSE,
                na.strings=c("","NA"), strip.white=TRUE)
collections <- read.csv("../data/collections.csv", sep="\t", quote="",
                        stringsAsFactors=FALSE, na.strings=c("","NA"),
                        strip.white=TRUE)
groups <- read.csv("../data/groups.csv", stringsAsFactors=FALSE)

managed_area_types <-  read.csv("../data/managed_area_types.csv", sep="\t",
                                quote="", stringsAsFactors=FALSE,
                                na.strings=c("","NA"))


