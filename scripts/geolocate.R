#!/usr/bin/env Rscript

library(RJSONIO)
library(RCurl)

service_url <- "http://www.museum.tulane.edu/webservices/geolocatesvcv2/glcwrap.aspx?"
GEO_OPTIONS="&doduncert=true&dopoly=false&displacepoly=false"

reformatPolygon <- function(poly) {
  sPoly = ''
  for (v in 1:length(poly$coordinates[[1]][])){
    vLon=format(poly$coordinates[[1]][[v]][1])
    vLat=format(poly$coordinates[[1]][[v]][2])
    sPoly  = paste(sPoly,vLat, vLon, sep=',')
  }
  # Strip the leading commas
  sPoly=sub("^,+", "", sPoly)
  return(sPoly)
}


glc2df <- function(glc, i) {
  rdf <- data.frame(glcRank  = i,
                   glcLongitude = glc$resultSet$features[[i]]$geometry$coordinates[1],
                   glcLatitude = glc$resultSet$features[[i]]$geometry$coordinates[2],
                   glcPrecision = glc$resultSet$features[[i]]$properties$precision,
                   glcScore = glc$resultSet$features[[i]]$properties$score,
                   glcParsepattern = glc$resultSet$features[[i]]$properties$parsePattern,
                   glcUncert = glc$resultSet$features[[i]]$properties$uncertaintyRadiusMeters,
                   glcPoly = glc$resultSet$features[[i]]$properties$uncertaintyPolygon,
                   stringsAsFactors=FALSE)

  #if a polygon is present reformat coordinates to geolocate format-a comma delimited array
  if ("coordinates"%in%names(rdf$glcPoly)){
    rdf$glcPoly <- reformatPolygon(rdf$glcPoly)
  }
  return(rdf)
}


getLocation <- function(country, locality, state_province, county, delay=0) {
  q=paste(service_url, "country=", country,"&locality=", locality, "&state=",
          state_province, "&county=", county, GEO_OPTIONS, sep='')
  q=gsub(' ','%20',q)
  Sys.sleep(delay)
  tryCatch({
    JSONresponse = basicTextGatherer()
    curlPerform(url = q, writefunction = JSONresponse$update)
    glc = fromJSON(JSONresponse$value())
    numresults = glc$numResults
    if (numresults > 0){
      rlist <- list()
      for (i in 1:numresults) {
        rlist[[i]] <- glc2df(glc, i)
      }
      rdf <- bind_rows(rlist)
    } else {
      rdf <- data.frame(glcRank=1,
                        glcLongitude=NA,
                        glcLatitude=NA,
                        glcPrecision=NA,
                        glcScore=NA,
                        glcParsepattern=NA,
                        glcUncert=NA,
                        glcPoly=NA,
                        stringsAsFactors=FALSE)
    }
    return(rdf)
    
  }, error = function(err) 
  {
    glcRank  = 0
    glcLongitude = NA
    glcLatitude = NA
    glcPrecision = "ERROR GETTING JSON"
    glcScore = 0
    glcParsepattern = NA
    glcUncert = NA
    glcPoly = NA
    return(data.frame(glcRank,glcLongitude, glcLatitude, glcPrecision,
                      glcScore,glcParsepattern,glcUncert,glcPoly))
  })
}

 td <- ttc[11,]
 tgeo <- getLocation(td$country, td$verbatim_location, td$state_province, td$county)
