## Code to prepare `zoologThesaurus` dataset goes here

zoologThesaurusByLanguage0 <- ReadThesaurusSet("inst/extdata/zoologThesaurusSet.json")

usethis::use_data(zoologThesaurusByLanguage0, overwrite = TRUE, version = 2,
                  internal = TRUE)

