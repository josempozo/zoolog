#' List objects
#' @usage zoologThesaurus
#' @name zoologThesaurus
#' @export
NULL

.onLoad <- function(libname, pkgname) {
  internalEnvironment$zoologThesaurus <- AssembleThesaurusSet(
    zoologThesaurusByLanguage)
  internalEnvironment$activeLanguages <- AllAvailableLanguages()
  makeActiveBinding("zoologThesaurus",
                    GetZoologThesaurus,
                    getNamespace("zoolog"))
}

GetZoologThesaurus <- function()
{
  get("zoologThesaurus", internalEnvironment)
}

