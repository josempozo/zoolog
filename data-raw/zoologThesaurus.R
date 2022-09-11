## Code to prepare `zoologThesaurus` dataset goes here

zoologThesaurusByLanguage <- ReadThesaurusSet("LanguageStructuredThesauri/zoologThesaurusSet.csv")

usethis::use_data(zoologThesaurusByLanguage, overwrite = TRUE, version = 2,
                  internal = TRUE)

