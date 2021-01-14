## Code to prepare `referencesLog` dataset goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  referencesLog <- read.csv2("inst/extdata/referencesLog.csv",
                             quote = "\"", na = "",
                             header = TRUE, stringsAsFactors = TRUE,
                             fileEncoding = "UTF-8")
  referencesBasel <- read.csv2("inst/extdata/referencesBasel.csv",
                               quote = "\"", na = "",
                               header = TRUE, stringsAsFactors = TRUE,
                               fileEncoding = "UTF-8")
})

usethis::use_data(referencesLog, overwrite = TRUE)
usethis::use_data(referencesBasel, overwrite = TRUE)
