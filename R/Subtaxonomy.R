#' Subtaxonomy under taxonomical category
#'
#' Functions to obtain the subtaxonomy or the set of taxa included in a
#' particular taxonomical group, according to the \code{\link{zoologTaxonomy}}
#' by default.
#'
#' @param groupName A name of any of the taxonomical groups at any level from
#' taxon to family.
#' @param taxonomy The taxonomy from which to extract the subtaxonomy.
#' By default \code{taxonomy = \link{zoologTaxonomy}}.
#' @param thesaurus A thesaurus allowing datasets with different nomenclatures
#' to be merged. By default \code{thesaurus = \link{zoologThesaurus}$taxon}.
#'
#' @return
#' \code{Subtaxonomy} returns a data.frame with the same structure of the input
#' taxonomy but with only the taxa (rows) included in the requested
#' taxonomical \code{groupName}, and with only the taxonomical levels (columns)
#' up to the level of that taxonomical group.
#'
#' \code{SubtaxonomySet} returns a character vector including a unique copy
#' (set) of all the elements, at any taxonomical level, under the requested
#' taxonomical \code{groupName}.
#' Equivalent to Subtaxonomy but as a set instead of a data.frame.
#'
#' \code{GetTaxaIn} returns a character vector including the taxa included in
#' the requested \code{groupName}.
#'
#' @examples
#' ## Get taxa of genus Sus:
#' GetTaxaIn("Sus")
#'
#' ## Get taxa of family Bovidae:
#' GetTaxaIn("Bovidae")
#'
#' ## Get the subtaxonomy of the Tribe Caprini:
#' Subtaxonomy("Caprini")
#'
#' ## Use SubtaxonomySet to join categories for computing log-ratios.
#' ## For this, we read an example dataset:
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package="zoolog")
#' dataExample <- utils::read.csv2(dataFile,
#'                                 na.strings = "",
#'                                 encoding = "UTF-8",
#'                                 stringsAsFactors = TRUE)
#' ## We illustrate with a subset of cases to make the example run
#' ## sufficiently fast:
#' dataExample <- dataExample[160:1000, ]
#' ## Compute the log-ratios joining all taxa from tribe \emph{Caprini}
#' ## to use the reference of \emph{Ovis aries}:
#' categoriesCaprini <- list('Ovis aries' = SubtaxonomySet("Caprini"))
#' dataExampleWithLogs <- LogRatios(dataExample,
#'                                  joinCategories = categoriesCaprini)

#' @name Subtaxonomy

#' @rdname Subtaxonomy
#' @export
Subtaxonomy <- function(groupName, taxonomy = zoologTaxonomy,
                        thesaurus = zoologThesaurus$taxon)
{
  groupLevel <- TaxonomyLevel(groupName, taxonomy, thesaurus, as.numeric = TRUE)
  if(length(groupLevel) == 0)
    stop(paste(groupName, " is not recognized in zoologTaxonomy."))
  if(length(groupLevel) > 1)
    stop(paste("Ambiguity detected in zoologTaxonomy: \n",
               groupName, " is in more than one level."))
  selectedRows <- InCategory(taxonomy[, groupLevel], groupName, thesaurus) |
                  taxonomy[, groupLevel] == groupName
  taxonomy[selectedRows, 1:groupLevel]
}

#' @rdname Subtaxonomy
#' @export
SubtaxonomySet <- function(groupName, taxonomy = zoologTaxonomy,
                           thesaurus = zoologThesaurus$taxon)
{
  subtaxonomy <- Subtaxonomy(groupName, taxonomy, thesaurus)
  as.character(unique(unlist(subtaxonomy)))
}

#' @rdname Subtaxonomy
#' @export
GetTaxaIn <- function(groupName, taxonomy = zoologTaxonomy,
                      thesaurus = zoologThesaurus$taxon)
{
#  as.character(
#    taxonomy$Taxon[as.logical(rowSums(taxonomy == groupName))])
  as.character(Subtaxonomy(groupName, taxonomy, thesaurus)$Taxon)
}

# Check if including this InCategory.data.frame into the InCategory
# Check if we want that InCategory include the own name when it is not
# included in the thesaurus.
InCategory.array <- function(x, category, thesaurus)
{
  sapply(x, function(y) InCategory(y, category, thesaurus) | y == category)
}

TaxonomyLevel <- function(groupName,
                          taxonomy = zoologTaxonomy,
                          thesaurus = zoologThesaurus$taxon,
                          as.numeric = FALSE)
{
  cases <- InCategory.array(taxonomy, groupName, thesaurus)
  groupLevel <- as.logical(colSums(cases))
  if(as.numeric)
  {
    return(which(groupLevel))
  }
  else
  {
    return(names(taxonomy)[groupLevel])
  }
}
