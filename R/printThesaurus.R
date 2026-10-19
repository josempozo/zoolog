#' Print thesauri to the terminal
#'
#' Functions to print thesauri and thesaurus sets in a human readable form.
#'
#' @param x,object A thesaurus, thesaurusSet, or thesaurusLanguageSet.
#' @param ... Additional arguments to be passed to other methods.
#' @param full Logical (\code{FALSE} by default). Should the
#' thesaurusLanguageSet fully print its constituent thesauri for every language?
#' @param title Character string to be used as title for the View interface.
#'
#' @return
#' All these functions return the input object invisibly.
#'
#' @examples
#' ## Print the thesaurus for identifiers:
#' zoologThesaurus$identifier
#' ## Or just a summary:
#' summary(zoologThesaurus$identifier)
#'
#' ## Printing the full thesaurusSet includes a summary for
#' ## each included thesaurus:
#' zoologThesaurus
#' ## But its summary prints a table with the characteristics of
#' ## its constituent thesauri:
#' summary(zoologThesaurus)
#'
#' ## Printing a thesaurusByLanguage just gives a summary by default,
#' ## listing the languages included and the full set of term categories:
#' zoolog:::zoologThesaurusByLanguage$identifier

#' @name print.thesaurus

#' @rdname print.thesaurus
#' @exportS3Method
print.thesaurus <- function(x, ...)
{
  PrintDescription(attributes(x)$description, "-")
  PrintCategoryAndTerms(x)
  PrintSensitiveness(attributes(x)$sensitiveness)
  invisible(x)
}

#' @rdname print.thesaurus
#' @exportS3Method
summary.thesaurus <- function(object, ...)
{
  PrintDescription(attributes(object)$description, "-")
  PrintCategories(names(object))
  PrintSensitiveness(attributes(object)$sensitiveness)
  invisible(object)
}

#' @rdname print.thesaurus
#' @exportS3Method
print.thesaurusSet <- function(x, ...)
{
  PrintDescription(attributes(x)$description, "=")
  traitNames <- c("names", "applyToColNames", "applyToColValues")
  print(as.data.frame(attributes(x)[traitNames]))
  PrintWithNames(x, summary)
  invisible(x)
}

#' @rdname print.thesaurus
#' @exportS3Method
summary.thesaurusSet <- function(object, ...)
{
  da <- attributes(object)[c("applyToColNames", "applyToColValues")]
  sensitiveness <- sapply(object, attr, which = "sensitiveness")
  for(sens in row.names(sensitiveness))
    da[[sens]] <- as.logical(sensitiveness[sens, ])
  languageSet <- sapply(object, function(x) class(x) == "thesaurusLanguageSet")
  da[["languageSet"]] <- as.logical(languageSet)
  da <- as.data.frame(da)
  row.names(da) <- attr(object, "names")
  attr(da, "description") <- attr(object, "description")
  PrintDescription(attr(da, "description"), "-")
  print(da)
}

#' @rdname print.thesaurus
#' @exportS3Method
print.thesaurusLanguageSet <- function(x, full = FALSE, ...)
{
  PrintDescription(attributes(x)$description, "-")
  PrintCategories(attributes(x)$names, "languages")
  if(!full) PrintCategories(unique(unlist(lapply(x, names), use.names = FALSE)),
                            "\ncategories")
  PrintSensitiveness(attributes(x)$sensitiveness)
  if(full) PrintWithNames(x)
  invisible(x)
}

#' @rdname print.thesaurus
#' @exportS3Method
summary.thesaurusLanguageSet <- function(object, ...)
{
  print.thesaurusLanguageSet(object, ...)
}

#' @rdname print.thesaurus
#' @export
View <- function(x, title = as.character(match.call())[2])
{
  if(inherits(x, "thesaurus"))
    x <- as.data.frame(x)
  get("View", envir = as.environment("package:utils"))(x, title)
}

#
# From here internal functions. Not exported.
#
PrintDescription <- function(description, underline = "")
{
  if(!(is.null(description) || isTRUE(description == "")))
  {
    cat(paste(description, collapse = "\n"))
    cat(paste0(c("\n", rep(underline, max(nchar(description)))), collapse = ""))
    cat("\n")
  }
}

PrintSensitiveness <- function(sensitiveness)
{
  if(!is.null(sensitiveness))
  {
    cat("\nsensitiveness:\n")
#    cat("\nSENSITIVENESS:\n")
    print(sensitiveness)
  }
  invisible(NULL)
}

PrintCategories<- function(categories, title = "categories")
{
  cat(paste0(title, ":\n  "))
#  cat(paste0(stringi::stri_trans_toupper(title), ":\n  "))
  cat(FormatVectorInLines(categories, 2, cli::console_width()))
}

PrintWithNames <- function(x, func = print, ...)
{
  for(name in names(x))
  {
    cat(paste0("\n$", name, "\n"))
    func(x[[name]], ...)
  }
}

PrintCategoryAndTerms <- function(thes, truncate = FALSE)
{
  lineLength <- cli::console_width()
  a <- mapply(FormatNamedVector, names(thes), thes,
              min(max(nchar(names(thes))), 20), lineLength, truncate,
              USE.NAMES = FALSE)
  cat(paste0(a, collapse = ""))
}

FormatNamedVector <- function(x, y, alignment, lineLength, truncate)
{
  firstIndent <- paste0(rep(" ", max(alignment - nchar(x), 0)), collapse = "")
  paste0(firstIndent, cli::col_br_blue(cli::style_italic(x)), ": ",
         FormatVectorInLines(y, alignment + 2, lineLength,
                             max(nchar(x) - alignment, 0), truncate))
}

FormatVectorInLines <- function(y, indent, lineLength,
                                firstLineAdditionalIndent = 0,
                                truncate = FALSE)
{
  indentSpace <- paste0(rep(" ", indent), collapse = "")
  elemLengths <- nchar(y) + 2
  cumLengths <- cumsum(elemLengths) + firstLineAdditionalIndent
  yInLines <- c()
  alreadySetId <- rep(FALSE, length(y))
  while(!all(alreadySetId))
  {
    setToLineId <- !alreadySetId & (cumLengths < lineLength - indent - 3)
    if(truncate && !all(setToLineId))
      setToLineId <- !alreadySetId & (cumLengths < lineLength - indent - 7)
    if(!any(setToLineId))
      setToLineId[which(!alreadySetId)[1]] <- TRUE
    yInLines <- c(yInLines, paste0(y[setToLineId], collapse = ", "))
    alreadySetId[setToLineId] <- TRUE
    cumLengths[!alreadySetId] <-
      cumLengths[!alreadySetId] - cumLengths[max(which(setToLineId))]
    if(truncate && !all(alreadySetId))
    {
      alreadySetId <- TRUE
      yInLines <- paste0(yInLines, ", ...")
    }
  }
  paste0(paste0(yInLines, collapse = paste0(",\n", indentSpace)), "\n")
}
