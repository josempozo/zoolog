## Code to include the `zoologTaxonomy` as public variable

zoologTaxonomy <- read.csv2("inst/extdata/zoologTaxonomy.csv",
                            stringsAsFactors = FALSE)

usethis::use_data(zoologTaxonomy, overwrite = TRUE, version = 2)

