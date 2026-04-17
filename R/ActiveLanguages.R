#' Active Languages
#'
#' Functions to get and activate the languages to be included in the thesauri.
#'
#' On loading the package, all available languages are active.
#'
#' Observe that the function \code{SetActiveLanguages} globally changes the
#' behaviour of the package by modifying the thesaurus in use.
#'
#' There is a specially treated language "Base" including the scientific
#' nomenclature, which is always active.
#'
#' @param languages A character vector indicating the desired set of languages.
#'
#' @return
#' \code{AllAvailableLanguages} returns a character vector containing the
#' complete list of languages available for the thesarus.
#'
#' \code{SetActiveLanguages} activates the indicated languages. The thesaurus is
#' modified in agreement. No value is returned.
#'
#' \code{GetActiveLanguages} returns a character vector containing the list
#' of active languages.
#'
#' @seealso
#' \code{\link{zoologThesaurus}}
#' for a description of the thesaurus and thesaurus set structure,
#' \code{\link{StandardizeNomenclature}}, \code{\link{InCategory}}.
#'
#' @examples
#' ## Viewing all available languages:
#' AllAvailableLanguages()
#'
#' ## Setting only English as active
#' SetActiveLanguages(c("English"))
#' ## We can check that "cattle" is identified as "Bos taurus", but that
#' ## "Boeuf domestique" is not
#' InCategory(c("cattle", "Boeuf domestique"),
#'            category = "Bos taurus",
#'            thesaurus = zoologThesaurus$taxon)
#' # TRUE FALSE
#'
#' ## But if we activate also French
#' SetActiveLanguages(c("English", "French"))
#' ## Both alternatives are identified
#' InCategory(c("cattle", "Boeuf domestique"),
#'            category = "Bos taurus",
#'            thesaurus = zoologThesaurus$taxon)
#' # TRUE TRUE
#'
#' ## Checking which languages are active.
#' ## Observe that "Base" is always active even if not requested
#' GetActiveLanguages()
#'
#' ## Reseting all available languages as active
#' SetActiveLanguages(AllAvailableLanguages())

#' @name ActiveLanguages

#' @rdname ActiveLanguages
#' @export
AllAvailableLanguages <- function()
{
  GetAvailableLanguages(zoologThesaurusByLanguage)
}

GetAvailableLanguages <- function(thesaurusSet.db)
{
  languageNames <- c()
  for(thesaurus.db in thesaurusSet.db)
  {
    if(isTRUE(attr(thesaurus.db, "structuredByLanguage")))
      languageNames <- union(languageNames, names(thesaurus.db))
  }
  return(languageNames)
}

#' @rdname ActiveLanguages
#' @export
SetActiveLanguages <- function(languages)
{
  languages <- union("Base", languages)
  notAvailableLanguages <- setdiff(languages, AllAvailableLanguages())
  if(length(notAvailableLanguages) > 0)
  {
    warning("The requested ",
            FormatListOfNames(notAvailableLanguages, c("\"", "\""),
                              c("language", "languages"), c("is", "are")),
            " not available.")
    languages <- setdiff(languages, notAvailableLanguages)
  }
  assign("activeLanguages", languages, envir = internalEnvironment)
  assign("zoologThesaurus",
         AssembleThesaurusSet(zoologThesaurusByLanguage, languages),
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
