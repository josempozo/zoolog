## Code to prepare the three reference datasets goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  referenceNietoDavisAlbarella <- read.csv2("inst/extdata/referenceNietoDavisAlbarella.csv",
                             quote = "\"", na = "",
                             header = TRUE, stringsAsFactors = TRUE,
                             fileEncoding = "UTF-8")
  referenceBasel <- read.csv2("inst/extdata/referenceBasel.csv",
                               quote = "\"", na = "",
                               header = TRUE, stringsAsFactors = TRUE,
                               fileEncoding = "UTF-8")
  referenceCombi <- read.csv2("inst/extdata/referenceCombi.csv",
                              quote = "\"", na = "",
                              header = TRUE, stringsAsFactors = TRUE,
                              fileEncoding = "UTF-8")
})

usethis::use_data(referenceNietoDavisAlbarella, overwrite = TRUE)
usethis::use_data(referenceBasel, overwrite = TRUE)
usethis::use_data(referenceCombi, overwrite = TRUE)
