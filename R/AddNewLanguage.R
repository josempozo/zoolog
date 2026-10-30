#' Add New Languages
#'
#' This function enables the user to incorporate a user-defined thesaurus set
#' as a new language. Thus, the new language is included in the set of
#' available languages and it can be activated when desired (see.
#' \code{\link{SetActiveLanguages}})
#'
#' @param thesaurusSet Thesaurus set to be added as the new language.
#' @param language Name of the language to be added.
#'
#' @return
#' \code{AddNewLanguage} adds the new language to the list of languages
#' available for the thesarus. No value is returned.
#'
#' \code{ResetAvailableLanguages} reset the list of available languages to the
#' original list at package installation. No value is returned.
#'
#' @seealso
#' ```r
#' vignette("thesaurusLanguages", package = "zoolog")
#' ```
#'
#' @examples
#' ## Let's read the template thesaurus set:
#' fileName <- system.file("extdata/thesaurusTemplateForNewLanguage",
#'                         "thesaurusSet_XXXX.json",
#'                         package="zoolog")
#' thesaurusSet <- ReadThesaurusSet(fileName)
#'
#' ## This thesaurus set can be then added as a new language
#' ## named, for instance, "Another":
#' AddNewLanguage(thesaurusSet, "Another")
#' ## See that the new language is available:
#' AllAvailableLanguages()
#' ## But not active,
#' GetActiveLanguages()
#' ## unless explicitly set as so:
#' SetActiveLanguages(c("English", "Another"))
#' GetActiveLanguages()
#' ## We can now check as the illustration terms in the template thesaurusSet
#' ## are included in the zoologThesaurus.
#' ## See, for instance, the last three terms for taxon 'Bos taurus':
#' zoologThesaurus$taxon$`Bos taurus`
#'
#' ## To avoid side-effects, the available languages are reset, in effect
#' ## removing the "Another" language from the available ones:
#' ResetAvailableLanguages()
#' AllAvailableLanguages()
#' ## We also reset the active languages:
#' SetActiveLanguages(AllAvailableLanguages())

#' @name AddNewLanguage

#' @rdname AddNewLanguage
#' @export
AddNewLanguage <- function(thesaurusSet, language)
{
  mapply(AddLanguageToSpecificThesaurus, names(thesaurusSet), thesaurusSet,
         language = language)
  return(invisible(NULL))
}

#' @rdname AddNewLanguage
#' @export
ResetAvailableLanguages <- function()
{
  assign("zoologThesaurusByLanguage", zoologThesaurusByLanguage0,
         envir = internalEnvironment)
  return(invisible(NULL))
}

###########################################
# From here, internal help functions
###########################################
AddLanguageToSpecificThesaurus <- function(thesaurusName, thesaurus, language)
{
  if(!inherits(thesaurus, "thesaurus"))
    stop("The added thesaurus for ", thesaurusName, " is not a thesaurus.")
  attr(thesaurus, "description") <-
    c(attr(thesaurus, "description"), paste("Language", language))
  thesSet <- zoologThesaurusByLanguage
  thes <- thesSet[[thesaurusName]]
  if(!inherits(thes, "thesaurusLanguageSet"))
    stop("The thesaurus ", thesaurusName, " is not structured by languages")
  if(language %in% names(thes))
    stop("The provided language (", language, ") is already in the thesaurus.")
  sensitiveness <- attr(thes, "sensitiveness")
  sensNew <- attr(thesaurus, "sensitiveness")
  if(any(mapply(function(x, y) sensitiveness[x] != y,
                names(sensNew), sensNew, USE.NAMES = FALSE)))
    stop("The provided sensitiveness for ", thesaurusName,
         " is incompatible with the zoologThesaurus one.")
  attr(thesaurus, "sensitiveness") <- NULL
  newLanguage <- list(thesaurus)
  names(newLanguage) <- language
  thesNew <- c(thes, newLanguage)
  attr(thesNew, "sensitiveness") <- attr(thes, "sensitiveness")
  attr(thesNew, "description") <- attr(thes, "description")
  attr(thesNew, "class") <- attr(thes, "class")
  newFileName <- MakeFileNames(thesNew, dirname(attr(thes, "fileName")[1]))

  attr(thesNew, "fileName") <- c(attr(thes, "fileName"),
                                 utils::tail(newFileName, 1))
  thesSet[[thesaurusName]] <- thesNew
  assign("zoologThesaurusByLanguage", thesSet, envir = internalEnvironment)
}

