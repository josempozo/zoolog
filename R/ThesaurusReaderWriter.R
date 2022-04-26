#' Thesaurus Readers and Writers
#'
#' Functions to read and write thesauri and thesaurus sets.
#'
#' @param file Name of a file.
#' @param thesaurus A thesaurus object.
#' @param thesaurusSet A thesaurus set.
#' @param caseSensitive,accentSensitive,punctuationSensitive Logical. They set
#' the case, accent, and punctuation sensitivity (\code{FALSE} by default) of
#' the thesaurus.
#'
#' @return
#' \code{WriteThesaurus} and \code{WriteThesaurusSet} create or overwrite the
#' corresponding files. No value is returned.
#'
#' \code{ReadThesaurus} and \code{ReadThesaurusSet} return the read thesaurus or
#' thesaurusSet, respectively.
#'
#' @examples
#' ## Read a thesaurus for taxa:
#' thesaurusFile <- system.file("extdata", "taxonThesaurus.csv", package="zoolog")
#' thesaurus <- ReadThesaurus(thesaurusFile)
#' ## The attributes of the thesaurus include the fields 'caseSensitive',
#' ## 'accentSensitive', and 'punctuationSensitive', all FALSE by default.
#' attributes(thesaurus)
#'
#' ## Any of them can be set by the user if desired:
#' thesaurus2 <- ReadThesaurus(thesaurusFile, accentSensitive = TRUE)
#' attributes(thesaurus2)
#'
#' ## Write the thesarus to a file:
#' fileExample <- file.path(tempdir(), "thesaurusExample.csv")
#' WriteThesaurus(thesaurus, fileExample)
#' ## Replace tempdir() for your preferred local path if you want to easily
#' ## examine the written file.
#'
#' ## Read a thesaurus set:
#' thesaurusSetFile <- system.file("extdata", "zoologThesaurusSet.csv", package="zoolog")
#' thesaurusSet <- ReadThesaurusSet(thesaurusSetFile)
#' ## The attributes of the thesaurus set include information of the constituent
#' ## thesauri: names, source file names, and their mode of application on datasets.
#' attributes(thesaurusSet)
#' ## The attributes of each thesaurus are also set by 'ReadThesaurusSet'.
#' attributes(thesaurusSet$measure)
#'
#' ## Write the thesaurus set to a file:
#' fileSetExample <- file.path(tempdir(), "thesaurusSetExample.csv")
#' WriteThesaurusSet(thesaurusSet, fileSetExample)
#' ## It writes the thesaurus-set main data frame and each of the included
#' ## thesaurus files.
#' ## Again, replace tempdir() for your preferred local path if you want to
#' ## easily examine the written files.
#'
#' @seealso
#' \code{\link{zoologThesaurus}} for a description of the thesaurus and
#' thesaurus set structure,
#'
#' \code{\link{ThesaurusManagement}},
#' \code{\link{StandardizeNomenclature}}

#' @name ThesaurusReaderWriter

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurus <- function(file,
                          caseSensitive = FALSE,
                          accentSensitive = FALSE,
                          punctuationSensitive = FALSE)
{
  thesaurus <- utils::read.csv2(file, stringsAsFactors = FALSE, header = FALSE,
                                comment.char = "#")
  names(thesaurus) <- thesaurus[1,]
  attrib <- ReadThesaurusAttributes(file)
  for(sensitive in c("caseSensitive", "accentSensitive", "punctuationSensitive"))
  {
    if(!eval(call("missing", as.name(sensitive))) || is.null(attrib[[sensitive]]))
      attrib[[sensitive]] <- eval(as.name(sensitive))
    attr(thesaurus, sensitive) <- attrib[[sensitive]]
  }
  if(ambiguity <- ThesaurusAmbiguity(thesaurus))
    stop(paste0("Ambiguous thesaurus in ", file , ":\n",
                attr(ambiguity, "errmessage")))
  return(thesaurus)
}

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurusSet <- function(file)
{
  data <- utils::read.csv2(file, comment.char = "#")
  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  thesaurusSet <- mapply(ReadThesaurus, filenames,
                         data$CaseSensitive, data$AccentSensitive,
                         data$PunctuationSensitive)
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
  WriteThesaurusAttributes(thesaurus, file)
  utils::write.table(thesaurus, file,
                     sep = ";", dec = ",", qmethod = "double",
                     row.names = FALSE, col.names = FALSE, quote = FALSE,
                     append = TRUE)
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
  data$AccentSensitive <- sapply(zoologThesaurus,
                                 function(x) attr(x, "accentSensitive"))
  data$PunctuationSensitive <- sapply(zoologThesaurus,
                                 function(x) attr(x, "punctuationSensitive"))
  data$ApplyToColNames <- attr(thesaurusSet, "applyToColNames")
  data$ApplyToColValues <- attr(thesaurusSet, "applyToColValues")
  utils::write.csv2(data, file, row.names = FALSE, quote = FALSE)

  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  filenames <- file.path(dir, data$FileName)
  noreturn <- mapply(WriteThesaurus, thesaurusSet, filenames)
}

ReadThesaurusAttributes <- function(file)
{
  x <- ReadCommentLines(file)
  attrib <- list()
  for(sensitive in c("caseSensitive", "accentSensitive", "punctuationSensitive"))
  {
    value <- as.logical(GetAfterPattern(x, sensitive))
    if(length(value) > 0) attrib[[sensitive]] <- value[1]
  }
  return(attrib)
}

WriteThesaurusAttributes <- function(thesaurus, file)
{
  commentLine = c("##########################################")
  lines = c(commentLine, "## zoolog thesaurus")
  for(sensitive in c("caseSensitive", "accentSensitive", "punctuationSensitive"))
    lines = c(lines, paste("##", sensitive, attr(thesaurus, sensitive)))
  lines = c(lines, commentLine)
  writeLines(lines, file)
}
