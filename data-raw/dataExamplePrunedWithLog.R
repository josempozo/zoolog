## code to prepare `dataExamplePrunedWithLog` dataset goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  dataExamplePrunedWithLog <- LogRatios(dataExamplePruned)
})
write.csv2(dataExamplePrunedWithLog,
           "inst/extdata/dataExamplePrunedWithLog.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")

usethis::use_data(dataExamplePrunedWithLog, overwrite = TRUE)
