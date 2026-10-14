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
#' ## Read a thesaurus for measures:
#' thesaurusFile <- system.file("extdata", "measureThesaurus.json",
#'                              package="zoolog")
#' thesaurus <- ReadThesaurus(thesaurusFile)
#' ## The attributes of the thesaurus include the fields 'sensitiveness',
#' ## and 'description' as read from the file.
#' attributes(thesaurus)
#'
#' ## Write the thesarus to a file:
#' fileExample <- file.path(tempdir(), "thesaurusExample.json")
#' WriteThesaurus(thesaurus, fileExample)
#' ## Replace tempdir() for your preferred local path if you want to easily
#' ## examine the written file.
#'
#' ## Read a thesaurus set:
#' thesaurusSetFile <- system.file("extdata", "zoologThesaurusSet.json",
#'                                 package="zoolog")
#' thesaurusSet <- ReadThesaurusSet(thesaurusSetFile)
#' ## The attributes of the thesaurus set include information of the constituent
#' ## thesauri: names, source file names, and their mode of application on datasets.
#' attributes(thesaurusSet)
#' ## The attributes of each thesaurus are also set by 'ReadThesaurusSet'.
#' attributes(thesaurusSet$measure)
#'
#' ## Write the thesaurus set to a file:
#' fileSetExample <- file.path(tempdir(), "thesaurusSetExample.json")
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
  if(da$traits$class == "thesaurusLanguageSet")
  {
    thesaurus <- ReadThesaurusLanguageSet(da, file)
    return(thesaurus)
  }
  else
  {
    tryCatch(Thesaurus0(da$data, da$traits),
             error = function(e) stop("File ", file , ": ", e[[1]]))
  }
}

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurusSet <- function(file)
{
  x <- ReadDataAndAttributes(file, FALSE)
  dir <- dirname(file)
  filenames <- file.path(dir, x$data$fileName)
  thesaurusSet <- lapply(filenames, ReadThesaurus)
  names(thesaurusSet) <- x$data$thesaurusName
  ThesaurusSet(thesaurusSet,
               x$data$applyToColNames, x$data$applyToColValues,
               x$traits$description, x$data$fileName)
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurus <- function(thesaurus, file)
{
  if(inherits(thesaurus, "thesaurusLanguageSet"))
  {
    WriteThesaurusLanguageSet(thesaurus, file)
  }
  else if(inherits(thesaurus, "thesaurus"))
  {
    WriteThesaurus0(thesaurus, file)
  }
  else
  {
    stop("Input is not of class 'thesaurus' or 'thesaurusLanguageSet'.")
  }
}

#' @rdname ThesaurusReaderWriter
#' @export
WriteThesaurusSet <- function(thesaurusSet, file)
{
  if(!inherits(thesaurusSet, "thesaurusSet"))
    stop("Input is not of class 'thesaurusSet'.")
  if(is.null(attr(thesaurusSet, "fileName")))
    attr(thesaurusSet, "fileName") <- MakeFileNames(thesaurusSet)

  WriteDataAndAttributes(thesaurusSet, file)

  dir <- dirname(file)
  filenames <- file.path(dir, attr(thesaurusSet, "fileName"))
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
      "wordOrderSensitive", "encoding")
  )
  y$traits <- JoinSensitivenessVector(y$traits)
  y$text <- y$text[y$text != ""]
  underline <- which(stringi::stri_count_fixed(y$text, "-") == nchar(y$text))
  if(length(underline) == 0) underline <- length(y$text) + 1
  if(length(underline) > 1) stop("Bad formating: More than one underline.")
  if(underline == 1) stop("No class declared in file.")
  if(underline > 2) stop("More than one class declared in file.")

  y$traits$class <- y$text[1]
  if(length(y$text) > 2)
    y$traits$description <- utils::tail(y$text, length(y$text) - 2)
  return(y$traits)
}

WriteThesaurusAttributes <- function(traits, file)
{
  description <- traits$description
  n <- min(max(nchar(description) + 10, 40), 60)
  commentLine <- paste(rep("#", n), collapse = "")
  lines <- c(commentLine, paste("##", traits$class),
             paste("##", paste(rep("-", nchar(traits$class)), collapse = "")))
  if(!is.null(description))
    lines <- c(lines, paste("##", description))
  traits <- ExpandSensitivenessVector(traits)
  for(x in c("caseSensitive", "accentSensitive", "punctuationSensitive",
             "wordOrderSensitive", "encoding"))
    if(!is.null(value <- traits[[x]]))
      lines <- c(lines, paste("##", x, value))
  lines <- c(lines, commentLine)
  writeLines(lines, file)
}

