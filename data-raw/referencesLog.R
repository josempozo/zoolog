## code to prepare `referencesLog` dataset goes here

referencesLog <- read.csv2("inst/extdata/referencesLog.csv",
                           quote = "\"", na = "",
                           header = TRUE, stringsAsFactors = TRUE,
)

usethis::use_data(referencesLog, overwrite = TRUE)
