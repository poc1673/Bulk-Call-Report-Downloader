rm(list = ls())
library(pacman)
p_load(data.table,lubridate,magrittr)
source("merge_call_reports.R")
# Steps:
# 1. Load in the MDRM code book for reference.
# 2. Load in all of the call schedule data points
#   i) Find out if the size of them is feasible enough to fit in memory
# 3. Reformat the data from step 2 into a workable format
# 4. Fit descriptions for the banks to the call report data.
# 5. Fit the descriptions from the MDRM codebook onto the data.

# [1]  --------------------------------------------------------------------
mdrm <- fread("MDRM/MDRM_CSV.csv",skip = 1,header = T)

# [2] ---------------------------------------------------------------------
# Get list of all files in the directory matching the call schedule formatting:
call.files <- list.files(path= "FFIEC_Data/",pattern = "CDR Call.*txt",full.names = T)

# Get the unique date type for each loan:
unique.dates <- gsub(pattern = "\\(.*\\)",replacement = "", x = call.files)
unique.dates <- gsub(pattern = "^.* |\\.txt",replacement = "", x = unique.dates) %>% unique
# Subset the file names based on the date:
subsetted.paths <- lapply(unique.dates, FUN = function(x){
  call.files[grepl(pattern = x,x = call.files)] })

# Now: Generate the cleaned data for each data type:
# 
# loaded.call.files <- lapply(X = subsetted.paths[[1]][grepl(x = subsetted.paths[[1]] , 
#                                                            pattern = "CDR Call Schedule")],
#                             function(x){  fread(x )})
# # i)
# # The size is about 300 mb
# # object.size(loaded.call.files)/1e6
# # [3] ---------------------------------------------------------------------
# # Steps:
# # a. Load the data()
# # b. Get the names associated with each column.
# # c. Remove the first line of the file.
# # d. Melt the data without first lines.
# # e. Merge the actual names to the melted data frame.
# call.report.details <- merge.call.reports(loaded.call.files) %>% rbindlist
# call.report.details$IDRSSD <- as.numeric(call.report.details$IDRSSD)
# # [4] ---------------------------------------------------------------------
# port <- fread(subsetted.paths[[1]][grepl(x = subsetted.paths[[1]] , 
#                                          pattern = "POR")])
# updated.data <- merge(x = call.report.details,y = port, by.x = "IDRSSD",by.y = "IDRSSD",all.x =T)
# saveRDS(object = updated.data,file = paste("FFIEC_Data/RDS_Files/",unique.dates[1] ,"_Results.RDS" ,sep = ""))


# [5] Run in a loop:
# length(unique.dates    )
sapply(X = 4:length(unique.dates    ),
       FUN = function(x){
         print(unique.dates[x])
         loaded.call.files <- lapply(X = subsetted.paths[[x]][grepl(x = subsetted.paths[[x]] , 
                                                                    pattern = "CDR Call Schedule")],
                                     function(x){  fread(x )})
         
         call.report.details <- merge.call.reports(loaded.call.files) %>% rbindlist
         call.report.details$IDRSSD <- as.numeric(call.report.details$IDRSSD)
         port <- fread(subsetted.paths[[x]][grepl(x = subsetted.paths[[x]] , 
                                                  pattern = "POR")])
         updated.data <- merge(x = call.report.details,y = port, by.x = "IDRSSD",by.y = "IDRSSD",all.x =T)
         saveRDS(object = updated.data,file = paste("FFIEC_Data/RDS_Files/",unique.dates[x] ,"_Results.RDS" ,sep = ""))       }       )




# CHARGE-OFFS
# PAST DUE(
#   PAS DU
# NONACCRUAL