ExtractComplementVariables <- function(text, variables)
{
  traits <- list()
  for(variable in variables)
  {
    line <- which(StartsBy(text, variable))
    if(length(line) > 0)
    {
      line <- line[1]
      value <- DiscardPattern(text[line], variable)
      traits[[variable]] <- value
      text <- text[-line]
    }
  }
  return(list(traits = traits, text = text))
}

JoinSensitivenessVector <- function(traits)
{
  sensNames <- c("caseSensitive", "accentSensitive", "punctuationSensitive",
                 "wordOrderSensitive")
  sensitiveness = unlist(traits[sensNames])
  traits[sensNames] <- NULL
  traits$sensitiveness = sensitiveness
  return(traits)
}

ExpandSensitivenessVector <- function(traits)
{
  sensitiveness <- traits$sensitiveness
  traits$sensitiveness <- NULL
  c(traits, sensitiveness)
}

###########################################
# Read and write attributes and data
# taking into account the file format and the string encoding.
# Alternative formats are possible depending on the file-extension:
# json (default) and csv.
# The alternative formats can help to modify the thesaurus more easily.
ReadDataAndAttributes <- function(file, repeatHeader = NULL)
{
  format <- tools::file_ext(file)
  if(format == "csv")
  {
    traits <- ReadThesaurusAttributes(file)
    if(is.null(traits$encoding)) traits$encoding <- "unknown"
    data <- utils::read.csv2(file, comment.char = "#",
                             stringsAsFactors = FALSE,
                             colClasses = "character",
                             encoding = traits$encoding,
                             header = FALSE)
    data <- lapply(data, function(a) a[a != ""])
    names(data) <- as.character(lapply(data, function(a) a[1]))
    if(is.null(repeatHeader)) repeatHeader <- (traits$class == "thesaurus")
    if(!repeatHeader) data <- lapply(data, function(a) a[-1])
  }
  else if(format == "json")
  {
    thesList <- jsonlite::fromJSON(file)
    traits <- thesList[[1]][c("description", "sensitiveness")]
    traits$sensitiveness <- unlist(traits$sensitiveness)
    traits$class <- names(thesList)
    data <- BuildDataFromJsonList(thesList)
    if(is.null(repeatHeader)) repeatHeader <- (traits$class == "thesaurus")
    if(repeatHeader) data <- mapply(c, names(data), data)
  }
  else
    stop("Wrong file extension in ", file, ".\n",
         "Please use 'json' or 'csv' for the corresponding file formats.")

  data <- utils::type.convert(data, as.is = TRUE)
  list(data = data, traits = traits)
}

WriteThesaurus0 <- function(thesaurus, file, rm.first = TRUE)
{
  if(!inherits(thesaurus, "thesaurus"))
    stop("Input is not of class 'thesaurus'.")
  WriteDataAndAttributes(thesaurus, file, rm.first)
}

WriteDataAndAttributes <- function(thesaurus, file, rm.first = FALSE)
{
  CreateDirsIfNeeded(file)
  format <- tools::file_ext(file)
  if(format == "csv")
  {
    data <- BuildDataForCSV(thesaurus, rm.first)
    encoding <- GetFirstNonTrivialEncoding(unlist(data))
    if(encoding != "") attr(thesaurus, "encoding") <- encoding
    WriteThesaurusAttributes(attributes(thesaurus), file)
    utils::write.table(data, file,
                       sep = ";", dec = ",", quote = FALSE,
                       row.names = FALSE, col.names = FALSE,
                       append = TRUE, fileEncoding = encoding)
  }
  else if(format == "json")
  {
    thes <- BuildListForJson(thesaurus, rm.first)
    jsonlite::write_json(thes, file, pretty = TRUE)
  }
  else
    stop("Wrong file extension in ", file, ".\n",
         "Please use 'json' or 'csv' for the corresponding file formats.")
}


###########################################
# Help functions to write attributes and data
BuildDataForCSV <- function(x, rm.first)
{
  if(inherits(x, "thesaurus"))
  {
    data <- as.data.frame(x)
  }
  else if(inherits(x, "thesaurusLanguageSet"))
  {
    data <- as.data.frame(attributes(x)[c("names", "fileName")])
    names(data) <- c("language", "fileName")
  }
  else if(inherits(x, "thesaurusSet"))
  {
    traitNames <- c("names", "fileName", "applyToColNames", "applyToColValues")
    data <- as.data.frame(attributes(x)[traitNames])
    names(data) <- c("thesaurusName", "fileName", "applyToColNames",
                     "applyToColValues")
  }
  else
    stop("Object of unrecognized class.")
  # if rm.first is false, a first row is added with the names, instead of
  # argument col.names set to TRUE in write.table.
  # This avoids the warning of write.table when appending.
  if(!rm.first) data <- rbind(names(data), data)
  return(data)
}

