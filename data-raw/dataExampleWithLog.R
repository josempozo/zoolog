## code to prepare `dataExampleWithLog` dataset goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  dataExampleWithLog <- LogRatios(dataExample)
})

write.csv2(dataExampleWithLog,
           "inst/extdata/dataExampleWithLog.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")

usethis::use_data(dataExampleWithLog, overwrite = TRUE)
