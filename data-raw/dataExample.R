## code to prepare `dataExample` dataset goes here

source("data-raw/lcCollateC.R")
lcCollateC({
  dataExample <- read.csv2("inst/extdata/dataExample.csv",
                           quote = "\"", na = "",
                           header = TRUE, stringsAsFactors = TRUE,
                           fileEncoding = "UTF-8"
  )
})

usethis::use_data(dataExample, overwrite = TRUE)

