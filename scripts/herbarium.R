# code to read and examine EL REED herbarium collections data

library(dplyr)
library(ggplot2)

source("./read_data.R")

# Summary #
names(ttc)
nrow(ttc)

# number with status=="v"
nrow(subset(ttc, status=="v"))

nrow(subset(ttc, !is.na(status)))

length(unique(ttc$AN_TTC))

# lets look just at entries with an AN
ttc.an <- subset(ttc, !is.na(AN_TTC) & AN_TTC!="000000")
nrow(ttc.an)

# Number reviewed and confirmed:
ttc.reviewed <- ttc.an %>% subset(!is.na(date_reviewed))
nrow(ttc.reviewed)

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

## by country
bycountry <- ttc %>% group_by(country) %>% summarize(count=length(year)) %>%
  slice(order(count, decreasing=TRUE))

ggplot(aes(country, count), data=bycountry) + geom_bar(stat="identity") +
    xlab("country") + ylab("# specimens collected") +
    scale_y_log10()
ggsave("../results/collections_by_country.pdf")


# lets look just at entries with an AN
ttc.an <- subset(ttc, !is.na(AN_TTC) & AN_TTC!="000000")
nrow(ttc.an)
     
state_mex <- subset(ttc, state_province=="Mexico") %>% select(AN_TTC, family, genus, species, country, state_province)

subset(ttc, country=="USA" & state_province=="Mexico")

ttc.reviewed <- ttc.an %>% filter(!is.na(date_reviewed))
# subset(ttc.reviewed, country=="USA" & state_province=="Mexico")


ggplot(aes(state_province, count), data=bystate[1:10,]) + geom_bar(stat="identity") +
  xlab("state/province") + ylab("# specimens collected")


