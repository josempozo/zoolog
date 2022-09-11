#' Active Languages
#'
#' Functions to get and activate the languages to be included in the thesauri.
#'
#' @param combination Something.
#'
#' @return
#' \code{AllAvailableLanguages} returns .
#'
#' \code{SetActiveLanguages} returns .
#'
#' \code{GetActiveLanguages} returns .
#'
#' @examples
#' ## Viewing all available :
#' AllAvailableLanguages()

#' @name ActiveLanguages

#' @rdname ActiveLanguages
#' @export
AllAvailableLanguages <- function()
{
  GetAvailableLanguages(zoologThesaurusByLanguage)
}

GetAvailableLanguages <- function(thesaurusSet.db)
{
  structuredByLanguage <- attr(thesaurusSet.db, "structuredByLanguage")
  languageNames <- c()
  for(thesaurus.db in thesaurusSet.db[structuredByLanguage])
  {
    languageNames <- union(languageNames, names(thesaurus.db))
  }
  return(languageNames)
}

#' @rdname ActiveLanguages
#' @export
SetActiveLanguages <- function(combination)
{
  notAvailableLanguages <- setdiff(combination, AllAvailableLanguages())
  if(length(notAvailableLanguages) > 0)
  {
    warning(paste0("The requested language ", notAvailableLanguages,
                   " is not available.", collapse = ".\n"))
    combination <- setdiff(combination, notAvailableLanguages)
  }
  assign("activeLanguages", combination, envir = internalEnvironment)
  assign("zoologThesaurus",
         AssembleThesaurusSet(zoologThesaurusByLanguage, combination),
         envir = internalEnvironment)
}

#' @rdname ActiveLanguages
#' @export
GetActiveLanguages <- function()
{
  get("activeLanguages", internalEnvironment)
}

#Namespace Variable
internalEnvironment <- new.env()
