AssembleThesaurus <- function(
    thesaurus.db,
    combination = names(thesaurus.db)
)
{
  if(!isTRUE(attr(thesaurus.db, "structuredByLanguage"))) return(thesaurus.db)

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
  thesaurusSet <- mapply(AssembleThesaurus, thesaurusSet.db, list(combination))
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
