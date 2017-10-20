# script to ready ttc database for import into symbiota
library(stringr)

camel_case <- function(x){ #function for camel case
  capit <- function(x) paste0(toupper(substring(x, 1, 1)), substring(x, 2, nchar(x)))
  s <- strsplit(x, "_", fixed=TRUE)
  res <- sapply(s, function(x) paste(capit(x), collapse=""))
  substr(res, 1,1) <- tolower(substr(res, 1, 1))
  return(res)
}


source("./read_data.R")


# some slight cleaning

# remove all NA rows
#ttc  <- ttc %>% filter(rowSums(is.na(.)) != ncol(.))


#complete status field and clean up TTC_AN
ttc <- mutate(ttc,
              processing_status = ifelse(is.na(processing_status),
                                         "unchecked",
                                         processing_status),
              AN_TTC = ifelse(AN_TTC=="000000" | AN_TTC=="sn",
                              NA,
                              paste("AN_TTC", AN_TTC, sep=":"))
              )



# remove status == "free"
ttc <- filter(ttc, !(processing_status == "free" | processing_status=="canceled" | processing_status=="missing"))

# order by cabinet before assigning barcodes
ttc <- left_join(ttc, groups)
ttc <- ttc %>% arrange(order, family, genus, species, infra_rank_name)

# move AN_TTC to other_catalog_number
ttc <- ttc %>% 
  mutate(other_catalog_numbers = paste(str_replace_na(AN_TTC, ""),
                                      str_replace_na(other_catalog_numbers, ""),
                                      sep= "|"),
         other_catalog_numbers = str_replace(other_catalog_numbers, "\\|$", "")) %>%
  select(-order, -group, -AN_TTC)


# assign barcode catalog num
ttc <- mutate(ttc, catalog_number = sprintf("TTC%06d", 1:nrow(ttc))) 

# change column names to camel case as Darwin Core
names(ttc) <- camel_case(names(ttc))
write.table(ttc, "../data/ttc.csv", sep="\t", quote=FALSE, row.names=FALSE, na="")




