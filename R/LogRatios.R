#' Log Ratios of Measurements
#'
#' Function to compute the (base 10) log ratios of the measurements
#' relative to standard reference values.
#' The default reference and several alternative references are provided with the
#' package. But the user can use their own references if desired.
#'
#' Each log ratio is defined as the decimal logarithm of the ratio of the
#' variable of interest to a corresponding reference value.
#'
#' The \code{identifiers} are expected to determine corresponding
#' columns in both data and reference. Each value in these columns identifies
#' the type of bone. By default this is determined by a taxon and a bone
#' element. For any case in the data, the log ratios are computed with respect
#' to the reference values in the same bone type. If the reference does not
#' include that bone type, the corresponding log ratios are set to \code{NA}.
#'
#' The taxonomy allows the matching of data and reference by genus, instead
#' of by species. This is the default behaviour with
#' \code{useGenusIfUnambiguous = TRUE}, unless there is some ambiguity:
#' reference including more than one species for the same genus. For instance,
#' \code{reference$Combi} includes a reference for \emph{Sus scrofa}.
#' If the data includes cases of \emph{Sus domesticus}, their
#' log ratios will be computed with respect to the provided reference for
#' \emph{Sus scrofa}.
#' However, a warning is given to inform the user of this assumption, and let
#' they know that this can be prevented by setting
#' \code{useGenusIfUnambiguous = FALSE}.
#'
#' For some applications it can be interesting to group some set of bone types
#' into the same reference category to compute the log ratios. The parameter
#' \code{joinCategories} allows this grouping. \code{joinCategories} must be a
#' list of named vectors, each including the set of categories in the data
#' which should be mapped to the reference category given by its name.
#'
#' This can be applied to group different species into a single
#' reference species. For instance \emph{sheep}, \emph{capra}, and doubtful
#' cases between both (\emph{sheep/goat}), can be grouped and matched to the
#' same reference for \emph{sheep}, by setting
#' \code{joinCategories = list(sheep = c("sheep", "goat", "oc"))}.
#' Indeed, the zoologTaxonomy can be used for that purpose using the function
#' \code{\link{SubtaxonomySet}} as
#' \code{joinCategories = list(sheep = SubtaxonomySet("Caprini"))}.
#' Similarly, \code{joinCategories} can be applied to group
#' different bone elements into a single reference (see the example below for
#' undetermined phalanges).
#'
#' Note that the \code{joinCategories} option does not remove the distinction
#' between the different bone types in the data, just indicates that for any
#' of them the log ratios must be computed from the same reference.
#'
#' Using the taxonomy, the presence of cases identified by higher taxonomic
#' ranks are also automatically detected. For instance, if some partially
#' identified cases have been recorded as "Ovis/Capra", this is recognized
#' to denote the tribe \emph{Caprini}, which includes several possible species.
#' Then a warning is given informing the user of the detection of these cases
#' and of the option to use any of the corresponding species in the reference by
#' using the argument \code{joinCategories} (unless this has been already done).
#'
#' There are some measures that, for most usual taxa, are restricted to a subset
#' of bones. For instance, for *Bos*, *Ovis*, *Capra*, and *Sus*, the measure
#' \emph{GLl} is only relevant for the \emph{astragalus}, while \emph{GL} is not
#' applicable to it.
#' Thus, there cannot be any ambiguity between both measures since they can
#' be identified by the bone element. This justifies that some users have
#' simplified datasets where a single column records indistinctly \emph{GL} or
#' \emph{GLl}. The optional parameter \code{mergedMeasures} facilitates the
#' processing of this type of simplified dataset. For the alluded example,
#' \code{mergedMeasures = list(c("GL", "GLl"))} automatically selects, for each
#' bone element, the corresponding measure present in the reference.
#'
#' Observe that if \code{mergedMeasures} is set to non mutually exclusive
#' measures, the behaviour is unpredictable.
#'
#' @param data A dataframe with the input measurements.
#' @param ref A dataframe including the measurement values used as references.
#' The default \code{ref = reference$Combi} and other \link{reference} sets are
#' provided with the package \pkg{zoolog}.
#' @param identifiers A vector of column names in \code{ref} identifying
#' a type of bone. By default \code{identifiers = c("Taxon", "Element")}.
#' @param refMeasuresName The column name in \code{ref} identifying the type of
#' bone measurement.
#' @param refValuesName The column name in \code{ref} giving the measurement
#' value.
#' @param thesaurusSet A thesaurus allowing datasets with different nomenclatures
#' to be merged. By default \code{thesaurusSet = \link{zoologThesaurus}}.
#' @param taxonomy A taxonomy allowing the automatic detection of data and
#' reference sharing the same genus (or higher taxonomic rank), although of
#' different species. By default \code{taxonomy = \link{zoologTaxonomy}}.
#' @param joinCategories A list of named character vectors. Each vector is named
#' by a category in the reference and includes a set of categories in the data
#' for which to compute the log ratios with respect to that reference.
#' When \code{NULL} (default) no grouping is considered.
#' @param mergedMeasures A list of character vectors or a single character vector.
#' Each vector identifies a set of measures that the data presents merged in the
#' same column, named as any of them. This practice only makes sense if only one
#' of the measures can appear in each bone element.
#' @param useGenusIfUnambiguous Boolean. If \code{TRUE} (default), data cases
#' are matched to reference sharing the same genus, instead of sharing the same
#' species.
#'
#' @return
#' A dataframe including the input dataframe and additional columns, one
#' for each extracted log ratio for each relevant measurement in the reference.
#' The name of the added columns are constructed by prefixing each measurement by
#' the internal variable \code{logPrefix}.
#'
#' If the input dataframe includes additional S3 classes (such as "tbl_df"),
#' they are also passed to the output.
#'
#' @examples
#' ## Read an example dataset:
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package="zoolog")
#' dataExample <- utils::read.csv2(dataFile,
#'                                 na.strings = "",
#'                                 encoding = "UTF-8")
#' ## For illustration purposes we keep now only a subset of cases to make
#' ## the example run sufficiently fast.
#' ## Avoid this step if you want to process the full example dataset.
#' dataExample <- dataExample[1:400, ]
#' ## We can observe the first lines (excluding some columns for visibility):
#' head(dataExample)[, -c(6:20,32:64)]
#'
#' ## Compute the log-ratios with respect to the default reference in the
#' ## package zoolog:
#' dataExampleWithLogs <- LogRatios(dataExample)
#' ## The output data frame include new columns with the log-ratios of the
#' ## present measurements, in both data and reference, with a "log" prefix:
#' head(dataExampleWithLogs)[, -c(6:20,32:64)]
#'
#' ## Compute the log-ratios with respect to a different reference:
#' dataExampleWithLogs2 <- LogRatios(dataExample, ref = reference$Basel)
#' head(dataExampleWithLogs2)[, -c(6:20,32:64)]
#'
#' ## Define an altenative reference combining differently the references'
#' ## database:
#' refComb <- list(cattle = "Nieto", sheep = "Davis", Goat = "Clutton",
#'                 pig = "Albarella", redDeer = "Basel")
#' userReference <- AssembleReference(refComb)
#' ## Compute the log-ratios with respect to this alternative reference:
#' dataExampleWithLogs3 <- LogRatios(dataExample, ref = userReference)
#'
#' ## We can be interested in including the first and second phalanges without
#' ## anterior-posterior identification ("phal 1" and "phal 2"), by computing
#' ## their log ratios with respect to the reference of the corresponding
#' ## anterior phalanges ("phal 1 ant" and "phal 2 ant", respectively).
#' ## For this we use the optional argument joinCategories:
#' categoriesPhalAnt <- list('phal 1 ant' = c("phal 1 ant", "phal 1"),
#'                           'phal 2 ant' = c("phal 2 ant", "phal 2"))
#' dataExampleWithLogs4 <- LogRatios(dataExample,
#'                                   joinCategories = categoriesPhalAnt)
#' head(dataExampleWithLogs4)[, -c(6:20,32:64)]
#' @export
LogRatios <- function(data,
                      ref = reference$Combi,
                      identifiers = c("Taxon", "Element"),
                      refMeasuresName = "Measure",
                      refValuesName = "Standard",
                      thesaurusSet = zoologThesaurus,
                      taxonomy = zoologTaxonomy,
                      joinCategories = NULL,
                      mergedMeasures = NULL,
                      useGenusIfUnambiguous = TRUE) {
  thesaurusSetJoined <- thesaurusSet
  if(!is.null(joinCategories))
    thesaurusSetJoined <- SmartJoinCategories(thesaurusSetJoined,
                                              joinCategories)
  dataStandard <- StandardizeDataSet(data, thesaurusSetJoined)
  identifiers <- StandardizeNomenclature(identifiers,
                                         thesaurusSet$identifier)
  refStandard <- StandardizeDataSet(ref, thesaurusSet)
  refMeasuresName <- StandardizeNomenclature(refMeasuresName,
                                             thesaurusSet$identifier)
  refValuesName <- StandardizeNomenclature(refValuesName,
                                           thesaurusSet$identifier)

  dataStandard <- HandleTaxonAmbiguity(dataStandard, refStandard,
                                       identifiers, taxonomy,
                                       thesaurusSetJoined,
                                       useGenusIfUnambiguous)

  refMeasures <- unique(refStandard[, refMeasuresName])
  refMeasuresInData <- intersect(names(dataStandard), refMeasures)

  # Merging tax, element, and measure combinations in a single vector.
  # This combination identifies a single reference value.
  refIdentification <- CollapseColumns(refStandard[, c(identifiers,
                                                       refMeasuresName)])

  # Computation of the log ratios for all tax, elements, and measures.
  for (measure in refMeasuresInData)
  {
    refMeasures <- GetGroup(measure, mergedMeasures)
    for(refMeasure in refMeasures)
    {
      dataIdentification <- CollapseColumns(dataStandard[, identifiers],
                                            refMeasure)
      coincident <- match(dataIdentification, refIdentification)
      matched <- !is.na(coincident)
      x <- dataStandard[matched, measure]
      y <- refStandard[coincident[matched], refValuesName]
      measureUserName <- names(data)[which(names(dataStandard) == measure)]
      logMeasure <- paste0(logPrefix, measureUserName)
      data[matched, logMeasure] <- log10(x / y)
    }
  }
  return(data)
}

