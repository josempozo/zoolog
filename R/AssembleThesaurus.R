AssembleThesaurus <- function(
    thesaurus.db,
    combination = names(thesaurus.db)
)
{
  if(!isTRUE(attr(thesaurus.db, "structuredByLanguage"))) return(thesaurus.db)

  assembledThesaurus <- NewThesaurus()
  for(attrib in c("caseSensitive", "accentSensitive", "punctuationSensitive",
                  "wordOrderSensitive", "description"))
    attr(assembledThesaurus, attrib) <- attr(thesaurus.db, attrib)

  nonPresentLanguages <- setdiff(combination, names(thesaurus.db))
  if(length(nonPresentLanguages) > 0)
  {
    warning(paste0("The requested language",
                   FormatListOfNames(nonPresentLanguages, c("\"", "\""),
                                     preMessage = c("", "s"),
                                     postMessage = c("is", "are")),
                   " not present."))
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
      stop(paste0("Language ", language,
                  " incompatible with some previous language:\n    ",
                  FormatListOfNames(includedLanguages, c("\"", "\""),
                                    conjunction = "or"), ".\n",
                  errorMessage))
    includedLanguages <- c(includedLanguages, language)
  }
  return(assembledThesaurus)
}

AssembleThesaurusSet <- function(
  thesaurusSet.db,
  combination = GetAvailableLanguages(thesaurusSet.db)
)
{
  thesaurusSet <- lapply(thesaurusSet.db, AssembleThesaurus, combination)
  for(attrib in c("applyToColNames", "applyToColValues"))
    attr(thesaurusSet, attrib) <- attr(thesaurusSet.db, attrib)

  structuredByLanguage <- lapply(thesaurusSet.db, attr, "structuredByLanguage")
  attr(thesaurusSet, "fileName") <- MarkFileNamesWhenAssembled(thesaurusSet.db)
  return(thesaurusSet)
}

MarkFileNamesWhenAssembled <- function(thesaurusSet.db)
{
  structuredByLanguage <- lapply(thesaurusSet.db, attr, "structuredByLanguage")
  fileNames <- mapply(
    function(x, y)
      paste0(tools::file_path_sans_ext(x), "(Assembled)"[y],
             ".", tools::file_ext(x)),
    attr(thesaurusSet.db, "fileName"), structuredByLanguage,
    USE.NAMES = FALSE
  )
  return(fileNames)
}
