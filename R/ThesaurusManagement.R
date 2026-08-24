#' Thesaurus Management
#'
#' Functions to modify and check thesauri.
#'
#' In the function \code{AddToThesaurus} the categories in which to add new
#' terms can be specified either as names of a named list given as argument
#' \code{newName} or explicitly in the argument \code{category}. See the
#' examples below illustrating both alternatives.
#'
#' From version 1.2.0 \code{AddToThesurus} directly removes repeated names in
#' the resulting thesaurus.
#'
#' @inheritParams ThesaurusReaderWriter
#' @param term Character vector of terms.
#' @param newName Character vector or named list of character vectors
#' with new terms to be added to the thesaurus.
#' @param category Character vector identifying the categories to be removed or
#' where the new names should be included.
#' @param caseSensitive,accentSensitive,punctuationSensitive,wordOrderSensitive
#' Logical. They set the case, accent, punctuation (\code{FALSE} by default),
#' and word-order sensitivity (\code{TRUE} by default) of the thesaurus.
#'
#' @return
#' \code{NewThesaurus} returns an empty thesaurus. This can then be
#' populated by \code{AddToThesaurus}.
#'
#' \code{AddToThesaurus} returns the input thesaurus complemented with new
#' terms in the categories identified. If any of the categories is not present
#' in the input thesaurus, new categories are added as required.
#'
#' \code{RemoveRepeatedNames} returns the input thesaurus pruned of redundant
#' terms in each category. The redundancy is evaluated in agreement with the
#' case and accent sensitivity of the thesaurus.
#'
#' \code{ThesaurusAmbiguity} returns FALSE if no ambiguity is present. When any
#' ambiguity is found, it returns TRUE with an attribute \code{errmessage}
#' including the names present in more than one category and the
#' the involved categories. This is internally used by
#' \code{\link{ReadThesaurus}} and \code{\link{AddToThesaurus}} to generate an
#' error in case they attempt to read or generate an ambiguous thesaurus.
#'
#' \code{RemoveTermFromThesaurus} returns the thesaurus after removing the
#' specified terms.
#'
#' \code{ChangeStandardInThesaurus} returns the thesaurus where each of the
#' specified terms is set as the standard for category including it.
#'
#' \code{RemoveCategory} returns the thesaurus after removing the specified
#' categories.
#'
#' @examples
#' ## Load an example thesaurus:
#' thesaurus <- ReadThesaurus(system.file("extdata", "taxonThesaurusExample.csv",
#'                                        package="zoolog"))
#' ## with categories
#' names(thesaurus) #  "Bos taurus"  "Ovis aries"  "Sus domesticus"
#' ## Add names to several categories:
#' thesaurusExtended <- AddToThesaurus(thesaurus,
#'                                     c("Kuh", "Schwein"),
#'                                     c("bos taurus","sus domesticus"))
#' ## This adds the name "Kuh" to the category "Bos taurus" and
#' ## the name "Schwein" to the category "Sus domesticus".
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
#' ## From version 2.0.0 AddToThesurus directly removes repeated names:
#' AddToThesaurus(thesaurusNew, c("scarlet", "ruby"), "red")
#'
#' ## Remove repeated names in the same category:
#' ## If we included any repetitions
#' thesaurusNew[8:9,1] <- c("scarlet", "ruby")
#' thesaurusNew
#' ## they can be removed with
#' thesaurusNew <- RemoveRepeatedNames(thesaurusNew)
#' thesaurusNew
#'
#' ## Terms can also be explicitly removed from the thesaurus:
#' thesaurusNew <- RemoveTermFromThesaurus(thesaurusNew,
#'                                         c("vermilion", "cerulean", "indigo"))
#' thesaurusNew
#'
#' ## Also categories can be removed:
#' thesaurusNew <- RemoveCategory(thesaurusNew, "azure")
#' thesaurusNew
#'
#' ## The standard term of any category can be changed to a different term in
#' ## the category:
#' thesaurusNew <- ChangeStandardInThesaurus(thesaurusNew, c("hazel", "wine"))
#' thesaurusNew
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
                         punctuationSensitive = FALSE,
                         wordOrderSensitive = TRUE)
{
  thesaurus <- data.frame()
  attr(thesaurus, "caseSensitive") <- caseSensitive
  attr(thesaurus, "accentSensitive") <- accentSensitive
  attr(thesaurus, "punctuationSensitive") <- punctuationSensitive
  attr(thesaurus, "wordOrderSensitive") <- wordOrderSensitive
  return(thesaurus)
}

