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
#' ## 'accentSensitive', and 'punctuationSensitive', as read from the file.
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
    thesaurus <- ReadThesaurusLanguageSet(da$data, file)
  else
    thesaurus <- da$data

  for(sensitive in c("caseSensitive", "accentSensitive", "punctuationSensitive"))
  {
    if(!is.null(da$attr[[sensitive]]))
      attr(thesaurus, sensitive) <- da$attr[[sensitive]]
  }
  attr(thesaurus, "structuredByLanguage") <- da$attr$structuredByLanguage

  if(!isTRUE(da$attr$structuredByLanguage) &&
     (ambiguity <- ThesaurusAmbiguity(thesaurus)))
  {
    stop(paste0("Ambiguous thesaurus in ", file , ":\n",
                attr(ambiguity, "errmessage")))
  }
  return(thesaurus)
}

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurusSet <- function(file)
{
  data <- ReadDataAndAttributes(file, FALSE)$data
  dir <- dirname(file)
  filenames <- file.path(dir, data$FileName)
  structuredByLanguage <- data$StructuredByLanguage
  if(is.null(structuredByLanguage)) structuredByLanguage <- FALSE
  thesaurusSet <- lapply(filenames, ReadThesaurus)
  names(thesaurusSet) <- data$ThesaurusName
  attr(thesaurusSet, "applyToColNames") <- data$ApplyToColNames
  attr(thesaurusSet, "applyToColValues") <- data$ApplyToColValues
  attr(thesaurusSet, "fileName") <- data$FileName
  return(thesaurusSet)
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurus <- function(thesaurus, file)
{
  structuredByLanguage <- isTRUE(attr(thesaurus, "structuredByLanguage"))
  if(structuredByLanguage)
  {
    data <- thesaurus
    thesaurus <- BuildThesaurusLanguageSetData(thesaurus)
  }

  WriteDataAndAttributes(thesaurus, file, col.names = structuredByLanguage)

  if(structuredByLanguage) WriteThesaurusLanguageSet(data, file)
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
  ReadComplementVariables(
    file,
    c("caseSensitive", "accentSensitive", "punctuationSensitive",
      "structuredByLanguage", "encoding")
  )
}

WriteThesaurusAttributes <- function(thesaurus, file)
{
  commentLine = c("##########################################")
  lines = c(commentLine, "## zoolog thesaurus")
  for(attribute in c("caseSensitive", "accentSensitive",
                     "punctuationSensitive", "structuredByLanguage",
                     "encoding"))
    if(!is.null(attr(thesaurus, attribute)))
      lines = c(lines, paste("##", attribute, attr(thesaurus, attribute)))
  lines = c(lines, commentLine)
  CreateDirsIfNeeded(file)
  writeLines(lines, file)
}

ReadComplementVariables <- function(file, variables)
{
  x <- ReadCommentLines(file)
  attrib <- list()
  for(variable in variables)
  {
    value <- GetAfterPattern(x, variable)
    if(length(value) > 0) attrib[[variable]] <- value[1]
  }
  return(attrib)
}

###########################################
# Read and write data:
ReadThesaurusData <- function(file, encoding, format)
{
  if(format %in% c("columnwise", "rowwise"))
  {
    data <- utils::read.csv2(file, comment.char = "#",
                             stringsAsFactors = FALSE,
                             encoding = encoding,
                             header = FALSE)
    if(format == "rowwise") data <- as.data.frame(t(data))
  }
  if(format == "hocon")
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
  return(data)
}

WriteThesaurusData <- function(thesaurus, file, encoding, format)
{
  if(format %in% c("columnwise", "rowwise"))
  {
    if(format == "rowwise") thesaurus <- as.data.frame(t(thesaurus))
    utils::write.table(thesaurus, file,
                       sep = ";", dec = ",", qmethod = "double",
                       row.names = FALSE, col.names = FALSE,
                       quote = FALSE,
                       append = TRUE, fileEncoding = encoding)
  }
  if(format == "hocon")
  {
    thesaurusList <- lapply(thesaurus, function(a) a[a!=""])
    vectorToHocon <- function(x)
      paste0(x[1], ": [", paste(x[-1], collapse = ", "),"]")
    thesaurusHocon <- sapply(thesaurusList, vectorToHocon)
    fileConn <- file(file, encoding = encoding, open = "a")
    writeLines(thesaurusHocon, fileConn)
    close(fileConn)
  }
}

###########################################
# Read and write attributes and data
# taking into account the string encoding.
# It also allows to write and read in alternative formats:
# columnwise (the default and documented), rowwise, and hocon (simplified).
# The alternative formats can help to modify them more easily.
ReadDataAndAttributes <- function(file, repeatHeader = NULL,
                                  format = "columnwise")
{
  attr <- ReadThesaurusAttributes(file)
  if(is.null(attr$encoding)) attr$encoding <- "unknown"
  if(is.null(repeatHeader)) repeatHeader <- !isTRUE(attr$structuredByLanguage)
  data <- ReadThesaurusData(file, attr$encoding, format)
  names(data) <- data[1,]
  if(!repeatHeader) data <- data[-1,]
  data <- utils::type.convert(data, as.is = TRUE)
  data[is.na(data)] <- ""
  list(data = data, attr = attr)
}

WriteDataAndAttributes <- function(thesaurus, file, col.names = TRUE,
                                   format = "columnwise")
{
  encoding <- GetFirstNonTrivialEncoding(unlist(thesaurus))
  if(encoding != "") attr(thesaurus, "encoding") <- encoding

  WriteThesaurusAttributes(thesaurus, file)
  # Assigning the names as first row instead of write.table argument
  # col.names, avoids its warning when appending.
  if(col.names) thesaurus <- rbind(names(thesaurus), thesaurus)
  WriteThesaurusData(thesaurus, file, encoding, format)
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
  thesaurusSet <- lapply(filenames, ReadThesaurus)
  names(thesaurusSet) <- data$Language
  attr(thesaurusSet, "fileName") <- data$FileName
  return(thesaurusSet)
}

BuildThesaurusLanguageSetData <- function(thesaurus)
{
  data <- as.data.frame(lapply(c("names", "fileName"), attr, x = thesaurus),
                        stringsAsFactors = FALSE)
  names(data) <- c("Language", "FileName")
  attribs <- c("caseSensitive", "accentSensitive", "punctuationSensitive",
               "structuredByLanguage")
  attributes(data)[attribs] <- attributes(thesaurus)[attribs]
  return(data)
}

WriteThesaurusLanguageSet <- function(data, file)
{
  dir <- dirname(file)
  filenames <- file.path(dir, attr(data, "fileName"))
  noreturn <- mapply(WriteThesaurus, data, filenames)
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
