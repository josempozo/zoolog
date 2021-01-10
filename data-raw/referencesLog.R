## Code to prepare `referencesLog` dataset goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  referencesLog <- read.csv2("inst/extdata/referencesLog.csv",
                           quote = "\"", na = "",
                           header = TRUE, stringsAsFactors = TRUE,
                           fileEncoding = "UTF-8"
  )
})

usethis::use_data(referencesLog, overwrite = TRUE)
