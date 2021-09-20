## Code to prepare the reference datasets goes here

currentVariables <- ls()
#######

source("data-raw/lcCollateC.R")
lcCollateC({
  source("R/ReadReferenceDatabase.R")
  source("R/InCategory.R")
  source("R/StandardizeNomenclature.R")
  source("R/ThesaurusManagement.R")
  source("R/AssembleReference.R")

  referencesDatabase <- ReadReferenceDatabase(
    "inst/extdata/referencesDataBase.csv")

  referenceSets <- read.csv2("inst/extdata/referenceSets.csv",
                             quote = "\"", na.strings = "",
                             header = TRUE, row.names = 1,
                             stringsAsFactors = FALSE,
                             fileEncoding = "UTF-8",
                             check.names = FALSE)

  reference <- apply(referenceSets, 1, AssembleReference,
                     ref.db = referencesDatabase,
                     thesaurus = NULL)
})

usethis::use_data(reference, overwrite = TRUE, version = 2)
usethis::use_data(referenceSets, overwrite = TRUE, version = 2)
usethis::use_data(referencesDatabase, overwrite = TRUE, version = 2)

########
variablesToRemove <- setdiff(c("variablesToRemove", ls()), currentVariables)
eval(parse(text = paste0("rm(list = ",
                         paste(deparse(variablesToRemove), collapse = ""),
                         ")")))

