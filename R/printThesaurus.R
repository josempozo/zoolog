#' @exportS3Method
print.thesaurus <- function(x, ...)
{
  PrintDescription(attributes(x)$description, "-")
  print(as.data.frame(x), ...)
  PrintSensitiveness(attributes(x)$sensitiveness)
  invisible(x)
}

#' @exportS3Method
summary.thesaurus <- function(object, ...)
{
  PrintDescription(attributes(object)$description, "-")
  PrintCategories(names(object))
  PrintSensitiveness(attributes(object)$sensitiveness)
  invisible(object)
}

#' @exportS3Method
print.thesaurusSet <- function(x, ...)
{
  PrintDescription(attributes(x)$description, "=")
  traitNames <- c("names", "applyToColNames", "applyToColValues")
  print(as.data.frame(attributes(x)[traitNames]))
  lPrintWithNames(x, summary)
  invisible(x)
}

#' @exportS3Method
summary.thesaurusSet <- function(object, ...)
{
  da <- attributes(object)[c("applyToColNames", "applyToColValues")]
  sensitiveness <- sapply(object, attr, which = "sensitiveness")
  for(sens in row.names(sensitiveness))
  {
    what <- sens#stringi::stri_replace_last_fixed(sens, "Sensitive", "")
    da[[what]] <- as.logical(sensitiveness[sens, ])
  }
  languageSet <- sapply(object, function(x) class(x) == "thesaurusLanguageSet")
  da[["LanguageSet"]] <- as.logical(languageSet)
  da <- as.data.frame(da)
  row.names(da) <- attr(object, "names")
  attr(da, "description") <- attr(object, "description")
  PrintDescription(attr(da, "description"), "-")
  print(da)
}

#' @exportS3Method
print.thesaurusLanguageSet <- function(x, full = FALSE, ...)
{
  PrintDescription(attributes(x)$description, "-")
  PrintCategories(attributes(x)$names, "Languages")
  if(!full) PrintCategories(unique(unlist(lapply(x, names), use.names = FALSE)),
                            "\nCategories")
  PrintSensitiveness(attributes(x)$sensitiveness)
  if(full) lPrintWithNames(x)
  invisible(x)
}

#' @exportS3Method
summary.thesaurusLanguageSet <- function(object, ...)
{
  print.thesaurusLanguageSet(object, ...)
}

#' @export
View <- function(x, title = as.character(match.call())[2])
{
  if("thesaurus" %in% class(x))
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
    cat("\nSensitiveness:\n")
    print(sensitiveness)
  }
  invisible(NULL)
}

PrintCategories<- function(categories, title = "Categories")
{
  cat(paste0(title, ":\n   "))
  cat(paste(categories, collapse = ", "), "\n")
}

lPrintWithNames <- function(x, func = print, ...)
{
  for(name in names(x))
  {
    cat(paste0("\n$", name, "\n"))
    func(x[[name]], ...)
  }
}
