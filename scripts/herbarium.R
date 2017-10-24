# code to read and examine EL REED herbarium collections data

library(dplyr)
library(ggplot2)

source("./read_data.R")

# Summary #
names(ttc)
nrow(ttc)

# number with status=="v"
nrow(subset(ttc, processingStatus=="v"))
nrow(subset(ttc, !is.na(processingStatus)))

# Number reviewed and confirmed:
ttc.reviewed <- ttc %>% subset(!is.na(dateReviewed))
nrow(ttc.reviewed)

## groups
unique(ttc$category)

## Collections by year ##
byear <- ttc %>% group_by(year) %>% summarize(count=length(year))
ggplot(aes(as.numeric(year), count), data=byear) + geom_line() +
  xlab("year") + ylab("# specimens collected")
ggsave("../results/collections_by_year.png")

## Collections by plant family ##
byfamily <- ttc %>% group_by(family) %>% summarize(count=length(year)) %>%
  slice(order(count, decreasing=TRUE))

ggplot(aes(family, count), data=byfamily[1:10,]) + geom_bar(stat="identity") +
  xlab("family") + ylab("# specimens collected")
ggsave("../results/collections_by_family.png")

## by state/province
bystate <- ttc %>% group_by(stateProvince) %>% summarize(count=length(year)) %>%
  slice(order(count, decreasing=TRUE))

ggplot(aes(stateProvince, count), data=bystate[1:10,]) + geom_bar(stat="identity") +
  xlab("state/province") + ylab("# specimens collected")
ggsave("../results/collections_by_state.png")

ggplot(bystate[1:10,] ,aes(stateProvince, count)) + geom_bar(stat="identity") +
  xlab("state/province") + ylab("# specimens collected")




## by country
bycountry <- ttc %>% group_by(country) %>% summarize(count=length(year)) %>%
  slice(order(count, decreasing=TRUE))

ggplot(aes(country, count), data=bycountry) + geom_bar(stat="identity") +
    xlab("country") + ylab("# specimens collected") +
    scale_y_log10()
ggsave("../results/collections_by_country.png")



