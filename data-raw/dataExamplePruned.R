## code to prepare `dataExamplePruned` dataset goes here

source("data-raw/lcCollateC.R")
exampleMeasuresName <- colnames(dataExample)[22:35]
lcCollateC({
  dataExamplePruned <- RemoveNACases(dataExample,
                                     measuresName = exampleMeasuresName)
})

write.csv2(dataExamplePruned,	"inst/extdata/dataExamplePruned.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")

usethis::use_data(dataExamplePruned, overwrite = TRUE)