#Namespace Variable
logPrefix <- "log"


GetGroup <- function(x, groups)
{
  if(!is.list(groups)) groups <- list(groups)
  xInGroup <- which(as.logical(lapply(groups, is.element, el=x)))
  if(length(xInGroup)==0) return(x)
  if(length(xInGroup)>1) stop(paste(x, "is included in more than one group."))
  groups[[xInGroup]]
}


JoinGenusForReference <- function(dataStandard,
                                  species, taxGroup,
                                  thesaurusSetJoined)
{
  implicitJoinCategories <- list(taxGroup)
  names(implicitJoinCategories) <- species
  thesaurusSetJoined <- SmartJoinCategories(thesaurusSetJoined,
                                            implicitJoinCategories)
  StandardizeDataSet(dataStandard, thesaurusSetJoined)
}


WarnOfTaxonAmbiguity <- function(taxonomyWarning,
                                 taxaInRef, rank, taxGroup)
{
  taxonomyWarning$initialMessage <- "Data includes some cases recorded as\n"
  if(length(taxaInRef) > 0)
  {
    if(length(taxaInRef) == 1 && is.null(taxonomyWarning$message))
    {
      taxonomyWarning$finalMessage <-
        "   Set joinCategories as appropriate if you want to use it."
    }
    else
    {
      taxonomyWarning$finalMessage <-
        "   Set joinCategories as appropriate if you want to use any of them."
    }
    taxonomyWarning$message <-
      paste0(taxonomyWarning$message,
             "    * ", taxGroup, " (which is a ", rank, ")\n",
             "      for which the reference for ",
             paste(taxaInRef, collapse = " or "),
             " could be used.\n")
  }
  return(taxonomyWarning)
}


