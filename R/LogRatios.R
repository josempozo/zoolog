#' Log Ratios of Measurements
#'
#' Function to compute the log ratios of the measurements
#' relative to standard reference values.
#' By default a reference is provided with the package.
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
#' cases between both (\emph{sheep/capra}), can be grouped and assigned to the
#' same reference for \emph{sheep}, by setting
#' \code{joinCategories = list(sheep = c("sheep", "capra", "oc"))}.
#' Similarly, it can be applied to group
#' different bone elements into a single reference.
#'
#' Note that the \code{joinCategories} option does not remove the distinction
#' between the different bone types in the data, just indicates that for any
#' of them the log ratios must be computed from the same reference.
#'
#' @param data A dataframe with the input measurements.
#' @param ref A dataframe including the measurement values used as references.
#' The default \code{ref = referenceCombi} provided as package \pkg{zoolog} data.
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
#'
#' @return
#' A dataframe including the input dataframe and additional columns, one
#' for each extracted log ratio for each relevant measurement in the reference.
#' The name of the added columns are constructed by prefixing each measurement by
#' the internal variable \code{logPrefix}.
#'
#' @examples
#' ## Read an example dataset:
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package="zoolog")
#' dataExample <- read.csv2(dataFile,
#'                          quote = "\"", na = "", header = TRUE,
#'                          fileEncoding = "UTF-8")
#' ## We can observe the first lines (excluding some columns for visibility):
#' head(dataExample)[, -c(6:20,32:63)]
#' ## We keep now only the first 1000 cases to make the example run sufficiently
#' ## fast. Avoid this step if you want to process the full example dataset.
#' dataExample <- dataExample[1:1000, ]
#'
#' ## Compute the log-ratios with respect to the default reference in the
#' ## package zoolog:
#' dataExampleWithLogs <- LogRatios(dataExample)
#' ## The output data frame include new columns with the log-ratios of the
#' ## present measurements, in both data and reference, with a "log" prefix:
#' head(dataExampleWithLogs)[, -c(6:20,32:63)]
#'
#' ## Read a different reference:
#' referenceFile <- system.file("extdata", "referenceBasel.csv",
#'                              package="zoolog")
#' userReferenceLogs <- read.csv2(referenceFile,
#'                                quote = "\"", na = "", header = TRUE,
#'                                fileEncoding = "UTF-8")
#' ## Compute the log-ratios with respect to this alternative reference:
#' dataExampleWithLogs2 <- LogRatios(dataExample, ref = userReferenceLogs)
#' head(dataExampleWithLogs2)[, -c(6:20,32:63)]
#'
#' ## We can be interested in including the first phalanges without
#' ## identification as posterior or anterior, to compute the log ratios with
#' ## respect to the anterior first phalanges.
#' categoriesP1 <- list('P1 ant' = c("P1 ant", "P1"))
#' dataExampleWithLogs3 <- LogRatios(dataExample,
#'                                   joinCategories = categoriesP1)
#' head(dataExampleWithLogs3)[, -c(6:20,32:63)]
#' @export
LogRatios <- function(data,
                      ref = referenceCombi,
                      identifiers = c("TAX", "EL"),
                      refMeasuresName = "Measure",
                      refValuesName = "Standard",
                      thesaurusSet = zoologThesaurus,
                      joinCategories = NULL) {
  thesaurusSetForRef <- thesaurusSet
  if(!is.null(joinCategories))
    thesaurusSet <- SmartJoinCategories(thesaurusSet, joinCategories)
  dataStandard <- StandardizeDataSet(data, thesaurusSet)
  dataStandard <- StandardizeDataSet(dataStandard, thesaurusSetForRef)
  refStandard <- StandardizeDataSet(ref, thesaurusSetForRef)
  identifiers <- StandardizeNomenclature(identifiers,
                                         thesaurusSet$identifier)
  refMeasuresName <- StandardizeNomenclature(refMeasuresName,
                                             thesaurusSet$identifier)
  refValuesName <- StandardizeNomenclature(refValuesName,
                                           thesaurusSet$identifier)
  refMeasures <- levels(as.factor(refStandard[, refMeasuresName]))
  refMeasuresInData <- intersect(refMeasures, names(dataStandard))

  # Merging tax, element, and measure combinations in a single vector.
  # This combination identifies a single reference value.
  refIdentification <- CollapseColumns(refStandard[, c(identifiers,
                                                       refMeasuresName)])

  # Computation of the log ratios for all tax, elements, and measures.
  for (measure in refMeasuresInData)
  {
    dataIdentification <- CollapseColumns(dataStandard[, identifiers],
                                          measure)
    coincident <- match(dataIdentification, refIdentification)
    matched <- !is.na(coincident)
    x <- dataStandard[matched, measure]
    y <- refStandard[coincident[matched], refValuesName]
    measureUserName <- names(data)[names(dataStandard) == measure]
    logMeasure <- paste0(logPrefix, measureUserName)
    data[matched, logMeasure] <- log10(x / y)
  }
  return(data)
}

#Namespace Variable
logPrefix <- "log"