# 
# .[grepl(pattern = "CHARGE-OFFS|PAST DUE(|PAS DU|NONACCRUAL",x = V1)]
# 
# 
# 
# rowname.vals <- c("ALL OTHER LOANS","ALL OTHER LOANS-NONACCRUAL","ALL OTHER LOANS-PAST DU 30-89 DAYS","ALL OTHER LOANS-PAST DU 90 DYS OR MO","C&I LNS TO NONUS ADR,NONACCRUAL","C&I LNS TO NONUS ADR,PAS DU 30-89 DY","C&I LNS TO NONUS ADR,PAS DU 90 DYS","C&I LNS TO US ADDRS,NONACCRUAL","C&I LNS TO US ADDRS,PAS DU 30-89 DYS","C&I LNS TO US ADDRS,PAS DU 90 DYS OR","C&I LOANS","C&I LOANS, NON-U.S. ADDRESSEES","C&I LOANS, U.S. ADDRESSEES","CHARGE-OFFS ON C&I LOANS","CHARGE-OFFS ON LOANS TO FARMERS","CHARGE-OFFS ON: CREDIT CARDS LOANS","CHARGE-OFFS ON: OTHER INDIV LOANS","CHG-OFF ON LOANS TO DEPOSITORY INST","CHG-OFFS ON ALL OTHER LOANS","CHG-OFFS ON C&I LNS-NON-U.S. ADDRES","CHG-OFFS ON C&I LNS-U.S. ADDRESSES","CHG-OFFS ON CONSTRCTN&LAND DEVLPMT","CHG-OFFS ON LNS SECD BY MULTI-FAMILY","CHG-OFFS ON LNS SECD BY NONFARM NONR","CHG-OFFS ON LNS SECURED BY FARMLAND","CHG-OFFS ON LNS TO FGN GOVTS & INST","CHRG-OFF LEASE FNC RCVBL NON US ADDR","CHRG-OFF LEASE FNC RCVBL US ADDR","CHRG-OFF ON LN AMTS,ETC:CRDT CRD RCV","CHRG-OFF ON LOANS IN FOREIGN OFFICES","CHRG-OFFS CLSD-END:SECURED 1ST LIENS","CHRG-OFFS CLSD-END:SECURED JR LIENS","CHRG-OFFS ON ALLWNCE FOR L&L LOSSES","CHRG-OFFS ON ASSETS SLD,ETC:ALL OTHR","CHRG-OFFS ON ASSETS SLD,ETC:AUTO LNS","CHRG-OFFS ON ASSETS SLD,ETC:CMRL&IND","CHRG-OFFS ON ASSETS SLD,ETC:OTH CSMR","CHRG-OFFS ON ASSETS SOLD ETC HM EQTY","CHRG-OFFS ON ASSETS SOLD,ETC:1-4 FAM","CHRG-OFFS ON ASTS SOLD,ETC:CRDT CARD","CHRG-OFFS ON LN AMTS,ETC:CMMRL&INDUS","CHRG-OFFS ON LN AMTS,ETC:HM EQ LINES","CHRGE-OFFS ON INS TO FOREIGN BANKS","CITY NAME","CLSD-ED LNS:SCRD JR LIENS-NONACCRUAL","CLSD-ED LNS:SEC 1 LIENS PA DU 30-89","CLSD-ED LNS:SEC 1 LIENS PA DU 90 MOR","CLSD-ED LNS:SEC JR LIENS PA DU 30-89","CLSD-ED LNS:SEC JR LIENS PA DU 90 MO","COMMCL RE,ETC.-NONACCRUAL","COMMCL RE,ETC.-PAST DUE 30-89 DYS,AG","COMMCL RE,ETC.-PAST DUE 90DYS OR MOR","CONSTRUCTION LNS-NONACCRUAL","CONSTRUCTION LNS-PAST DUE 30-89 DAYS","CONSTRUCTN LNS-PAST DUE 90DYS OR MOR","CREDIT CARDS LOANS","GUAR PORTN OF LNS&LS-NONACCRUAL","LN TO FRMERS,PAST 30-89 DYS, ACCRUIN","LN TO FRMERS,PAST 90 OR MORE,ACCRUIN","LNS SECD BY FARMLAND-NONACCRUAL","LNS SECD BY FARMLAND-PAST DUE 30-89","LNS SECD BY FARMLAND-PAST DUE 90DYS","LNS SECD BY MULTIFAMILY-NONACCRUAL","LNS SECD BY NONFARM-NONACCRUAL","LNS SECD BY NONFARM-PAST DU 30-89DYS","LNS SECD BY NONFARM-PAST DU 90DYS OR","LNS SECD BY RE TO NONUS ADR,PAS DU30","LNS SECD BY RE TO NONUS ADR,PAS DU90","LNS TO FGN GOV,ETC.-NONACCRUAL","LNS TO FGN GOV,ETC.-PAS DU 30-89 DYS","LNS TO FGN GOV,ETC.-PAS DU 90 DYS OR","LNS TO FOREIGN BKS-NONACCRUAL","LNS TO FOREIGN BKS-PAST DU 30-89 DYS","LNS TO FOREIGN BKS-PAST DU 90 DYS OR","LNS TO US BKS,ETC.-NONACCRUAL","LNS TO US BKS,ETC.-PAST DU 30-89 DYS","LNS TO US BKS,ETC.-PAST DU 90 DYS OR","LNS&LEASES WHLY GUAR-NONACCRUAL","LOANS TO FARMERS, NONACCRUAL","LSE FIN RECS OF NONUS ADR,PAS DU 90","LSE FIN RECS OF US ADDR,NONACCRUAL","LSE FIN RECS OF US ADDRS, PAST DUE 9","LSE FNC RECS OF US ADDRS,PAS DU 30","OTH ASSETS-PAST DUE 30-89 DYS, ACCRG","OTH ASSETS-PAST DUE 90DYS OR MOR,ACG","OTHER ASSETS-NONACCRUAL","OTHER LOANS","PAS DU LN AMTS,ETC:90 DYS/MOR-HM EQY","PAS DU LN AMTS:30-89 DYS ALL OTH LNS","PAS DU LN AMTS:30-89 DYS CML&IND LNS","PAS DU LN AMTS:90 DAYS/MORE 1-4 FAM","PAS DU LN AMTS:90 DYS/MOR CMMRL&IND","PAS DU LN AMTS:90 DYS/MOR CR CRD RCV","PAS DUE LN AMTS ETC 30-89 DYS HM EQY","PAS DUE LN AMTS,ETC:30-89 DYS CR CRD","PAS DUE LN AMTS,ETC:30-89DYS CML&IND","PAS DUE LN AMTS,ETC:90DYS/MO-CML&IND","PAS DUE LN AMTS,ETC:90DYS/MOR-CR CRD","PAS DUE LN AMTS:30-89 DYS AUTO LOANS","PAS DUE LN AMTS:30-89 DYS OT CSMR LN","PAS DUE LN AMTS:90 DYS/MOR ALL OTHER","PAS DUE LN AMTS:90 DYS/MOR HM EQY LN","PAS DUE LN AMTS:90 DYS/MOR OTH CNSMR","PAST DUE (>=90 DAYS): C&I LOANS","PAST DUE (>=90DAY): LOANS FGN OFFICE","PAST DUE (30-89 DAYS): C&I LOANS","PAST DUE (30-89DA): LOANS FGN OFFICE","PAST DUE (NONACCR): LOANS FGN OFFICE","PAST DUE (NONACCRUAL):C&I LOANS","PAST DUE LN AMTS:30-89 DYS FAMI RSDL","PAST DUE LN AMTS:90 DYS/MOR AUTO LNS","PAST DUE LOAN AMTS:30-89 DYS CR CARD","PAST DUE LOAN AMTS:30-89 DYS HM EQTY","PAST DUE(>=90DAY): CREDIT CARD LOANS","PAST DUE(>=90DAY): OTHER INDIV LOANS","PAST DUE(30-89DA): CREDIT CARD LOANS","PAST DUE(30-89DA): OTHER INDIV LOANS","PAST DUE(NONACCR): CREDIT CARD LOANS","PAST DUE(NONACCR): OTHER INDIV LOANS","R.E. LOANS MULTI-FAMILY","R.E. LOANS NON-FARM. NON-RES. PROP","R.E. LOANS-CONSTRUCTION & LAND DEV","R.E. LOANS-FARMLAND","REAL ESTATE LOANS, TOTAL","RECOV ON ALL OTHER LOANS","RECOV ON LOANS TO DEPOSITORY INST","RECOV ON LOANS TO U.S. DEPOSITORY IN","RECOV ON R.E. LOANS-NON U.S. ADDRESS","RECOVERIES ON C&I LOANS","RECOVERIES ON CREDIT CARDS LOANS","RECOVERIES ON LOANS TO FARMERS","RECOVERIES ON LOANS TO FOREIGN BANKS","RECOVERIES ON: OTHER INDIV LOANS","RECVRS ON LOANS IN FOREIGN OFFICES","REPLMT COST OF CONTRCTS-PAS DU 30-89","REPLMT COST OF CONTRCTS-PAS DU 90 DY","RESTRUCTURED LNS-NONACCRUAL","RESTRUCTURED LNS-PAST DUE 30-89 DAYS","RESTRUCTURED LNS-PAST DUE 90 DAYS OR","RVLVG,OPEN-END LNS-NONACCRUAL","RVLVG,OPEN-END LNS-PAST DU 30-89 DYS","RVLVG,OPEN-END LNS-PAST DU 90 DYS OR","STATE ABBREVIATION","ZIP CODE")

 