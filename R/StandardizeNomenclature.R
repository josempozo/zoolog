# Maps the user provided nomenclature into a standard one
# as defined in a thesaurus. The thesaurus must be in the following format:
# A list of named lists. The
# The standard nomenclature is expected to coincide with the one used in the
# reference dataset.

#' Standardize nomenclature
#'
#' Function \code{StandardizeNomenclature} standardizes a character vector
#' according to a given thesaurus.
#' Function \code{StandardizeDataSet} standardizes column names and values of
#' a data frame according to a thesaurus set.
#'
#' @inheritParams Thesaurus Reader/Writer
#' @param x Character vector.
#' @param mark.unknown Logical. If \code{FALSE} (default) the strings not found in the
#' thesaurus are kept without change. If \code{TRUE} the strings not in the
#' thesaurus are set to \code{NA}.
#' @param data A data frame.
#'
#' @return
#' \code{StandardizeNomenclature} returns a vector of the same length as the
#' input vector. The names present in the thesaurus are set to their
#' corresponding category. The names not in the thesaurus are kept unchanged if
#' \code{mark.unknown=FALSE} (default) and set to \code{NA} if
#' \code{mark.unknown=TRUE}.
#'
#' \code{StandardizeDataSet} returns a data frame with the same structure as
#' the input but standardizing its nomenclature according to a thesaurus set
#' including appropriate thesauri for its column names and for values of several
#' of its columns.
#'
#' @examples
#' ## Selecting the thesaurus for taxa present in the thesaurus set
#' ## \code{zoolog::zoologThesaurus}:
#' thesaurus <- zoologThesaurus$taxon
#' thesaurus
#' ## Standardizing an heterodox vector of taxa:
#' StandardizeNomenclature(c("bota", "rabbit", "pig", "cattle"),
#'                         thesaurus)
#' ## Observe that "rabit" is kept unchanged since it is not included in
#' ## any thesaurus category.
#'
#' ## This \code{thesaurus} is not case sensitive:
#' attr(thesaurus, "caseSensitive") #  == FALSE
#' ## Thus, names are recognized independently of their case:
#' StandardizeNomenclature(c("bota", "BOTA", "Bota", "boTa"),
#'                         thesaurus)
#'
#' ## Loading an example data frame:
#' dataExample <- read.csv2(system.file("extdata", "dataExample1000.csv",
#'                                        package="zoolog"),
#'                          stringsAsFactors = TRUE)
#' ## Observe mainly the first collumns:
#' head(dataExample[,1:5])
#' ## Stadardizing the dataset:
#' dataStandardized <- StandardizeDataSet(dataExample, zoologThesaurus)
#' head(dataStandardized[,1:5])
#'
#' @seealso
#' \code{\link{ReadThesaurus}}, \code{\link{AddToThesaurus}}

#' @name StandardizeNomenclature

#' @rdname StandardizeNomenclature
#' @export
StandardizeNomenclature <- function(x, thesaurus, mark.unknown = FALSE)
{
  if(is.null(thesaurus) || is.null(x) || length(thesaurus)==0) return(x)
  n <- length(x)
  x.isfactor <- is.factor(x)
  if(x.isfactor) x <- as.character(x)
  normalized <- NormalizeForSensitiveness(thesaurus, x)
  thesaurus <- lapply(normalized$thesaurus, function(a) a[a!=""])
  y <- sapply(thesaurus, is.element, el = normalized$x)
  if(mark.unknown) x[] <- NA
  if(length(x)>1) ynames <- colnames(y) else ynames<-names(y)
  x[(which(y)-1) %% n + 1] <- ynames[ceiling(which(y)/n)]
  if(x.isfactor) x <- as.factor(x)
  return(x)
}

#' @rdname StandardizeNomenclature
#' @export
StandardizeDataSet <- function(data, thesaurusSet = zoologThesaurus)
{
  for(thesaurus in thesaurusSet[attr(thesaurusSet, "applyToColNames")])
  {
    names(data) <- StandardizeNomenclature(names(data), thesaurus)
  }
  for(i in which(attr(thesaurusSet, "applyToColValues") &
                 names(thesaurusSet) %in% names(data)))
  {
    type <- names(thesaurusSet)[i]
    data[, type] <- StandardizeNomenclature(data[, type], thesaurusSet[[type]])
  }
  data$Measure <- StandardizeNomenclature(data$Measure, thesaurusSet$measure)
  return(data)
}

