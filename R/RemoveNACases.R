#' Remove Cases Missing All Measurements
#'
#' Function to remove the table rows for which all measurements of interest
#' are non-available (NA).
#' A particular list of measurement names can be explicitly provided
#' or selected by a common initial pattern.
#' The default setting removes the rows with no log-ratio available.
#'
#' @inheritParams LogRatios
#' @param measureNames A vector of characters with the list of measurements
#' to be considered for missing values. If \code{NULL} (default), all measurements
#' starting by \code{prefix} are considered.
#' @param prefix A character string with the initial pattern to select the
#' list of measurements. The default is given by the internal variable
#' \code{logPrefix}. It is in effect only when \code{measureNames = NULL}.
#' @return A dataframe with the same columns as the input dataframe but
#' removing the rows with missing values for all measurements in the list.
#' @examples
#' ## Read an example dataset:
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package = "zoolog")
#' dataExample <- utils::read.csv2(dataFile,
#'                                 na.strings = "",
#'                                 encoding = "UTF-8",
#'                                 stringsAsFactors = TRUE)
#' ## We can observe the first lines (excluding some columns for visibility):
#' head(dataExample)[, -c(6:20,32:64)]
#'
#' ## Remove the cases not including any measurement present in the reference.
#' refMeasureNames <- levels(factor(reference$Combi$Measure))
#' refMeasureNames
#' dataExamplePruned <- RemoveNACases(dataExample,
#'                                    measureNames = refMeasureNames)
#' ## The first lines of the output data frame show at least one available
#' ## measurement value in the selected list:
#' head(dataExamplePruned)[, -c(6:20,32:64)]
#'
#' ## If we compute first the log-ratios
#' dataExampleWithLogs <- LogRatios(dataExample)
#' ## the cases not including any log-ratio can be removed with the
#' ## default logPrefix
#' dataExampleWithLogsPruned <- RemoveNACases(dataExampleWithLogs)
#' head(dataExampleWithLogsPruned)[, -c(6:20,32:64)]

#' @export
RemoveNACases <- function(data, measureNames = NULL, prefix = logPrefix)
{
  if(!is.data.frame(data)) stop("data must be a data.frame.")
  originalDataClasses <- class(data)
  names <- colnames(data)
  if (is.null(measureNames))
  {
    measureNames <- names[regexpr(prefix, names) == 1]
  }
  else
  {
    measureNames <- intersect(measureNames, names)
  }
#  prunedData <- data[rowSums(!is.na(data[, measureNames])) > 0, ]
  prunedData <- data[apply(as.array(!is.na(data[, measureNames])), 1, any), ]
  rownames(prunedData) <- NULL
  # type.convert removes the non-used factors after subsetting the data.frame.
  # It takes also into account if factors in the original data.frame can
  # be considered numeric or logical in the subset one.
  prunedData <- as.data.frame(lapply(prunedData,
                                     function(x) {
                                       y <- utils::type.convert(as.character(x),
                                                                as.is = FALSE)
                                       if(is.character(x) & is.factor(y)) y <- x
                                       return(y)
                                     }), stringsAsFactors = FALSE)
  class(prunedData) <- originalDataClasses
  return(prunedData)
}
