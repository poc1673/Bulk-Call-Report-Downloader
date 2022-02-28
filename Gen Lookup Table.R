# This script generates a spreadsheet containing the following information:
# [1] RSSD - the Id
# [2] State - The State
# [3] Zip - The zip code
# [4] Name - The institution name



rm(list = ls())
library(pacman)
p_load(data.table,lubridate,magrittr)
prod.files <- list.files(path = "FFIEC_Data/RDS_Files/",full.names = T)
a <- readRDS(file = prod.files[1])
 
get.fields <- function(path.val){
  cur.vals <- readRDS(file = path.val)
  cur.vals <- unique(cur.vals[,c("IDRSSD","Financial Institution Name"   ,"Financial Institution State" ,"Financial Institution Zip Code" ), with = F])
  gc()
  return(as.data.table(cur.vals))}


field.vals <- lapply(X = prod.files ,FUN = get.fields) %>% rbindlist %>% unique

write.csv(x = field.vals,file = "field_vals.csv")