BuildListForJson <- function(x, rm.first)
{
  if(!inherits(x, c("thesaurus", "thesaurusLanguageSet", "thesaurusSet")))
    stop("Object of unrecognized class.")
  thesList <- list()
  traits <- attributes(x)
  thesList$description <- FormatDescriptionForJson(traits$description)
  thesList$sensitiveness <- FormatSensitivenessForJson(traits$sensitiveness)
  # json is alway UTF-8 encoded. Thus, no need to annotate for it.
  if(rm.first) x[] <- lapply(x, function(y) y[-1])
  if(inherits(x, "thesaurus"))
  {
    thesList$categories <- unclass(x)
    return(list(thesaurus = thesList))
  }
  else if(inherits(x, "thesaurusLanguageSet"))
  {
    thesList$language <- lapply(traits$fileName, jsonlite::unbox)
    names(thesList$language) <- names(x)
    return(list(thesaurusLanguageSet = thesList))
  }
  else if(inherits(x, "thesaurusSet"))
  {
    thesList$thesaurus <- lapply(traits$fileName, jsonlite::unbox)
    names(thesList$thesaurus) <- names(x)
    thesList$applyToColNames <- traits$applyToColNames
    thesList$applyToColValues <- traits$applyToColValues
    return(list(thesaurusSet = thesList))
  }
}

FormatDescriptionForJson <- function(description)
{
  if(is.null(description)) return(NULL)
  if(length(description) == 1)
    return(jsonlite::unbox(description))
  else
    return(lapply(description, jsonlite::unbox))
}

FormatSensitivenessForJson <- function(sensitiveness)
{
  if(is.null(sensitiveness)) return(NULL)
  return(lapply(sensitiveness, jsonlite::unbox))
}

GetFirstNonTrivialEncoding <- function(x)
{
  encodings <- Encoding(x)
  encoding <- encodings[encodings != "unknown"][1]
  if(is.na(encoding)) encoding = ""
  return(encoding)
}

BuildDataFromJsonList <- function(thesList)
{
  x <- thesList[[1]]
  data <- list()
  if(names(thesList) == "thesaurus")
  {
    data <- lapply(x$categories, as.character)
  }
  else if(names(thesList) == "thesaurusLanguageSet")
  {
    data$language <- names(x$language)
    data$fileName <- unlist(x$language)
  }
  else if(names(thesList) == "thesaurusSet")
  {
    data$thesaurusName <- names(x$thesaurus)
    data$fileName <- unlist(x$thesaurus)
    data$applyToColNames <- x$applyToColNames
    data$applyToColValues <- x$applyToColValues
  }
  else
    stop("Unrecongnized class in json file.")
  return(data)
}

###########################################
# Help functions to connect with the
# structured by language thesauri:
ReadThesaurusLanguageSet <- function(da, file)
{
  dir <- dirname(file)
  filenames <- file.path(dir, da$data$fileName)
  thesaurusSet <- mapply(ReadThesaurusForLanguage, filenames,
                         repeatHeader = (da$data$language == "Base"),
                         sensitiveness = da$traits$sensitiveness,
                         SIMPLIFY = FALSE)
  names(thesaurusSet) <- da$data$language
  thesaurusSet <- ThesaurusLanguageSet0(thesaurusSet, da$traits)
  thesaurusSet <- SetFileNames(thesaurusSet, da$data$fileName)
  return(thesaurusSet)
}

ReadThesaurusForLanguage <- function(file, repeatHeader, sensitiveness)
{
  da <- ReadDataAndAttributes(file, repeatHeader)
  # The Ambiguity must be tested with sensitiveness
  da$traits$sensitiveness <- sensitiveness
  thes <- Thesaurus0(da$data, da$traits)
  attr(thes, "sensitiveness") <- NULL
  return(thes)
}

WriteThesaurusLanguageSet <- function(thesaurus, file)
{
  if(!inherits(thesaurus, "thesaurusLanguageSet"))
    stop("Input is not of class 'thesaurusLanguageSet'.")
  if(is.null(attr(thesaurus, "fileName")))
     attr(thesaurus, "fileName") <- MakeFileNames(thesaurus)

  WriteDataAndAttributes(thesaurus, file)

  dir <- dirname(file)
  filenames <- file.path(dir, attr(thesaurus, "fileName"))
  noreturn <- mapply(WriteThesaurus0, thesaurus, filenames,
                     rm.first = (names(thesaurus) == "Base"))
}

###########################################

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
