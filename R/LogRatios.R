#' Log Ratios of Measurements
#'
#' Function to compute the log ratios of the measurements
#' relative to standard reference values.
#' By default a reference is provided with the package.
#'
#' @param data A dataframe with the input measurements.
#' @param ref A dataframe including the measurement values used as references.
#' The default \code{ref = referenceCombi} provided as package \code{zoolog} data.
#' @param identifiers A vector of column names in \code{ref} identifying
#' a type of bone. By default \code{identifiers = c("TAX", "EL")}.
#' @param refMeasuresName The column name in \code{ref} identifying the type of
#' bone measurement.
#' @param refValuesName The column name in \code{ref} giving the measurement
#' value.
#' @param thesaurusSet A thesaurus allowing datasets with different nomenclatures
#' to be merged. By default \code{thesaurusSet = zoologThesaurus}.
#' @return A dataframe including the input dataframe and additional columns, one
#' for each extracted log ratio for each relevant measurement in the reference.
#' The name of the added columns are constructed by prefixing each measurement by
#' the internal variable \code{logPrefix}.
#' @examples
#' ## Read an example dataset:
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package="zoolog")
#' dataExample <- read.csv2(dataFile,
#'                          quote = "\"", na = "", header = TRUE,
#'                          fileEncoding = "UTF-8")
#' ## We can observe the first lines (excluding some columns for visibility):
#' head(dataExample)[, -c(6:20,32:63)]
#'
#' ## Compute the log-ratios with respect to the default reference in the
#' ## package zoolog:
#' dataExampleWithLogs <- LogRatios(dataExample)
#' ## The output data frame include new columns with the log-ratios of the
#' ## present measurements, in both data and reference, with a "log" prefix:
#' head(dataExampleWithLogs)[, -c(6:20,32:63)]
#'
#' ## Read a different reference:
#' referenceFile <- system.file("extdata", "referenceCombi.csv", ### TO CHANGE
#'                              package="zoolog")
#' userReferenceLogs <- read.csv2(referenceFile,
#'                                quote = "\"", na = "", header = TRUE,
#'                                fileEncoding = "UTF-8")
#' ## Compute the log-ratios with respect to this alternative reference:
#' dataExampleWithLogs2 <- LogRatios(dataExample, ref = userReferenceLogs)
#' head(dataExampleWithLogs2)[, -c(6:20,32:63)]
#' @export
LogRatios <- function(data,
                      ref = referenceCombi,
                      identifiers = c("TAX", "EL"),
                      refMeasuresName = "Measure",
                      refValuesName = "Standard",
                      thesaurusSet = zoologThesaurus,
                      joinCategories = NULL) {
  # Add columns for log ratios.
  # One column for each measure present in both the input data
  # and the reference.
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