HandleTaxonAmbiguity <- function(dataStandard,
                                 refStandard,
                                 identifiers,
                                 taxonomy,
                                 thesaurusSetJoined,
                                 useGenusIfUnambiguous)
{
  taxName <- identifiers[1]
  taxonomicRanks <- names(taxonomy)
  genusWarning <- ""
  taxonomyWarning <- list()
  for(rank in taxonomicRanks)
  {
    taxGroups <- intersect(unique(dataStandard[[taxName]]),
                           unique(taxonomy[[rank]]))
    for(taxGroup in taxGroups)
    {
      if(rank == "Species")
      {
        genus <- as.character(
          taxonomy$Genus[taxonomy$Species == taxGroup])
        species <- GetSpeciesIn(genus, taxonomy)
      }
      else
      {
        species <- GetSpeciesIn(taxGroup, taxonomy)
      }
      taxaInRef <- intersect(species, unique(refStandard[[taxName]]))
      if(rank %in% c("Species", "Genus") && length(taxaInRef) == 1 &&
         taxaInRef != taxGroup)
      {
        if(useGenusIfUnambiguous)
        {
          dataStandard <- JoinGenusForReference(dataStandard,
                                                taxaInRef, taxGroup,
                                                thesaurusSetJoined)
          genusWarning <- paste0(genusWarning, "Reference for ", taxaInRef,
                                 " used for cases of ", taxGroup, ".\n   ")
        }
      }
      else if(rank != "Species")
      {
        taxonomyWarning <- WarnOfTaxonAmbiguity(taxonomyWarning,
                                                taxaInRef, rank, taxGroup)
      }
    }
  }
  if(genusWarning != "") warning(genusWarning,
                                 "Set useGenusIfUnambiguous to FALSE ",
                                 "if this behaviour is not desired.",
                                 call. = FALSE)
  if(!is.null(taxonomyWarning$message)) warning(taxonomyWarning$initialMessage,
                                                taxonomyWarning$message,
                                                taxonomyWarning$finalMessage,
                                                call. = FALSE)
  return(dataStandard)
}
