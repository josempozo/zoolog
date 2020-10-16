# Function to remove the table rows with all measurements of interest NA.
# The measurements name can be explicitly provided
# or selected by a common initial pattern.
# The default values remove the rows with no log-ratio available.
#' @export
RemoveNACases <- function(data, measuresName = NULL, prefix = logPrefix)
{
  names <- colnames(data)
  if (is.null(measuresName))
  {
    measuresName <- names[regexpr(prefix, names) == 1]
  }
  else
  {
    measuresName <- intersect(measuresName, names)
  }
  prunedData <- data[rowSums(!is.na(data[, measuresName])) > 0, ]
  rownames(prunedData) <- NULL
  # type.convert removes the non-used factors after subsetting the data.frame.
  # It takes also into account if factors in the original data.frame can
  # be considered numeric or logical in the subset one.
  type.convert(prunedData)
}
