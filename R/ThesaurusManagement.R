#' Thesaurus Management
#'
#' Functions to modify and check thesauri.
#'
#' In the function \code{AddToThesaurus} the categories in which to add new
#' names can be specified either as names of a named list given as argument
#' \code{newName} or explicitly in the argument \code{category}. See the
#' examples below illustrating both alternatives.
#'
#' From version 1.2.0 \code{AddToThesurus} directly removes repeated names in
#' the resulting thesaurus.
#'
#' @inheritParams ThesaurusReaderWriter
#' @param newName Character vector or (named) list of character vectors
#' with new names to be added to the thesaurus.
#' @param category Character vector identifying the classes where the
#' new names should be included.
#'
#' @return
#' \code{NewThesaurus} returns an empty thesaurus. This can then be
#' populated by \code{AddToThesaurus}.
#'
#' \code{AddToThesaurus} returns the input thesaurus complemented with new
#' names in the categories identified. If any of the categories is not present
#' in the input thesaurus, new categories are added as required.
#'
#' \code{RemoveRepeatedNames} returns the input thesaurus pruned of redundant
#' names in each category. The redundancy is evaluated in agreement with the
#' case and accent sensitivity of the thesaurus.
#'
#' \code{ThesaurusAmbiguity} returns FALSE if no ambiguity is present. When any
#' ambiguity is found, it returns TRUE with an attribute \code{errmessage}
#' including the names present in more than one category and the
#' the involved categories. This is internally used by
#' \code{\link{ReadThesaurus}} and \code{\link{AddToThesaurus}} to generate an
#' error in case they attempt to read or generate an ambiguous thesaurus.
#'
#' @examples
#' ## Load an example thesaurus:
#' thesaurus <- ReadThesaurus(system.file("extdata", "taxonThesaurus.csv",
#'                                        package="zoolog"))
#' ## with categories
#' names(thesaurus) #  "bos taurus"  "ovis aries"  "sus domesticus"
#' ## Add names to several categories:
#' thesaurusExtended <- AddToThesaurus(thesaurus,
#'                                     c("Kuh", "Schwein"),
#'                                     c("bos taurus","sus domesticus"))
#' ## This adds the name "Kuh" to the category "bos taurus" and
#' ## the name "Schwein" to the category "sus domesticus".
#'
#' ## Generate a new thesaurus and populate it with two categories
#' ## ("red" and "blue"):
#' thesaurusNew <- NewThesaurus()
#' thesaurusNew <- AddToThesaurus(thesaurusNew,
#'                                c("scarlet", "vermilion", "ruby", "cherry",
#'                                  "carmine", "wine"),
#'                                "red")
#' thesaurusNew
#' thesaurusNew <- AddToThesaurus(thesaurusNew,
#'                                c("sky blue", "azure", "sapphire", "cerulean",
#'                                  "navy"),
#'                                "blue")
#' thesaurusNew
#'
#' ## Categories and names can also be included as named list
#' thesaurusNew <- AddToThesaurus(thesaurusNew, list(
#'   blue = c("lapis lazuli", "indigo", "cyan"),
#'   brown = c("hazel", "chocolate-coloured", "brunette", "mousy", "beige")) )
#' thesaurusNew
#'
#' ## Attempt to generate an ambiguous thesaurus
#' try(AddToThesaurus(thesaurusNew, "scarlet", "blue"))
#'
#' ## From version 1.2.0 AddToThesurus directly removes repeated names:
#' AddToThesaurus(thesaurusNew, c("scarlet", "ruby"), "red")
#'
#' ## Remove repeated names in the same category:
#' ## If we included any repetitions
#' thesaurusNew[8:9,1] <- c("scarlet", "ruby")
#' thesaurusNew
#' ## they can be removed with
#' RemoveRepeatedNames(thesaurusNew)
#'
#' @seealso
#' \code{\link{zoologThesaurus}} for a description of the thesaurus and
#' thesaurus set structure,
#'
#' \code{\link{ReadThesaurus}}, \code{\link{WriteThesaurus}},
#' \code{\link{StandardizeNomenclature}}

#' @name ThesaurusManagement

