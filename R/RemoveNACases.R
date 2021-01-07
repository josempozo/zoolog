#' Remove Cases Missing All Measurements.
#'
#' Function to remove the table rows with all measurements of interest NA.
#' The measurements name can be explicitly provided
#' or selected by a common initial pattern.
#' The default values remove the rows with no log-ratio available.
#'
#' @inheritParams LogRatios
#' @param measureNames A vector of characters with the list of measurements
#' to be considered for missing values. If NULL (default), all measurements
#' starting by \code{prefix} are considered.
#' @param prefix A character string with the initial pattern to select the
#' list of measurements. The default is given by the internal variable
#' \code{logPrefix}. It is in effect only when \code{measureNames = NULL}.
#' @return A dataframe with the same columns as the input dataframe but
#' removing the rows with missing values for all measurements in the list.
#' @examples
#' RemoveNACases(dataExample, measureNames = exampleMeasuresName)
#' RemoveNACases(dataExampleWithLog)

#' @export
RemoveNACases <- function(data, measureNames = NULL, prefix = logPrefix)
{
  names <- colnames(data)
  if (is.null(measuresName))
  {
    measureNames <- names[regexpr(prefix, names) == 1]
  }
  else
  {
    measureNames <- intersect(measuresName, names)
  }
  prunedData <- data[rowSums(!is.na(data[, measureNames])) > 0, ]
  rownames(prunedData) <- NULL
  # type.convert removes the non-used factors after subsetting the data.frame.
  # It takes also into account if factors in the original data.frame can
  # be considered numeric or logical in the subset one.
  as.data.frame(lapply(prunedData,
                       function(x) utils::type.convert(as.character(x))))
}
