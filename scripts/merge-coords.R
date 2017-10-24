library(dplyr)

source("./read_data.R")
coords <- read.csv("../data/coords.csv", stringsAsFactors=FALSE)

coords.best <- coords %>% group_by(catalogNumber) %>% slice(which.max(glcScore))


coords.best <- coords.best %>% mutate(georeferenceProtocol="WGS84",
                                      georeferencedBy="dschwilk",
                                      georeferenceSources="GeoLocate",
                                      georeferenceVerificationStatus="requires verification",
                                      georeferenceRemarks = paste("glcPrecision=",
                                                                  glcPrecision,
                                                                  "|glcScore=",
                                                                  glcScore,
                                                                  "|glcParsePattern=",
                                                                  glcParsePattern, sep="")
                                      ) %>%
  select(-glcScore, -glcPrecision, -glcParsePattern)


ttc <- left_join(ttc, coords.best)


write.table(ttc, "../data/ttc.csv", sep="\t", quote=FALSE, row.names=FALSE, na="")

