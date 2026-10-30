#' Thesaurus Readers and Writers
#'
#' Functions to read and write thesauri and thesaurus sets.
#'
#' Two alternative file formats are accepted: json and csv. In both reading and
#' writing, the file format is determined by the filename extension.
#' The internal \code{\link{zoologThesaurus}} is provided in the
#' \pkg{zoolog} \code{extdata} folder in json format, which is also the
#' recomended file format. This format can be visualized and edited in any
#' text editor, including any R code IDE such as RStudio. It can also be parsed
#' to most modern programming languages.
#'
#' The alternative csv format is actually a semicolon separated format with
#' some additional initial comments complementing the thesaurus attributes.
#' This format can be examined in any text editor or imported into any
#' spreadsheet application.
#'
#' The csv format is compatible with the legacy format used in versions
#' zoolog 1.x, but includes additional information.
#' For this reason, a deprecation warning message is issued when read.
#' This facilitates to upgrade any previous user-defined thesaurus. For this
#' upgrade, the user can simply read the thesaurus with `ReadThesaurus` and
#' directly write it with `WriteThesaurus` in any of the alternative formats,
#' json or csv. Analogously for a thesaurus set, with `ReadThesaurusSet`
#' followed by `WriteThesaurusSet`.
#'
#' @param file Name of a file with extension json (recommended) or csv.
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
#' ## The main features of the thesaurus (description, term categories
#' ## included, and sensitiveness) can be displayed by
#' summary(thesaurus)
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
#' ## The main features of the thesaurus set are summarized by
#' summary(thesaurusSet)
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
#' \code{\link{StandardizeNomenclature}},
#' \code{\link{print.thesaurus}}

#' @name ThesaurusReaderWriter

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurus <- function(file)
{
  x <- ReadDataAndAttributes(file)
  if(is.null(x$traits$class))
    x$data <- LegacyFormatAdaption(x$data, "thesaurus")
  if(is.null(x$traits$class) || x$traits$class == "thesaurus")
  {
    return(tryCatch(Thesaurus0(x$data, x$traits),
                    error = function(e) stop("File ", file , ": ", e[[1]])))
  }
  else if(x$traits$class == "thesaurusLanguageSet")
  {
    return(ReadThesaurusLanguageSet(x, file))
  }
  else
  {
    stop("Not recognized thesaurus class in file.")
  }
}

#' @rdname ThesaurusReaderWriter
#' @export
ReadThesaurusSet <- function(file)
{
  x <- ReadDataAndAttributes(file)
  if(is.null(x$traits$class))
    x$data <- LegacyFormatAdaption(x$data, "thesaurusSet")
  filenames <- InheritFileDirAndExtension(x$data$fileName, file)
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

  filenames <- InheritFileDirAndExtension(attr(thesaurusSet, "fileName"), file)
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
  if(length(underline) > 0)
  {
    if(length(underline) > 1) stop("Bad formating: More than one underline.")
    if(underline == 1) stop("No class declared in file.")
    if(underline > 2) stop("More than one class declared in file.")
    y$traits$class <- y$text[1]
    if(length(y$text) > 2)
      y$traits$description <- utils::tail(y$text, length(y$text) - 2)
  }
  else if(length(y$text) > 0)
  {
    y$traits$description <- y$text
  }
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
ReadDataAndAttributes <- function(file)
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
                             header = TRUE,
                             check.names = FALSE)
    data <- lapply(data, function(a) a[a != ""])
  }
  else if(format == "json")
  {
    thesList <- jsonlite::fromJSON(file)
    traits <- thesList[[1]][c("description", "sensitiveness")]
    traits$sensitiveness <- unlist(traits$sensitiveness)
    traits$class <- names(thesList)
    data <- BuildDataFromJsonList(thesList)
  }
  else
    stop("Wrong file extension in ", file, ".\n",
         "Please use 'json' or 'csv' for the corresponding file formats.")

  if(!is.null(traits$class) && traits$class == "thesaurusSet")
    data <- utils::type.convert(data, as.is = TRUE)
  else
    data <- lapply(data, as.character)
  list(data = data, traits = traits)
}

