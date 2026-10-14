ThesaurusLanguageSet <- function(
    thesaurus,
    caseSensitive = FALSE, accentSensitive = FALSE,
    punctuationSensitive = FALSE, wordOrderSensitive = TRUE,
    description = NULL, fileName = NULL
)
{
  sensitiveness = c(caseSensitive = caseSensitive,
                    accentSensitive = accentSensitive,
                    punctuationSensitive = punctuationSensitive,
                    wordOrderSensitive = wordOrderSensitive)
  ThesaurusLanguageSet0(thesaurus, list(sensitiveness = sensitiveness,
                                        description = description,
                                        fileName = fileName))
}

ThesaurusLanguageSet0 <- function(thesaurus, traits)
{
  thesaurusLangSet <- structure(thesaurus,
                      sensitiveness = traits$sensitiveness,
                      description = traits$description,
                      fileName = traits$fileName,
                      class = "thesaurusLanguageSet")
  CheckThesaurusLanguageSet(thesaurusLangSet)
  return(thesaurusLangSet)
}

CheckThesaurusLanguageSet <- function(thesaurusSet)
{
  if(!inherits(thesaurusSet, "thesaurusLanguageSet"))
    stop("The object is not of class 'thesaurusLanguageSet.")
  if(is.null(names(thesaurusSet)) || any(names(thesaurusSet) == ""))
    stop("The list of thesauri lack names to identify the languages.")
  CheckElementsAreOfClass(thesaurusSet, "thesaurus")

  includeSensitiveness <- as.logical(
    sapply(thesaurusSet, function(x) !is.null(attr(x, "sensitiveness")))
  )
  if(any(includeSensitiveness))
    warning(FormatListOfNames(names(thesaurusSet)[includeSensitiveness],
                              preMessage = c("Thesaurus", "Thesauri"),
                              postMessage = c("includes its", "include their")),
            " own sensitiveness.\n",
            "  This will be ignored.")
  CheckVectorAttribute(thesaurusSet, "fileName", "character")
}

ThesaurusSet <- function(
    thesaurus,
    applyToColNames, applyToColValues,
    description = NULL, fileName = NULL
)
{
  thesaurusSet <- structure(thesaurus,
                            applyToColNames = applyToColNames,
                            applyToColValues = applyToColValues,
                            description = description,
                            fileName = fileName,
                            class = "thesaurusSet")
  CheckThesaurusSet(thesaurusSet)
  return(thesaurusSet)
}

CheckThesaurusSet <- function(thesaurusSet)
{
  if(!inherits(thesaurusSet, "thesaurusSet"))
    stop("The object is not of class 'thesaurusSet.")
  if(is.null(names(thesaurusSet)) || any(names(thesaurusSet) == ""))
    stop("The list of thesauri lack names to identify them.")
  CheckElementsAreOfClass(thesaurusSet, c("thesaurus", "thesaurusLanguageSet"))

  CheckVectorAttribute(thesaurusSet, "applyToColNames", "logical")
  CheckVectorAttribute(thesaurusSet, "applyToColValues", "logical")
  CheckVectorAttribute(thesaurusSet, "fileName", "character")
}

CheckElementsAreOfClass <- function(x, class.)
{
  isOfClass <- sapply(x, class) %in% class.
  if(any(!isOfClass))
    stop(FormatListOfNames(names(x[!isOfClass]),
                           preMessage = c("Element", "Elements"),
                           postMessage = c("is", "are")),
         " not of class ",
         FormatListOfNames(class., formatMarks = "'", conjunction = "or"),
         call. = FALSE)
}

ToCamelCase <- function(x)
{
  x <- gsub(pattern = "\\b([a-z])", replacement = "\\U\\1", x, perl = TRUE)
  x <- gsub(pattern = "\\W", replacement = "", x, perl = TRUE)
  return(x)
}

MakeFileNames <- function(thesaurusSet,
                          root = stringi::stri_rand_strings(1, 20),
                          format = "json")
{
  description <- attr(thesaurusSet, "description")[1]
  if(missing(root) && !is.null(description) && description != "")
    root <- ToCamelCase(description)
  paste0(root, "/", root, "_", names(thesaurusSet), ".", format)
}

SetFileNames <- function(thesaurusSet, fileNames)
{
  SetVector(thesaurusSet, fileNames, "fileName", "character")
}

SetVector <- function(thesaurusSet, vector, name, class.)
{
  attr(thesaurusSet, name) <- vector
  CheckVectorAttribute(thesaurusSet, name, class.)
  return(thesaurusSet)
}

CheckVectorAttribute <- function(thesaurusSet, name, class.)
{
  vector <- attr(thesaurusSet, name)
  if(is.null(vector)) return()
  if(!inherits(vector, class.))
    stop("'", name, "' must be a ", class., " vector.")
  if(length(vector) != length(thesaurusSet))
    stop("'", name, "' must have the same length as the thesaurus set.")
}
