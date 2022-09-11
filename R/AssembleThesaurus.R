AssembleThesaurus <- function(
    thesaurus.db,
    combination = names(thesaurus.db)
)
{
  assembledThesaurus <- NewThesaurus(
    attr(thesaurus.db, "caseSensitive"),
    attr(thesaurus.db, "accentSensitive"),
    attr(thesaurus.db, "punctuationSensitive")
  )
  nonPresentLanguages <- setdiff(combination, names(thesaurus.db))
  if(length(nonPresentLanguages) > 0)
  {
    warning(paste0("The requested languages ",
                   paste(nonPresentLanguages, collapse = ", "),
                   " are not present."))
    combination <- setdiff(combination, nonPresentLanguages)
  }
  errorMessage <- ""
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
                  paste(combination[seq_len(which(combination == language)-1)],
                        collapse = ", "), ".\n",
                  errorMessage))
  }
  return(assembledThesaurus)
}

AssembleThesaurusSet <- function(
  thesaurusSet.db,
  combination = GetAvailableLanguages(thesaurusSet.db)
)
{
  structuredByLanguage <- attr(thesaurusSet.db, "structuredByLanguage")

  thesaurusSet <- mapply(
    function(thesaurus.db, combination, structuredByLanguage)
    {
      if(!structuredByLanguage) return(thesaurus.db)
      AssembleThesaurus(thesaurus.db, combination)
    },
    thesaurusSet.db, list(combination), structuredByLanguage
  )
  for(attrib in c("applyToColNames", "applyToColValues", "fileName"))
    attr(thesaurusSet, attrib) <- attr(thesaurusSet.db, attrib)
  return(thesaurusSet)
}
