Data2Reference <- function(data,
                           identifiers = c("TAX", "EL"),
                           refMeasuresName = "Measure",
                           refValuesName = "Standard",
                           thesaurusSet = zoologThesaurus)
{
  measureColumns <- which(InCategory(names(data), names(thesaurusSet$measure),
                                    thesaurusSet$measure))
  idColumns <- which(InCategory(names(data), identifiers,
                               thesaurusSet$identifier))
  ref <- do.call(rbind, apply(data, 1, function(x)
  {
    measures <- x[measureColumns]
    measures <- measures[!is.na(measures)]
    res <- data.frame(array(NA, dim=c(length(measures),
                                      ncol(thesaurusSet$identifier))))
    names(res) <- c(names(x)[idColumns], refMeasuresName, refValuesName)
    if(length(measures) == 0) return(res)
    res[, 1:length(idColumns)] <- rep(x[idColumns], each = length(measures))
    res[, refMeasuresName] <- names(measures)
    res[, refValuesName] <- measures
    return(res)
  }))
  as.data.frame(lapply(ref, utils::type.convert))
}


Reference2Data <- function(ref,
                           identifiers = c("TAX", "EL"),
                           refMeasuresName = "Measure",
                           refValuesName = "Standard",
                           thesaurusSet = zoologThesaurus)
{
  idColumns <- which(InCategory(names(ref), identifiers,
                                thesaurusSet$identifier))
  measureColumn <- which(InCategory(names(ref), refMeasuresName,
                                   thesaurusSet$identifier))
  valueColumn <- which(InCategory(names(ref), refValuesName,
                                thesaurusSet$identifier))
  refMeasures <- unique(ref[, measureColumn])

  refIdentification <- CollapseColumns(ref[, idColumns])
  refSamples <- unique(refIdentification)
  n <- length(refSamples)
  m <- length(idColumns)+length(refMeasures)
  data <- data.frame(array(NA, dim = c(n, m)))
  idNames <- names(ref)[idColumns]
  names(data) <- c(idNames, refMeasures)
  ref[, c(idColumns, measureColumn)] <-
    sapply(ref[, c(idColumns, measureColumn)], as.character)
  for(i in 1:n)
  {
    cases <- ref[refIdentification == refSamples[i], ]
    data[i, idNames] <- cases[1, idNames]
    data[i, cases[, measureColumn]] <- cases[, valueColumn]
  }
  as.data.frame(lapply(data, utils::type.convert))
}
