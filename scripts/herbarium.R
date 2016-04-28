# code to read and examine EL REED herbarium collections data

library(dplyr)
library(ggplot2)


# read linked tables
ttc <- read.csv("../data/ttc.csv", sep="\t", quote="", stringsAsFactors=FALSE,
                na.strings=c("","NA"))
collections <- read.csv("../data/collections.csv", sep="\t", quote="",
                        stringsAsFactors=FALSE, na.strings=c("","NA"))
managed_area_types <-  read.csv("../data/managed_area_types.csv", sep="\t",
                                quote="", stringsAsFactors=FALSE,
                                na.strings=c("","NA"))

# Summary #
names(ttc)
nrow(ttc)

sum(!is.na(ttc$location))
sum(!is.na(ttc$verbatim_location))

noloc <- subset(ttc, is.na(location))

length(unique(ttc$AN_TTC))
# 9280 with accession numbers, so over 10,000 without.

## Collections by year ##
byear <- ttc %>% group_by(year) %>% summarize(count=length(year))
ggplot(aes(as.numeric(year), count), data=byear) + geom_line() +
  xlab("year") + ylab("# specimens collected")
ggsave("../results/collections_by_year.pdf")

## Collections by plant family ##
byfamily <- ttc %>% group_by(family) %>% summarize(count=length(year)) %>%
  slice(order(count, decreasing=TRUE))

ggplot(aes(family, count), data=byfamily[1:10,]) + geom_bar(stat="identity") +
  xlab("family") + ylab("# specimens collected")
ggsave("../results/collections_by_family.pdf")

## by state/province
bystate <- ttc %>% group_by(state_province) %>% summarize(count=length(year)) %>%
  slice(order(count, decreasing=TRUE))

ggplot(aes(state_province, count), data=bystate[1:10,]) + geom_bar(stat="identity") +
  xlab("state/province") + ylab("# specimens collected")
ggsave("../results/collections_by_state.pdf")

