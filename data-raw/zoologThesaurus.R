## Code to prepare `zoologThesaurus` dataset goes here

zoologThesaurus <- ReadThesaurusSet("inst/extdata/zooLogThesaurusSet.csv")

usethis::use_data(zoologThesaurus, overwrite = TRUE)

