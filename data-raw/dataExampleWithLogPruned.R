## code to prepare `dataExampleWithLogPruned` dataset goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  dataExampleWithLogPruned <- RemoveNACases(dataExampleWithLog)
})

write.csv2(dataExampleWithLogPruned,
           "inst/extdata/dataExampleWithLogPruned.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")

usethis::use_data(dataExampleWithLogPruned, overwrite = TRUE)
