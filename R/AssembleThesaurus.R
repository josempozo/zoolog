AssembleThesaurus <- function(
    thesaurus.db,
    combination = names(thesaurus.db)
)
{
  if(!inherits(thesaurus.db, "thesaurusLanguageSet")) return(thesaurus.db)

  assembledThesaurus <- Thesaurus0(list(), attributes(thesaurus.db))

  nonPresentLanguages <- setdiff(combination, names(thesaurus.db))
  if(length(nonPresentLanguages) > 0)
  {
    warning("The requested language",
            FormatListOfNames(nonPresentLanguages,
                              preMessage = c("", "s"),
                              postMessage = c("is", "are")),
            " not present.")
    combination <- setdiff(combination, nonPresentLanguages)
  }
  errorMessage <- ""
  includedLanguages <- c()
  for(language in combination)
  {
    assembledThesaurus <- tryCatch(
      AddToThesaurus(assembledThesaurus, thesaurus.db[[language]]),
      error = function(e) {
        errorMessage <<- strsplit(as.character(e), "\n")[[1]][2]
        return(FALSE) }
    )
    if(isFALSE(assembledThesaurus))
      stop("Language ", language,
           " incompatible with some previous language:\n    ",
           FormatListOfNames(includedLanguages, conjunction = "or"),
           ".\n", errorMessage)
    includedLanguages <- c(includedLanguages, language)
  }
  return(assembledThesaurus)
}

AssembleThesaurusSet <- function(
  thesaurusSet.db,
  combination = GetAvailableLanguages(thesaurusSet.db)
)
{
  ThesaurusSet(lapply(thesaurusSet.db, AssembleThesaurus, combination),
               attr(thesaurusSet.db, "applyToColNames"),
               attr(thesaurusSet.db, "applyToColValues"),
               fileName = MarkFileNamesWhenAssembled(thesaurusSet.db))
}

MarkFileNamesWhenAssembled <- function(thesaurusSet.db)
{
  structuredByLanguage <- as.logical(
    sapply(thesaurusSet.db, inherits, "thesaurusLanguageSet")
  )
  fileNames <- mapply(
    function(x, y)
      paste0(tools::file_path_sans_ext(x), "(Assembled)"[y],
             ".", tools::file_ext(x)),
    attr(thesaurusSet.db, "fileName"), structuredByLanguage,
    USE.NAMES = FALSE
  )
  return(fileNames)
}
