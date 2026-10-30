## Code to prepare `zoologThesaurus` dataset goes here

zoologThesaurusByLanguage0 <- ReadThesaurusSet("inst/extdata/zoologThesaurusSet.json")

usethis::use_data(zoologThesaurusByLanguage0, overwrite = TRUE, version = 2,
                  internal = TRUE)


## Generate template for the current thesaurus set. This automatizes the
## updating of the list of term categories.
MakeThesaurusSetTemplate <- function(thes)
{
  measureId <- which(names(thes) == "measure")
  thes[[measureId]] <- NULL
  attr(thes, "description") <- NULL
  attr(thes, "applyToColNames") <- attr(thes, "applyToColNames")[-measureId]
  attr(thes, "applyToColValues") <- attr(thes, "applyToColValues")[-measureId]
  attr(thes, "fileName") <- paste0(attr(thes, "fileName")[-measureId], "_XXXX")
  thes[] <- lapply(thes[], MakeThesaurusTemplate)
  return(thes)
}

MakeThesaurusTemplate <- function(thes)
{
  sensitiveness <- attr(thes, "sensitiveness")
  thes <- thes$Base
  attr(thes, "sensitiveness") <- sensitiveness
  attr(thes, "description") <- attr(thes, "description")[1]
  thes[] <- lapply(thes[], function(x) character(0))
  thes[[1]] <- c(paste0("LanguageStandardTermFor",
                        zoolog:::ToCamelCase(names(thes)[1])),
                 "AlternativeTerm1", "AlternativeTerm2")
  return(thes)
}

thesaurusTemplate <- MakeThesaurusSetTemplate(zoologThesaurusByLanguage0)
fileStem <- "inst/extdata/thesaurusTemplateForNewLanguage/thesaurusSet_XXXX"
WriteThesaurusSet(thesaurusTemplate, paste0(fileStem, ".json"))
WriteThesaurusSet(thesaurusTemplate, paste0(fileStem, ".csv"))
