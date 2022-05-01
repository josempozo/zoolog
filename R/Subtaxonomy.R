#' Subtaxonomy under taxonomical category
#'
#' Functions to obtain the subtaxonomy or the set of taxa included in a
#' particular taxonomic group, according to the \code{\link{zoologTaxonomy}}
#' by default.
#'
#' @param taxon A name of any of the taxa, at any rank included in the taxonomy
#' (from species to family in the zoolog taxonomy).
#' @param taxonomy A taxonomy from which to extract the subtaxonomy.
#' By default \code{taxonomy = \link{zoologTaxonomy}}.
#' @param thesaurus A thesaurus allowing datasets with different nomenclatures
#' to be merged. By default \code{thesaurus = \link{zoologThesaurus}$taxon}.
#'
#' @return
#' \code{Subtaxonomy} returns a data.frame with the same structure of the input
#' taxonomy but with only the species (rows) included in the queried
#' \code{taxon}, and the taxonomic ranks (columns)
#' up to its level.
#'
#' \code{SubtaxonomySet} returns a character vector including a unique copy
#' (set) of all the taxa, at any taxonomic rank, under the queried
#' \code{taxon}.
#' Equivalent to Subtaxonomy but as a set instead of a dataframe.
#'
#' \code{GetSpeciesIn} returns a character vector including the species included
#' in the queried \code{taxon}.
#'
#' @examples
#' ## Get species of genus Sus:
#' GetSpeciesIn("Sus")
#'
#' ## Get species of family Bovidae:
#' GetSpeciesIn("Bovidae")
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
#'                                 encoding = "UTF-8")
#' ## We illustrate with a subset of cases to make the example run
#' ## sufficiently fast:
#' dataExample <- dataExample[1:1000, ]
#' ## Compute the log-ratios joining all taxa from tribe \emph{Caprini}
#' ## to use the reference of \emph{Ovis aries}:
#' categoriesCaprini <- list('Ovis aries' = SubtaxonomySet("Caprini"))
#' dataExampleWithLogs <- LogRatios(dataExample,
#'                                  joinCategories = categoriesCaprini)

#' @name Subtaxonomy

#' @rdname Subtaxonomy
#' @export
Subtaxonomy <- function(taxon, taxonomy = zoologTaxonomy,
                        thesaurus = zoologThesaurus$taxon)
{
  taxonomyStandardized <- as.data.frame(
    sapply(taxonomy, StandardizeNomenclature, thesaurus = thesaurus),
    stringsAsFactors = FALSE
  )
  taxonStandardized <- StandardizeNomenclature(taxon, thesaurus)
  groupLevel <- which(sapply(taxonomyStandardized,
                             function(x) any(x == taxonStandardized)))
  if(length(groupLevel) == 0)
    stop(paste(taxon, " is not recognized in zoologTaxonomy."))
  if(length(groupLevel) > 1)
    stop(paste("Ambiguity detected in zoologTaxonomy: \n",
               taxon, " is in more than one level."))
  selectedRows <- taxonomyStandardized[, groupLevel] == taxonStandardized
  taxonomy[selectedRows, 1:groupLevel]
}

#' @rdname Subtaxonomy
#' @export
SubtaxonomySet <- function(taxon, taxonomy = zoologTaxonomy,
                           thesaurus = zoologThesaurus$taxon)
{
  subtaxonomy <- Subtaxonomy(taxon, taxonomy, thesaurus)
  as.character(unique(unlist(subtaxonomy)))
}

#' @rdname Subtaxonomy
#' @export
GetSpeciesIn <- function(taxon, taxonomy = zoologTaxonomy,
                         thesaurus = zoologThesaurus$taxon)
{
  as.character(Subtaxonomy(taxon, taxonomy, thesaurus)$Species)
}

# Check if including this InCategory.data.frame into the InCategory
# Check if we want that InCategory include the own name when it is not
# included in the thesaurus.
InCategory.array <- function(x, category, thesaurus)
{
  sapply(x, function(y) InCategory(y, category, thesaurus) | y == category)
}

TaxonomyLevel <- function(taxon,
                          taxonomy = zoologTaxonomy,
                          thesaurus = zoologThesaurus$taxon,
                          as.numeric = FALSE)
{
  cases <- InCategory.array(taxonomy, taxon, thesaurus)
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
