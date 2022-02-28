rm(list = ls())
library(pacman)
library(RSQLite)
p_load(data.table,lubridate,magrittr)
con <- dbConnect(RSQLite::SQLite(), "call_report_db")
dbListFields(con, "call_report_data")
tops.vals <- dbGetQuery(con, 'SELECT * from call_report_data limit 5')
# tops.vals
flds_names <- dbGetQuery(con, 'SELECT distinct V1 FROM call_report_data')
write.csv(flds_names,"All Fields for Call Reports.csv")

collect.strings <- function(string.list, str){
  return(string.list[grepl(pattern = str,x = string.list)   ])}

gen.query <- function(str.val){
  for.query <- paste("SELECT * from call_report_data where V1='",str.val,"'",sep = "")
  return(  for.query       )}
# Multifamily example:

mf.strings <- collect.strings(string.list = flds_names$V1, str = "R.E. LOANS MULTI-FAMILY|LNS SECD BY MULTIFAMILY-PST DU 90DYS|LNS SECD BY MULTIFAMILY-NONACCRUAL|CHG-OFFS ON LNS SECD BY MULTI-FAMILY")
cc.strings <- collect.strings(string.list = flds_names$V1, str = "^CREDIT CARDS LOANS$|PAST DUE\\(>=90DAY\\)\\: CREDIT CARD LOANS|PAST DUE\\(NONACCR\\)\\: CREDIT CARD LOANS|CHARGE-OFFS ON: CREDIT CARDS LOANS")
ci.strings <- collect.strings(string.list = flds_names$V1, str ="^C&I LOANS$|PAST DUE \\(>=90 DAYS\\)\\: C&I LOANS|CHARGE-OFFS ON C&I LOANS|PAST DUE \\(NONACCRUAL\\)\\:C&I LOANS"    )
agri.strings <- collect.strings(string.list = flds_names$V1, str = "R.E. LOANS-FARMLAND|LNS SECD BY FARMLAND-PAST DUE 90DYS|CHG-OFFS ON LNS SECURED BY FARMLAND|LNS SECD BY NONFARM-NONACCRUAL")
single_fam.strings <- collect.strings(string.list = flds_names$V1, str = "ALL OTH LNS,1-4FMLY-PAS DU 90 DYS OR|CHG-OFFS OF ALL OTHR LNS SECD BY 1-4|^NONTRAD 1-4 FAM RESD LOANS$|ALL OTH LNS,1-4FMLY-NONACCRUAL|SEC  NONTRAD 1-4 FAM RESD LOANS")
 

aum.vals <- "QTLY AVG OF TOTAL LOANS"



data.query <- gen.query(c(  mf.strings,
                            cc.strings,
                            ci.strings ,
                            agri.strings,
                            single_fam.strings,
                            aum.vals))

get.queries <- lapply(X = data.query,FUN = function(x){ as.data.table(dbGetQuery(con, x ))  } ) %>% rbindlist
one.fam.subset <- get.queries[grepl(V1,pattern = "1-4") , ]
View(one.fam.subset)







get.queries[grepl(V1,pattern = "CREDIT CARD"),Type:= "Credit Card"]
get.queries[grepl(V1,pattern = "MULTI"),Type:= "Multifamily"]
get.queries[grepl(V1,pattern = "C&I"),Type:= "C&I"]
get.queries[grepl(V1,pattern = "1-4"),Type:= "1-4 Family Loans"]
get.queries[grepl(V1,pattern = "FARM"),Type:= "Farmland"]

get.queries[grepl(V1,pattern = "90"),Field:= "90 days past due"]
get.queries[grepl(V1,pattern = "NONACCR"),Field:= "Nonaccrual"]
get.queries[grepl(V1,pattern = "OFFS"),Field:= "Charge off"]
get.queries[!grepl(V1,pattern = "90|NONACCR|OFFS"),Field:= "Total loans"]

get.queries[grepl(V1,pattern = "1-4")&(!grepl(V1,pattern = "90|NONACCR|OFFS")), ]


collect.dates <- function(date.col){
  s1 <- gsub( x = date.col,
              pattern = "^.*RDS_Files\\/|_Results.*$",
              replacement = ""   )
  s2 <- mdy(s1)
  return(s2)}

get.queries[,value := as.numeric(value)]
get.queries[,Date := collect.dates(Name)]
field_data <- fread("field_vals.csv")[,V1:=NULL][,.SD[c( .N)], 
                                                 by=IDRSSD]
get.queries <- as.data.table(merge(x = get.queries ,
                                y = field_data,
                                by.x =  "IDRSSD" ,
                                by.y =  "IDRSSD"  )) 
unique.ids <- unique(get.queries$`Financial Institution State`)

lapply(X = unique.ids,
       FUN = function(x){
         cur.frame <- get.queries[`Financial Institution State` == x,] 
         saveRDS(object = cur.frame,file = paste("Call_Report_App/ID_files/",x,".RDS",sep = ""))})

saveRDS(object = unique(get.queries$Type),file = "Call_Report_App/Type_list.RDS")
 