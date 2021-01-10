# Maps the user provided nomenclature into a standard one
# as defined in a thesaurus. The thesaurus must be in the following format:
# A list of named lists. The
# The standard nomenclature is expected to coincide with the one used in the
# reference dataset.
StandardizeNomenclature <- function(x, thesaurus, mark.unknown = FALSE)
{
  if(is.null(thesaurus) || is.null(x)) return(x)
  n <- length(x)
  x.isfactor <- is.factor(x)
  if(x.isfactor) x <- as.character(x)
  textPrep <- c()
  if(!attr(thesaurus,"caseSensitive")) textPrep <- c(textPrep, "Any-lower")
  if(!attr(thesaurus,"accentSensitive")) textPrep <- c(textPrep, "Latin-ASCII")
  xprepared <- x
  for(id in textPrep)
  {
    thesaurus <- lapply(thesaurus, stringi::stri_trans_general, id)
    xprepared <- stringi::stri_trans_general(xprepared, id)
  }
  thesaurus <- lapply(thesaurus, function(a) a[a!=""])
  y <- sapply(thesaurus, is.element, el = xprepared)
  if(mark.unknown) x[] <- NA
  x[(which(y)-1) %% n + 1] <- colnames(y)[ceiling(which(y)/n)]
  if(x.isfactor) x <- as.factor(x)
  return(x)
}

#' @export
ReadThesaurus <- function(file, caseSensitive = FALSE, accentSensitive = FALSE)
{
  thesaurus <- read.csv2(file, stringsAsFactors = FALSE, header = FALSE)
  names(thesaurus) <- thesaurus[1,]
  attr(thesaurus, "caseSensitive") <- caseSensitive
  attr(thesaurus, "accentSensitive") <- accentSensitive
  if(ThesaurusAmbiguity(thesaurus)) stop(paste0("Ambiguous thesaurus in ", file))
  return(thesaurus)
}

#' @export
ReadZoologThesaurusSet <- function(file)
{
  data <- read.csv2(file)
  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  zoologThesaurusSet <- mapply(ReadThesaurus, filenames,
                               data$CaseSensitive, data$AccentSensitive)
  names(zoologThesaurusSet) <- data$ThesaurusName
  return(zoologThesaurusSet)
}

StandardizeDataSet <- function(data, thesaurus = zoologThesaurus)
{
  names(data) <- StandardizeNomenclature(names(data), thesaurus$anatomicalId)
  names(data) <- StandardizeNomenclature(names(data), thesaurus$measure)
  if(!all(names(thesaurus$anatomicalId) %in% names(data)))
  {
    stop("Data is missing some anatomical identifier.")
  }
  for(type in names(thesaurus$anatomicalId))
  {
    data[, type] <- StandardizeNomenclature(data[, type], thesaurus[[type]])
  }
  data$Measure <- StandardizeNomenclature(data$Measure, thesaurus$measure)
  return(data)
}

ThesaurusAmbiguity <- function(thesaurus)
{
  thesaurus <- lapply(thesaurus, function(a) a[a!=""])
  pairs <- utils::combn(names(thesaurus), 2)
  ambiguities <- list()
  for(i in 1:ncol(pairs))
  {
    pair.coincidence <- thesaurus[[pairs[1,i]]] %in% thesaurus[[pairs[2,i]]]
    if(any(pair.coincidence))
    {
      ambiguities[[paste0("Ambiguity in pair (\"", pairs[1,i], "\", \"", pairs[2,i], "\")")]] <-
        thesaurus[[pairs[1,i]]][pair.coincidence]
    }
  }
  res <- length(ambiguities)>0
  if(res) print(ambiguities)
  return(res)
}
