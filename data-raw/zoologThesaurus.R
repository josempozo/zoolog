## Code to prepare `zoologThesaurus` dataset goes here

zoologThesaurus <- ReadThesaurusSet("inst/extdata/zoologThesaurusSet.csv")

usethis::use_data(zoologThesaurus, overwrite = TRUE, version = 2)

