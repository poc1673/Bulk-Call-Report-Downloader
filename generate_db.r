rm(list = ls())
library(pacman)
p_load(data.table,magrittr,DBI)
library(RSQLite)
test = iris


# Initialize database with first entry:
con <- dbConnect(RSQLite::SQLite(), "Call_Report_App/call_report_db")
dbWriteTable(con, "iris_test", iris)
# dbListTables(con)
# dbListFields(con, "iris_test")
dbWriteTable(con, "iris_test", iris,append = T, overwrite  = F)
dbGetQuery(con, 'SELECT * FROM iris_test')


cur.file <- readRDS(file = "Call_Report_App/Production Files/Call Report Subset.RDS")
dbWriteTable(con, "call_report_data", cur.file)
# dbListTables(con)
# dbListFields(con, "call_report_data")
rm(cur.file)

cur.file <- readRDS(file = "Call_Report_App/Production Files/Call Report Subset 2.RDS")
dbWriteTable(con, "call_report_data", cur.file,append = T, overwrite  = F)
# dbListTables(con)
# dbListFields(con, "call_report_data")
rm(cur.file)


cur.file <- readRDS(file = "Call_Report_App/Production Files/Call Report Subset 3.RDS")
dbWriteTable(con, "call_report_data", cur.file,append = T, overwrite  = F)
# dbListTables(con)
# dbListFields(con, "call_report_data")
rm(cur.file)


cur.file <- readRDS(file = "Call_Report_App/Production Files/Call Report Subset 4.RDS")
dbWriteTable(con, "call_report_data", cur.file,append = T, overwrite  = F)
# dbListTables(con)
# dbListFields(con, "call_report_data")
rm(cur.file)

