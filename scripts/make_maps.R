#library(rgdal)
#library(sp)
library(ggplot2)
library(ggmap)
library(scales)


source("read_data.R")
## Maps ###
coords <- read.csv("../data/coords.csv", stringsAsFactors=FALSE)


# take first found geolocation
coords <- coords %>% group_by(index) %>% slice(1)

coords <- coords %>% filter(!is.na(glcLongitude)) %>%
    mutate(x=glcLongitude, y=glcLatitude)


temp <- filter(coords, glcPrecision=="High")


ttc$index <- row.names(ttc)
ttc.coords <- merge(ttc, coords)
nrow(ttc.coords)



texas <- subset(ttc.coords, state_province=="Texas")



# googlemap
txmap <- get_map(geocode("Texas"), zoom=6)

m <- ggmap(txmap)
m + geom_point(aes(x=glcLongitude,y=glcLatitude, color=year), size=0.9,
               alpha=0.8, data=ttc.coords)
ggsave("../results/tx_map.png")


# USA
# googlemap
usa_center = as.numeric(geocode("United States"))
usa_map = get_googlemap(center=usa_center, scale=2, zoom=4)

m <- ggmap(usa_map)
m
m + geom_point(aes(x=glcLongitude,y=glcLatitude, color=year), size=0.5,
               alpha=0.8, data=ttc.coords)


ggsave("../results/usa_map.png")
