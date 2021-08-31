#' Log Ratios of Measurements
#'
#' Function to compute the (base 10) log ratios of the measurements
#' relative to standard reference values.
#' By default a reference is provided with the package.
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
#' For some applications it can be interesting to group some set of bone types
#' into the same reference category to compute the log ratios. The parameter
#' \code{joinCategories} allows this grouping. \code{joinCategories} must be a
#' list of named vectors, each including the set of categories in the data
#' which should be mapped to the reference category given by its name.
#'
#' This can be applied to group different species into a single
#' reference species. For instance \emph{sheep}, \emph{capra}, and doubtful
#' cases between both (\emph{sheep/capra}), can be grouped and matched to the
#' same reference for \emph{sheep}, by setting
#' \code{joinCategories = list(sheep = c("sheep", "capra", "oc"))}.
#' Similarly, it can be applied to group
#' different bone elements into a single reference (see the example below for
#' undetermined phalanges).
#'
#' Note that the \code{joinCategories} option does not remove the distinction
#' between the different bone types in the data, just indicates that for any
#' of them the log ratios must be computed from the same reference.
#'
#' There are some measures that are restricted to a subset of bones. For
#' instance, \emph{GLl} is only relevant for the \emph{astragalus}, while
#' \emph{GL} is not applicable to it. Thus, there cannot be any ambiguity
#' between both measures since they can be identified by the bone element.
#' This justifies that some users have simplified datasets where a single column
#' records indistinctly \emph{GL} or \emph{GLl}. The optional parameter
#' \code{mergedMeasures} facilitates the processing of this type of simplified
#' dataset. For the alluded example,
#' \code{mergedMeasures = list(c("GL", "GLl"))} automatically selects, for each
#' bone element, the corresponding measure present in the reference.
#'
#' Observe that if \code{mergedMeasures} is set to non mutually exclusive
#' measures, the behaviour is unpredictable.
#'
#' @param data A dataframe with the input measurements.
#' @param ref A dataframe including the measurement values used as references.
#' The default \code{ref = reference$Combi} provided as package \pkg{zoolog} data.
#' @param identifiers A vector of column names in \code{ref} identifying
#' a type of bone. By default \code{identifiers = c("TAX", "EL")}.
#' @param refMeasuresName The column name in \code{ref} identifying the type of
#' bone measurement.
#' @param refValuesName The column name in \code{ref} giving the measurement
#' value.
#' @param thesaurusSet A thesaurus allowing datasets with different nomenclatures
#' to be merged. By default \code{thesaurusSet = zoologThesaurus}.
#' @param joinCategories A list of named character vectors. Each vector is named
#' by a category in the reference and includes a set of categories in the data
#' for which to compute the log ratios with respect to that reference.
#' When \code{NULL} (default) no grouping is considered.
#' @param mergedMeasures A list of character vectors or a single character vector.
#' Each vector identifies a set of measures that the data presents merged in the
#' same column, named as any of them. This practice only makes sense if only one
#' of the measures can appear in each bone element.
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
#'                                 encoding = "UTF-8",
#'                                 stringsAsFactors = TRUE)
#' ## For illustration purposes we keep now only a subset of cases to make
#' ## the example run sufficiently fast.
#' ## Avoid this step if you want to process the full example dataset.
#' dataExample <- dataExample[145:1000, ]
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
#' ## anterior first phalanges ("phal 1 ant" and "phal 2 ant", respectively).
#' ## For this we use the optional argument joinCategories:
#' categoriesPhalAnt <- list('phal 1 ant' = c("phal 1 ant", "phal 1"),
#'                           'phal 2 ant' = c("phal 2 ant", "phal 2"))
#' dataExampleWithLogs4 <- LogRatios(dataExample,
#'                                   joinCategories = categoriesPhalAnt)
#' head(dataExampleWithLogs4)[, -c(6:20,32:64)]
#' @export
LogRatios <- function(data,
                      ref = reference$Combi,
                      identifiers = c("TAX", "EL"),
                      refMeasuresName = "Measure",
                      refValuesName = "Standard",
                      thesaurusSet = zoologThesaurus,
                      joinCategories = NULL,
                      mergedMeasures = NULL) {
  thesaurusSetForRef <- thesaurusSet
  if(!is.null(joinCategories))
    thesaurusSet <- SmartJoinCategories(thesaurusSet, joinCategories)
  dataStandard <- StandardizeDataSet(data, thesaurusSet)
  refStandard <- StandardizeDataSet(ref, thesaurusSetForRef)
  identifiers <- StandardizeNomenclature(identifiers,
                                         thesaurusSet$identifier)
  refMeasuresName <- StandardizeNomenclature(refMeasuresName,
                                             thesaurusSet$identifier)
  refValuesName <- StandardizeNomenclature(refValuesName,
                                           thesaurusSet$identifier)
  refMeasures <- levels(as.factor(refStandard[, refMeasuresName]))
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
