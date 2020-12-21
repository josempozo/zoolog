#' Log-Ratios of Measurements
#'
#' Function to compute the log Ratios of the measurements
#' relative to standard reference values.
#' By default a reference is provided with the package.
#'
#' @param data A dataframe with the input measurements.
#' @param ref A dataframe including the measurement values used as references.
#' The default \code{ref = referencesLog} provided as package \code{zoolog} data.
#' @param refIdentifiers A vector of column names in \code{ref} identifying
#' a type of bone. By default \code{refIdentifiers = c("TAX", "EL")}.
#' @param refMeasuresName The column name in \code{ref} identifying the type of
#' bone measurement.
#' @param refValuesName The column name in \code{ref} giving the measurement
#' value.
#' @param dataIdentifiers A vector of column names in \code{data} identifying
#' a type of bone. By default \code{dataIdentifiers = refIdentifiers}.
#' @return A dataframe including the input dataframe and additional columns, one
#' for each extracted log ratio for each relevant measurement in the reference.
#' The name of the added columns are constructed prefixing each measurement by
#' the internal variable \code{logPrefix}.
#' @examples
#' LogRatios(dataExample)
#' @export
LogRatios <- function(data,
                      ref = referencesLog,
                      refIdentifiers = c("TAX", "EL"),
                      refMeasuresName = "Measure",
                      refValuesName = "Standard",
                      dataIdentifiers = refIdentifiers) {
  # Add columns for log ratios.
  # One column for each measure present in both the input data
  # and the reference.
  refMeasures <- levels(ref[, refMeasuresName])
  refMeasuresInData <- intersect(refMeasures, names(data))

  # Merging tax, element, and measure combinations in a single vector.
  # This combination identifies a single reference value.
  refIdentification <- CollapseColumns(ref[, c(refIdentifiers,
                                               refMeasuresName)])

  # Computation of the log ratios for all tax, elements, and measures.
  for (measure in refMeasuresInData)
  {
    dataIdentification <- CollapseColumns(data[, dataIdentifiers],
                                          measure)
    coincident <- match(dataIdentification, refIdentification)
    matched <- !is.na(coincident)
    x <- data[matched, measure]
    y <- ref[coincident[matched], refValuesName]
    logMeasure <- paste0(logPrefix, measure)
    data[matched, logMeasure] <- log10(x / y)
  }
  data
}

#Namespace Variable
logPrefix <- "log"
