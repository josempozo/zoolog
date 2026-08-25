#' Thesaurus Readers and Writers
#'
#' Functions to read and write thesauri and thesaurus sets.
#'
#' @param file Name of a file.
#' @param thesaurus A thesaurus object.
#' @param thesaurusSet A thesaurus set.
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
#' thesaurusFile <- system.file("extdata", "measureThesaurus.csv", package="zoolog")
#' thesaurus <- ReadThesaurus(thesaurusFile)
#' ## The attributes of the thesaurus include the fields 'caseSensitive',
#' ## 'accentSensitive', 'punctuationSensitive', "wordOrderSensitive', and
#' ## 'description' as read from the file.
#' attributes(thesaurus)
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
ReadThesaurus <- function(file)
{
  da <- ReadDataAndAttributes(file)
  if(isTRUE(da$attr$structuredByLanguage))
  {
    thesaurus <- ReadThesaurusLanguageSet(da$data, file)
  }
  else
  {
    thesaurus <- da$data
    if(ambiguity <- ThesaurusAmbiguity(thesaurus))
      stop("Ambiguous thesaurus in ", file , ":\n",
           attr(ambiguity, "errmessage"))
  }

  for(variable in c("caseSensitive", "accentSensitive", "punctuationSensitive",
                    "wordOrderSensitive",
                    "structuredByLanguage", "description"))
  {
    attr(thesaurus, variable) <- da$attr[[variable]]
  }
  return(thesaurus)
}

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurusSet <- function(file)
{
  x <- ReadDataAndAttributes(file, FALSE)
  dir <- dirname(file)
  filenames <- file.path(dir, x$data$FileName)
  thesaurusSet <- lapply(filenames, ReadThesaurus)
  names(thesaurusSet) <- x$data$ThesaurusName
  attr(thesaurusSet, "applyToColNames") <- x$data$ApplyToColNames
  attr(thesaurusSet, "applyToColValues") <- x$data$ApplyToColValues
  attr(thesaurusSet, "fileName") <- x$data$FileName
  attr(thesaurusSet, "description") <- x$attr$description
  return(thesaurusSet)
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurus <- function(thesaurus, file)
{
  if(isTRUE(attr(thesaurus, "structuredByLanguage")))
  {
    WriteThesaurusLanguageSet(thesaurus, file)
  }
  else
  {
    WriteDataAndAttributes(thesaurus, file, col.names = FALSE)
  }
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurusSet <- function(thesaurusSet, file)
{
  data <- data.frame()
  data[1:length(thesaurusSet),"ThesaurusName"] <- names(thesaurusSet)
  data$FileName <- attr(thesaurusSet, "fileName")
  data$ApplyToColNames <- attr(thesaurusSet, "applyToColNames")
  data$ApplyToColValues <- attr(thesaurusSet, "applyToColValues")
  attr(data, "description") <- attr(thesaurusSet, "description")
  WriteDataAndAttributes(data, file)

  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  noreturn <- mapply(WriteThesaurus, thesaurusSet, filenames)
}


###########################################
# From here, internal help functions

###########################################
# Read and write attributes:
ReadThesaurusAttributes <- function(file)
{
  lines <- ReadCommentLines(file)
  y <- ExtractComplementVariables(
    lines,
    c("caseSensitive", "accentSensitive", "punctuationSensitive",
      "wordOrderSensitive", "structuredByLanguage", "encoding")
  )
  y$attrib[["description"]] <- y$text[y$text != ""]
  return(y$attrib)
}

WriteThesaurusAttributes <- function(thesaurus, file)
{
  description <- attr(thesaurus, "description")
  n <- min(max(nchar(description) + 10, 40), 60)
  commentLine = paste(rep("#", n), collapse = "")
  if(is.null(description))
    lines = c(commentLine, "## zoolog thesaurus")
  else
    lines = c(commentLine, paste("##", description))
  for(attribute in c("caseSensitive", "accentSensitive", "punctuationSensitive",
                     "wordOrderSensitive", "structuredByLanguage", "encoding"))
    if(!is.null(value <- attr(thesaurus, attribute)))
      lines = c(lines, paste("##", attribute, value))
  lines = c(lines, commentLine)
  CreateDirsIfNeeded(file)
  writeLines(lines, file)
}

ExtractComplementVariables <- function(text, variables)
{
  attrib <- list()
  for(variable in variables)
  {
    line <- which(StartsBy(text, variable))
    if(length(line) > 0)
    {
      line <- line[1]
      value <- DiscardPattern(text[line], variable)
      attrib[[variable]] <- value
      text <- text[-line]
    }
  }
  return(list(attrib = attrib, text = text))
}

###########################################
# Read and write data:
# Alternative formats are possible depending on the file-extension:
# csv (the default and documented) and hocon (only simplified version).
# The alternative formats can help to modify the thesaurus more easily.
ReadThesaurusData <- function(file, encoding)
{
  format <- tools::file_ext(file)
  if(format == "csv")
  {
    data <- utils::read.csv2(file, comment.char = "#",
                             stringsAsFactors = FALSE,
                             encoding = encoding,
                             header = FALSE)
  }
  else if(format == "hocon")
  {
    dataHocon <- readLines(file, encoding = encoding)
    attrLines <- sapply(dataHocon, function(x) substr(x, 1, 1) == "#")
    dataHocon <- dataHocon[!attrLines]
    hoconToVector <- function(x)
    {
      y <- gsub("\\[|\\]", "", x)
      y <- gsub(":", ",", y)
      y <- gsub(", ", ",", y)
      strsplit(y, ",")
    }
    dataList <- sapply(dataHocon, hoconToVector, USE.NAMES = FALSE)
    data <- ThesaurusFromList(dataList, NULL)
  }
  else
    stop("Wrong file extension in ", file, ".")
  return(data)
}

WriteThesaurusData <- function(thesaurus, file, encoding)
{
  format <- tools::file_ext(file)
  if(format == "csv")
  {
    utils::write.table(thesaurus, file,
                       sep = ";", dec = ",", qmethod = "double",
                       row.names = FALSE, col.names = FALSE,
                       quote = FALSE,
                       append = TRUE, fileEncoding = encoding)
  }
  else if(format == "hocon")
  {
    thesaurusList <- lapply(thesaurus, function(a) a[a!=""])
    vectorToHocon <- function(x)
      paste0(x[1], ": [", paste(x[-1], collapse = ", "),"]")
    thesaurusHocon <- sapply(thesaurusList, vectorToHocon)
    fileConn <- file(file, encoding = encoding, open = "a")
    writeLines(thesaurusHocon, fileConn)
    close(fileConn)
  }
  else
    stop("Wrong file extension in ", file, ".")
}

###########################################
# Read and write attributes and data
# taking into account the string encoding.
ReadDataAndAttributes <- function(file, repeatHeader = NULL)
{
  attr <- ReadThesaurusAttributes(file)
  if(is.null(attr$encoding)) attr$encoding <- "unknown"
  if(is.null(repeatHeader)) repeatHeader <- !isTRUE(attr$structuredByLanguage)
  data <- ReadThesaurusData(file, attr$encoding)
  names(data) <- data[1,]
  if(!repeatHeader) data <- data[-1,]
  rownames(data) <- NULL
  data <- utils::type.convert(data, as.is = TRUE)
  data[is.na(data)] <- ""
  list(data = data, attr = attr)
}

WriteDataAndAttributes <- function(thesaurus, file, col.names = TRUE)
{
  encoding <- GetFirstNonTrivialEncoding(unlist(thesaurus))
  if(encoding != "") attr(thesaurus, "encoding") <- encoding

  WriteThesaurusAttributes(thesaurus, file)
  # Assigning the names as first row instead of write.table argument
  # col.names, avoids its warning when appending.
  if(col.names) thesaurus <- rbind(names(thesaurus), thesaurus)
  WriteThesaurusData(thesaurus, file, encoding)
}

GetFirstNonTrivialEncoding <- function(x)
{
  encodings <- Encoding(x)
  encoding <- encodings[encodings != "unknown"][1]
  if(is.na(encoding)) encoding = ""
  return(encoding)
}

###########################################
# Help functions to connect with the
# structured by language thesauri:
ReadThesaurusLanguageSet <- function(data, file)
{
  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  thesaurusSet <- mapply(ReadThesaurusForLanguage, filenames,
                         repeatHeader = (data$Language == "Base"),
                         SIMPLIFY = FALSE)
  names(thesaurusSet) <- data$Language
  attr(thesaurusSet, "fileName") <- data$FileName
  return(thesaurusSet)
}

ReadThesaurusForLanguage <- function(file, repeatHeader)
{
  da <- ReadDataAndAttributes(file, repeatHeader)
  thesaurus <- da$data
  if(ambiguity <- ThesaurusAmbiguity(thesaurus))
    stop("Ambiguous thesaurus in ", file , ":\n",
         attr(ambiguity, "errmessage"))
  attr(thesaurus, "description") <- da$attr$description
  return(thesaurus)
}

BuildThesaurusLanguageSetData <- function(thesaurus)
{
  data <- as.data.frame(lapply(c("names", "fileName"), attr, x = thesaurus),
                        stringsAsFactors = FALSE)
  names(data) <- c("Language", "FileName")
  attribs <- c("caseSensitive", "accentSensitive", "punctuationSensitive",
               "wordOrderSensitive", "structuredByLanguage", "description")
  attributes(data)[attribs] <- attributes(thesaurus)[attribs]
  return(data)
}

WriteThesaurusLanguageSet <- function(thesaurus, file)
{
  thesaurusSetData <- BuildThesaurusLanguageSetData(thesaurus)
  WriteDataAndAttributes(thesaurusSetData, file, col.names = TRUE)
  dir <- dirname(file)
  filenames <- file.path(dir, attr(thesaurus, "fileName"))
  noreturn <- mapply(WriteDataAndAttributes, thesaurus, filenames,
                     col.names = (names(thesaurus) != "Base"))
}

CreateDirsIfNeeded <- function(file)
{
  dir <- dirname(file)
  dirsToCreate <- c()
  while (!file.exists(dir))
  {
    dirsToCreate <- c(dir, dirsToCreate)
    dir <- dirname(dir)
  }
  for(dir in dirsToCreate)
  {
    dir.create(dir)
  }
}
