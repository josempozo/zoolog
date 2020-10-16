# Function to compute the log Ratios of the measurements
# relative to standard reference values.
# By default a reference is provided with the package.
#' @export
LogRatios <- function(data,
                      ref = referencesLog,
                      refTaxName = "TAX",
                      refElementsName = "EL",
                      refMeasuresName = "Measure",
                      refValuesName = "Standard",
                      dataTaxName = refTaxName,
                      dataElementsName = refElementsName) {
  # Add columns for log ratios.
  # One column for each measure present in both the input data
  # and the reference.
  refMeasures <- levels(ref[, refMeasuresName])
  refMeasuresInData <- intersect(refMeasures, names(data))

  # Merging tax, element, and measure combinations in a single vector.
  # This combination identifies a single reference value.
  sepMark <- "--&&--"
  refIdentification <- paste(ref[, refTaxName],
    ref[, refElementsName],
    ref[, refMeasuresName],
    sep = sepMark
  )

  # Computation of the log ratios for all tax, elements, and measures.
  for (measure in refMeasuresInData)
  {
    dataIdentification <- paste(
      data[, dataTaxName],
      data[, dataElementsName],
      measure,
      sep = sepMark
    )
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