#' @rdname ThesaurusManagement
#' @export
NewThesaurus <- function(caseSensitive = FALSE, accentSensitive = FALSE,
                         punctuationSensitive = FALSE)
{
  thesaurus <- data.frame()
  attr(thesaurus, "caseSensitive") <- caseSensitive
  attr(thesaurus, "accentSensitive") <- accentSensitive
  attr(thesaurus, "punctuationSensitive") <- punctuationSensitive
  return(thesaurus)
}

#' @rdname ThesaurusManagement
#' @export
AddToThesaurus <- function(thesaurus, newName, category = NULL)
{
  if(is.null(category)) category <- names(newName)
  if(is.null(category))
    stop("Missing category: \n",
         "Provided them as names of the argument newName\n",
         "or explicitly in the argument category.")
  standardNames <- StandardizeNomenclature(category, thesaurus)
  newName <- as.list(newName)

  thesNew <- lapply(thesaurus, function(a) a[a!=""])
  for(i in seq_len(length(newName)))
  {
    case <- standardNames[min(i, length(standardNames))]
    thesNew[[case]] <- c(case, thesNew[[case]], newName[[i]])
  }
  thesNew <- ThesaurusFromList(thesNew, attributes(thesaurus))
  if(ambiguity <- ThesaurusAmbiguity(thesNew))
    stop(paste0("The resulting thesaurus would be ambiguous.\n",
                attr(ambiguity, "errmessage")))
  thesNew <- RemoveRepeatedNames(thesNew)
  return(thesNew)
}

#' @rdname ThesaurusManagement
#' @export
RemoveRepeatedNames <- function(thesaurus)
{
  thesClean <- mapply(function(x,y) x[!duplicated(y) & y!=""],
                      thesaurus,
                      NormalizeForSensitiveness(thesaurus),
                      SIMPLIFY = FALSE)
  ThesaurusFromList(thesClean, attributes(thesaurus))
}

#' @rdname ThesaurusManagement
#' @export
ThesaurusAmbiguity <- function(thesaurus)
{
  if(length(thesaurus)<2) return(FALSE)
  thesaurus <- NormalizeForSensitiveness(thesaurus)
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
  if(res) attr(res, "errmessage") <- paste0(names(ambiguities),
                                            ". Shared names: ", ambiguities,
                                            collapse = "\n")
  return(res)
}

#
# From here internal functions. Not exported.
#
ThesaurusFromList <- function(thesaurusList, attrib)
{
  n <- max(sapply(thesaurusList, length))
  thesaurus <- as.data.frame(lapply(thesaurusList,
                                    function(x) c(as.character(x),
                                                  rep("", n-length(x)))),
                             stringsAsFactors = FALSE)
  attr(thesaurus, "caseSensitive") <- attrib$caseSensitive
  attr(thesaurus, "accentSensitive") <- attrib$accentSensitive
  attr(thesaurus, "punctuationSensitive") <- attrib$punctuationSensitive
  names(thesaurus) <- names(thesaurusList)
  return(thesaurus)
}

NormalizeForSensitiveness <- function(thesaurus, x = NULL)
{
  sensitivenessAttrNames <- c("caseSensitive",
                              "accentSensitive",
                              "punctuationSensitive")
  sensitivenessAttr <- unlist(sapply(sensitivenessAttrNames, attr,
                                     x = thesaurus))
  normalizedThesaurus <- lapply(thesaurus, SensitivenessTransformation,
                                sensitivenessAttr)
  if(is.null(x)) return(normalizedThesaurus)

  normalizedX <- SensitivenessTransformation(x, sensitivenessAttr)
  return(list(thesaurus = normalizedThesaurus, x = normalizedX))
}

SensitivenessTransformation <- function(x, sensitiveness)
{
  if(!isTRUE(sensitiveness["caseSensitive"]))
    x <- stringi::stri_trans_general(x, "Any-lower")
  if(!isTRUE(sensitiveness["accentSensitive"]))
    x <- stringi::stri_trans_general(x, "Latin-ASCII")
  if(!isTRUE(sensitiveness["punctuationSensitive"]))
    x <- gsub("[[:punct:][:blank:]]+", "", x)
  return(x)
}