#' @rdname ThesaurusManagement
#' @export
AddToThesaurus <- function(thesaurus, newName, category = NULL)
{
  if(is.null(category)) category <- names(newName)
  if(is.null(category))
    stop("Missing category: \n",
         "Provide them as names of the argument newName\n",
         "or explicitly in the argument category.")
  standardNames <- StandardizeNomenclature(category, thesaurus)
  newName <- lapply(newName, function(a) a[a!=""])
  thesNew <- lapply(thesaurus, function(a) a[a!=""])
  newCategories <- setdiff(standardNames, names(thesNew))
  thesNew[newCategories] <- newCategories
  for(i in seq_len(length(newName)))
  {
    category <- standardNames[min(i, length(standardNames))]
    thesNew[[category]] <- c(thesNew[[category]], newName[[i]])
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
#  thesClean <- mapply(function(x,y) x[!duplicated(y) & y!=""],
#                      thesaurus,
#                      lapply(thesaurus, NormalizeForSensitiveness, thesaurus),
#                      SIMPLIFY = FALSE)
  thesList <- lapply(thesaurus, function(a) a[a!=""])
  thesClean <- lapply(thesList, function(a) a[!RedundantTerms(a, thesaurus)])
  ThesaurusFromList(thesClean, attributes(thesaurus))
}

#' @rdname ThesaurusManagement
#' @export
ThesaurusAmbiguity <- function(thesaurus)
{
  if(length(thesaurus)<2) return(FALSE)
  thesaurus <- ExpandThesaurusForWordOrderSensitiveness(thesaurus)
  thesList <- lapply(thesaurus, function(a) a[a!=""])
  thesList <- lapply(thesList, NormalizeForSensitiveness, thesaurus)
  pairs <- utils::combn(names(thesList), 2)
  ambiguities <- list()
  for(i in 1:ncol(pairs))
  {
    pair.coincidence <- thesList[[pairs[1,i]]] %in% thesList[[pairs[2,i]]]
    if(any(pair.coincidence))
    {
      messageTitle <- paste0("Ambiguity in pair (\"",
                             pairs[1,i], "\", \"", pairs[2,i], "\")")
      ambiguities[[messageTitle]] <- thesList[[pairs[1,i]]][pair.coincidence]
    }
  }
  res <- length(ambiguities)>0
  if(res)
    attr(res, "errmessage") <- paste0(names(ambiguities), ". Shared names: ",
                                      ambiguities, collapse = "\n")
  return(res)
}

#' @rdname ThesaurusManagement
#' @export
RemoveTermFromThesaurus <- function(thesaurus, term)
{
  foundTerm <- InCategory(term, names(thesaurus), thesaurus)
  if(!all(foundTerm))
  {
    warning(paste(FormatListOfNames(term[!foundTerm], c("\"", "\""),
                                    c("Term", "Terms"), c("is", "are")),
                  "not present in the thesaurus."))
    term <- term[foundTerm]
  }

  standardTerm <- StandardizeNomenclature(term, thesaurus)
  foundStandard <- SensitiveEqual(term, standardTerm, thesaurus)
  if(any(foundStandard))
  {
    warning(paste("The standard",
                  FormatListOfNames(standardTerm[foundStandard],
                                    c("\"", "\""), c("term", "terms")),
                  "cannot be removed from the thesaurus.\n"),
            "To change the standard term use ChangeStandardInThesaurus.\n",
            "To remove the category from the thesaurus use RemoveCategory.")
    term <- term[!foundStandard]
    standardTerm <- standardTerm[!foundStandard]
  }

  thesNew <- lapply(thesaurus, function(a) a[a!=""])
  for(i in seq_len(length(term)))
  {
    stdTerm <- standardTerm[i]
    termId <- SensitiveEqual(thesNew[[stdTerm]], term[i], thesaurus)
    thesNew[[stdTerm]] <- thesNew[[stdTerm]][!termId]
  }
  thesNew <- lapply(thesNew, function(a) a[!is.na(a)])
  thesNew <- ThesaurusFromList(thesNew, attributes(thesaurus))
  return(thesNew)
}

#' @rdname ThesaurusManagement
#' @export
ChangeStandardInThesaurus <- function(thesaurus, term)
{
  foundTerm <- InCategory(term, names(thesaurus), thesaurus)
  if(!all(foundTerm))
  {
    warning(paste(FormatListOfNames(term[!foundTerm], c("\"", "\""),
                                    c("Term", "Terms"), c("is", "are")),
                  "not present in the thesaurus."))
    term <- term[foundTerm]
  }

  standardTerm <- StandardizeNomenclature(term, thesaurus)

  thesNew <- lapply(thesaurus, function(a) a[a!=""])
  for(i in seq_len(length(term)))
  {
    cathegoryId <- which(names(thesaurus) == standardTerm[i])
    termId <- which(SensitiveEqual(thesNew[[cathegoryId]], term[i], thesaurus))
    names(thesNew)[cathegoryId] <- term[i]
    thesNew[[cathegoryId]][termId[1]] <- thesNew[[cathegoryId]][1]
    thesNew[[cathegoryId]][1] <- term[i]
  }
  thesNew <- lapply(thesNew, function(a) a[!is.na(a)])
  thesNew <- ThesaurusFromList(thesNew, attributes(thesaurus))
  return(thesNew)
}

#' @rdname ThesaurusManagement
#' @export
RemoveCategory <- function(thesaurus, category)
{
  standardCategory <- StandardizeNomenclature(category, thesaurus)

  foundCategory <- standardCategory %in% names(thesaurus)
  if(!all(foundCategory))
  {
    warning(paste(FormatListOfNames(category[!foundCategory], c("\"", "\""),
                                    c("Category", "Categories"),
                                    c("is", "are")),
                  "not present in the thesaurus."))
    standardCategory <- standardCategory[foundCategory]
  }

  thesNew <- lapply(thesaurus, function(a) a[a!=""])
  toRemove <- names(thesaurus) %in% standardCategory
  thesNew <- thesNew[!toRemove]
  thesNew <- lapply(thesNew, function(a) a[!is.na(a)])
  thesNew <- ThesaurusFromList(thesNew, attributes(thesaurus))
  return(thesNew)
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
  for(var in c("caseSensitive", "accentSensitive", "punctuationSensitive",
               "wordOrderSensitive", "description"))
    attr(thesaurus, var) <- attrib[[var]]
  names(thesaurus) <- names(thesaurusList)
  return(thesaurus)
}

NormalizeForSensitiveness <- function(x, thesaurus)
{
  sensitivenessAttrNames <- c("caseSensitive",
                              "accentSensitive",
                              "punctuationSensitive")
  sensitivenessAttr <- unlist(attributes(thesaurus)[sensitivenessAttrNames])
  normalizedX <- SensitivenessTransformation(x, sensitivenessAttr)
  return(normalizedX)
}

SensitivenessTransformation <- function(x, sensitiveness)
{
  if(isFALSE(sensitiveness["caseSensitive"]))
    x <- stringi::stri_trans_general(x, "Any-lower")
  if(isFALSE(sensitiveness["accentSensitive"]))
    x <- stringi::stri_trans_general(x, "Latin-ASCII")
  if(isFALSE(sensitiveness["punctuationSensitive"]))
    x <- gsub("[[:punct:][:blank:]]+", "", x)
  return(x)
}

RedundantTerms <- function(x, thesaurus)
{
  if(isFALSE(attr(thesaurus, "wordOrderSensitive"))) x <- ExpandWordOrder(x)
  x <- lapply(x, function(z) NormalizeForSensitiveness(z, thesaurus))
  redundant <- rep(FALSE, length(x))
  for(i in rev(seq_len(length(x))))
  {
    redundant[i] <- TRUE
    redundant[i] <- all(x[[i]] %in% unlist(x[!redundant]))
  }
  return(redundant)
}

# To remove. (Wrong idea. Kept for the moment just in case useful for something)
#TermInThesaurus <- function(x, thesaurus)
#{
#  zoolog:::NormalizeForSensitiveness(zoolog:::WordSort(x, "\f"), thes)
#  gsub("\f", "", x)
#  thesList <- lapply(thesaurus, function(a) a[a!=""])
#  thesaurusTerms <- as.character(unlist(thesList))
#  sapply(x, function(y) any(SensitiveIn(thesaurusTerms, x, thesaurus)))
#}