WriteThesaurus0 <- function(thesaurus, file)
{
  if(!inherits(thesaurus, "thesaurus"))
    stop("Input is not of class 'thesaurus'.")
  WriteDataAndAttributes(thesaurus, file)
}

WriteDataAndAttributes <- function(thesaurus, file)
{
  CreateDirsIfNeeded(file)
  format <- tools::file_ext(file)
  if(format == "csv")
  {
    data <- BuildDataForCSV(thesaurus)
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
    thes <- BuildListForJson(thesaurus)
    jsonlite::write_json(thes, file, pretty = TRUE)
  }
  else
    stop("Wrong file extension in ", file, ".\n",
         "Please use 'json' or 'csv' for the corresponding file formats.")
}


###########################################
# Help functions to write attributes and data
BuildDataForCSV <- function(x)
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
  # A first row is added with the names, instead of
  # argument col.names set to TRUE in write.table.
  # This avoids the warning of write.table when appending.
  data <- rbind(names(data), data)
  return(data)
}

BuildListForJson <- function(x)
{
  if(!inherits(x, c("thesaurus", "thesaurusLanguageSet", "thesaurusSet")))
    stop("Object of unrecognized class.")
  thesList <- list()
  traits <- attributes(x)
  thesList$description <- FormatDescriptionForJson(traits$description)
  thesList$sensitiveness <- FormatSensitivenessForJson(traits$sensitiveness)
  # json is alway UTF-8 encoded. Thus, no need to annotate for it.
  if(inherits(x, "thesaurus"))
  {
    thesList$categories <- lapply(x, as.character)
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

LegacyFormatAdaption <- function(data, class)
{
  # Convert names first character to lowercase.
  lifecycle::deprecate_warn(
    "2.0.0",
    I(paste("Reading thesaurus file in legacy (zoolog 1.x) csv file-format.",
            "This file-format can still be read but")),
    details = c("Please update it to the new json or csv format,
                 using WriteThesaurus or WriteThesaurusSet, as appropriate.",
                "See description in help('WriteThesaurus')."),
    env = rlang::caller_env(),
    user_env = rlang::caller_env(2)
  )
  if(class == "thesaurus")
  {
    data <- mapply(c, names(data), data, SIMPLIFY = FALSE)
  }
  else if(class == "thesaurusSet")
  {
    names(data) <- sub('^(.)', '\\L\\1', names(data), perl=TRUE)
    data <- utils::type.convert(data, as.is = TRUE)
  }
  else
  {
    stop("Not recognized class", class)
  }
  return(data)
}

###########################################
# Help functions to connect with the
# structured by language thesauri:
ReadThesaurusLanguageSet <- function(da, file)
{
  filenames <- InheritFileDirAndExtension(da$data$fileName, file)
  thesaurusSet <- mapply(ReadThesaurusForLanguage, filenames,
                         sensitiveness = da$traits$sensitiveness,
                         SIMPLIFY = FALSE)
  names(thesaurusSet) <- da$data$language
  thesaurusSet <- ThesaurusLanguageSet0(thesaurusSet, da$traits)
  thesaurusSet <- SetFileNames(thesaurusSet, da$data$fileName)
  return(thesaurusSet)
}

ReadThesaurusForLanguage <- function(file, sensitiveness)
{
  da <- ReadDataAndAttributes(file)
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

  filenames <- InheritFileDirAndExtension(attr(thesaurus, "fileName"), file)
  noreturn <- mapply(WriteThesaurus0, thesaurus, filenames)
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

InheritFileDirAndExtension <- function(basenames, file)
{
  dir <- dirname(file)
  filenames <- file.path(dir, basenames)
  ext <- tools::file_ext(file)
  missingExt <- tools::file_ext(filenames) == ""
  stem <- tools::file_path_sans_ext(filenames)
  filenames[missingExt] <- paste0(stem[missingExt], ".", ext)
  return(filenames)
}
