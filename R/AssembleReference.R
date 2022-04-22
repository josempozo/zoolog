#' Assemble Reference
#'
#' Function to build a reference dataframe selecting a case for each taxon from
#' the available specimens in the references' database.
#'
#' @param combination A dataframe or named list. Each (column) name identifies a
#' taxon. Each column or list element must have a single element of type
#' character, identifying one of the sources included in the references'
#' database.
#' @param ref.db A reference database. This is a named list of named lists of
#' dataframes. The first level is named by taxon and the second level is named
#' by reference source. Each dataframe includes the reference for the
#' corresponding taxon and source. The default
#' \code{ref.db = \link{referencesDatabase}} is provided as package
#' \pkg{zoolog} data.
#' @param thesaurus A thesaurus for taxa.
#'
#' @return
#' A reference dataframe.
#'
#' @examples
#' ## `referenceSets` includes a series of predefined reference compositions.
#' referenceSets
#' ## Actually the package `references` is build from them.
#' ## We can rebuild any of them:
#' referenceCombi <- AssembleReference(referenceSets["Combi", ])
#'
#' ## Define an altenative reference combining differently the references'
#' ## database:
#' refComb <- list(cattle = "Nieto", sheep = "Davis", Goat = "Clutton",
#'                 pig = "Albarella", redDeer = "Basel")
#' userReference <- AssembleReference(refComb)
#'
#' @export
AssembleReference <- function(combination, ref.db = referencesDatabase,
                              thesaurus = zoologThesaurus$taxon)
{
  reference <- NULL
  taxIds <- sapply(names(combination),
                   function(x) which(InCategory(names(ref.db), x, thesaurus) |
                                       names(ref.db) %in% x))
  if(any(duplicated(taxIds) & sapply(taxIds, length)>0 -> dup))
  {
    stop(paste("The taxon", names(ref.db)[taxIds[dup]],
               "is duplicated in the requested combination."))
  }
  for(tax in names(combination))
  {
    source <- combination[[tax]]
    taxId <- taxIds[[tax]]
    catchError.AssembleReference(source, taxId, tax, ref.db)
    reference <- rbind(reference, ref.db[[taxId]][[source]])
  }
  reference
}


catchError.AssembleReference <- function(source, taxId, tax, ref.db)
{
  if(length(source) > 1)
  {
    stop(paste0("More than one component requested for taxon ", tax, "."))
  }
  if(length(taxId) == 0)
  {
    stop(paste("The name", tax, "does not correspond to any taxon",
               "in the references' database."))
  }
  if(length(taxId) > 1)
  {
    stop(paste("The refereces' database is badly formatted: Taxon", tax,
               "appears more than once."))
  }
  if(!(is.na(source) || source == "" || source %in% names(ref.db[[taxId]])))
  {
    stop(paste0("The references' database does not include any component ",
                source, " for the taxon ", tax, "."))
  }
}
