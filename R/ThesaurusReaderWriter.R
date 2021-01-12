#' Thesaurus readers and writers
#'
#' Functions to read and write thesauri and thesaurus sets.
#'
#' @param file Name of a file.
#' @param thesaurus A thesaurus object.
#' @param thesaurusSet A thesaurus set.
#' @param caseSensitive,accentSensitive Logical. They set the case and accent
#' sensitivity (\code{FALSE} by default) of the thesaurus.
#'
#' @return
#' \code{WriteThesaurus} and \code{WriteThesaurusSet} create or overwrite the
#' corresponding files. No value is returned.
#'
#' \code{ReadThesaurus} and \code{ReadThesaurusSet} return the read thesaurus or
#' thesaurusSet, respectively.
#'
#' @examples
#' ## Reading a thesaurus for taxa:
#' thesaurusFile <- system.file("extdata", "taxonThesaurus.csv", package="zoolog")
#' thesaurus <- ReadThesaurus(thesaurusFile)
#' ## The attributes of the thesaurus include the fields 'caseSensitive' and
#' ## 'accentSensitive', both FALSE by default.
#' attributes(thesaurus)
#'
#' ## Any of them can be set by the user if desired:
#' thesaurus2 <- ReadThesaurus(thesaurusFile, accentSensitive = TRUE)
#' attributes(thesaurus2)
#'
#' ## Writing the thesarus to a file:
#' fileExample <- file.path(tempdir(), "thesaurusExample.csv")
#' WriteThesaurus(thesaurus, fileExample)
#'
#' ## Reading a thesaurus set:
#' thesaurusSetFile <- system.file("extdata", "zoologThesaurusSet.csv", package="zoolog")
#' thesaurusSet <- ReadThesaurusSet(thesaurusSetFile)
#' ## The attributes of the thesaurus set include information of the constituent
#' ## thesauri: names, source file names and their mode of application on datasets.
#' attributes(thesaurusSet)
#' ## The attributes of each thesaurus are also set by 'ReadThesaurusSet'.
#' attributes(thesaurusSet$measure)
#'
#' ## Writing the thesaurus set to a file:
#' fileSetExample <- file.path(tempdir(), "thesaurusSetExample.csv")
#' WriteThesaurusSet(thesaurusSet, fileSetExample)
#' ## It writes the thesaurus-set main data frame and each of the included
#' ## thesausus files.

#' @name Thesaurus Reader/Writer

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurus <- function(file, caseSensitive = FALSE, accentSensitive = FALSE)
{
  thesaurus <- read.csv2(file, stringsAsFactors = FALSE, header = FALSE)
  names(thesaurus) <- thesaurus[1,]
  attr(thesaurus, "caseSensitive") <- caseSensitive
  attr(thesaurus, "accentSensitive") <- accentSensitive
  if(ambiguity <- ThesaurusAmbiguity(thesaurus))
    stop(paste0("Ambiguous thesaurus in ", file , ":\n",
                attr(ambiguity, "errmessage")))
  return(thesaurus)
}

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurusSet <- function(file)
{
  data <- read.csv2(file)
  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  thesaurusSet <- mapply(ReadThesaurus, filenames,
                         data$CaseSensitive, data$AccentSensitive)
  names(thesaurusSet) <- data$ThesaurusName
  attr(thesaurusSet, "applyToColNames") <- data$ApplyToColNames
  attr(thesaurusSet, "applyToColValues") <- data$ApplyToColValues
  attr(thesaurusSet, "fileName") <- as.character(data$FileName)
  return(thesaurusSet)
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurus <- function(thesaurus, file)
{
  write.csv2(thesaurus[-1,], file, row.names = FALSE, quote = FALSE)
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurusSet <- function(thesaurusSet, file)
{
  data <- data.frame()
  data[1:length(thesaurusSet),"ThesaurusName"] <- names(thesaurusSet)
  data$FileName <- attr(thesaurusSet, "fileName")
  data$CaseSensitive <- sapply(zoologThesaurus,
                               function(x) attr(x, "caseSensitive"))
  data$accentSensitive <- sapply(zoologThesaurus,
                                 function(x) attr(x, "accentSensitive"))
  data$ApplyToColNames <- attr(thesaurusSet, "applyToColNames")
  data$ApplyToColValues <- attr(thesaurusSet, "applyToColValues")
  write.csv2(data, file, row.names = FALSE, quote = FALSE)

  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  filenames <- file.path(dir, data$FileName)
  noreturn <- mapply(WriteThesaurus, thesaurusSet, filenames)
}
