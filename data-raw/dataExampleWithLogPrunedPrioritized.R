## code to prepare `dataExampleWithLogPrunedPrioritized` dataset goes here

dataExampleWithLogPrunedPrioritized <- PrioritizeLogs(dataExampleWithLogPruned)

write.csv2(dataExampleWithLogPrunedPrioritized,
           "inst/extdata/dataExampleWithLogPrunedPrioritized.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")

usethis::use_data(dataExampleWithLogPrunedPrioritized, overwrite = TRUE)
