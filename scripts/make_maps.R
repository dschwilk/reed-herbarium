#library(rgdal)
#library(sp)
library(ggplot2)
library(ggmap)
library(scales)


source("read_data.R")

## Maps ###


#temp <- filter(coords, glcPrecision=="High")


texas <- filter(ttc, stateProvince=="Texas")


# googlemap
txmap <- get_map(geocode("Texas"), zoom=6)

m <- ggmap(txmap)
m + geom_point(aes(x=decimalLongitude,y=decimalLatitude), size=0.9,
               alpha=0.8, data=ttc)
ggsave("../results/tx_map.png")


# USA
# googlemap
usa_center = as.numeric(geocode("United States"))
usa_map = get_googlemap(center=usa_center, scale=2, zoom=4)

m <- ggmap(usa_map)
m
m + geom_point(aes(x=decimalLongitude,y=decimalLatitude), size=0.5,
               alpha=0.8, data=ttc)


ggsave("../results/usa_map.png")
