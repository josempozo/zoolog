#' Thesaurus Management
#'
#' Functions to generate, modify, and check thesauri.
#'
#' From version 2.0.0, `thesaurus` has been more cleanly defined as an S3 class.
#' A more general constructor \code{Thesaurus} has been defined, deprecating
#' the previous \code{\link{NewThesaurus}}, and the nomenclature of functions and
#' arguments has been improved. Thus, the function
#' \code{\link{RemoveRepeatedNames}} has been renamed as
#' \code{RemoveRedundantTerms} and the argument \code{newName} as \code{terms}.
#'
#' In the function \code{AddToThesaurus} the categories in which to add new
#' terms can be specified either as names of a named list given as argument
#' \code{terms} or explicitly in the argument \code{category}. See the
#' examples below illustrating both alternatives.
#'
#' @inheritParams ThesaurusReaderWriter
#' @param terms Character vector or named list of character vectors with terms.
#' @param description Character summarizing the thesaurus purpose and/or source.
#' @param newName `r lifecycle::badge("deprecated")` Alias of parameter
#' \code{terms} in \code{AddToThesurus}, for backwards compatibility.
#' @param category Character vector identifying the categories to be removed or
#' where the new terms should be included.
#' @param caseSensitive,accentSensitive,punctuationSensitive,wordOrderSensitive
#' Logical. They set the case, accent, punctuation (\code{FALSE} by default),
#' and word-order sensitivity (\code{TRUE} by default) of the thesaurus.
#'
#' @return
#' \code{Thesaurus} returns a thesaurus including the specified terms and with
#' the requested sensitiveness and description.
#'
#' \code{AddToThesaurus} returns the input thesaurus complemented with new
#' terms in the categories identified. If any of the categories is not present
#' in the input thesaurus, new categories are added as required.
#' From version 2.0.0, any resulting redundant term is silently removed.
#'
#' \code{RemoveFromThesaurus} returns the thesaurus after removing the
#' specified terms and/or the specified categories.
#'
#' \code{RemoveRedundantTerms} returns the input thesaurus pruned of redundant
#' terms in each category. The redundancy is evaluated in agreement with
#' sensitiveness of the thesaurus.
#'
#' \code{ThesaurusAmbiguity} returns FALSE if no ambiguity is present. When any
#' ambiguity is found, it returns TRUE with an attribute \code{errmessage}
#' including the names present in more than one category and the
#' the involved categories. This is internally used by
#' \code{\link{ReadThesaurus}} and \code{\link{AddToThesaurus}} to generate an
#' error in case they attempt to read or generate an ambiguous thesaurus.
#'
#' \code{ChangeStandardInThesaurus} returns the thesaurus after setting each of
#' the specified terms as the standard for the category including it.
#'
#' @examples
#' ## Load an example thesaurus:
#' thesaurus <- ReadThesaurus(system.file("extdata", "taxonThesaurusExample.csv",
#'                                        package="zoolog"))
#' ## with categories
#' names(thesaurus) #  "Bos taurus"  "Ovis aries"  "Sus domesticus"
#' ## Add names to several categories:
#' thesaurusExtended <- AddToThesaurus(thesaurus,
#'                                     list("bos taurus" = "Kuh",
#'                                          "sus domesticus" = "Schwein"))
#' ## This adds the name "Kuh" to the category "Bos taurus" and
#' ## the name "Schwein" to the category "Sus domesticus".
#'
#' ## Generate a new thesaurus populated with two categories ("red" and "blue"):
#' thesaurusNew <- Thesaurus(list(
#'   red = c("scarlet", "vermilion", "ruby", "cherry", "carmine", "wine"),
#'   blue = c("sky blue", "azure", "sapphire", "cerulean", "navy")
#' ))
#' thesaurusNew
#'
#' ## Add new terms to existing category and new categories to the thesaurus:
#' thesaurusNew <- AddToThesaurus(thesaurusNew, list(
#'   blue = c("lapis lazuli", "indigo", "cyan"),
#'   brown = c("hazel", "chocolate-coloured", "brunette", "mousy", "beige")
#' ))
#' thesaurusNew
#'
#' ## Attempt to generate an ambiguous thesaurus
#' try(AddToThesaurus(thesaurusNew, "scarlet", "blue"))
#'
#' ## From version 2.0.0 AddToThesurus directly removes repeated terms:
#' AddToThesaurus(thesaurusNew, c("scarlet", "ruby"), "red")
#'
#' ## Remove repeated names in the same category:
#' ## If we forced the inclusion of repetitions
#' thesaurusNew$red[8:9] <- c("scarlet", "ruby")
#' thesaurusNew
#' ## they can be removed with
#' thesaurusNew <- RemoveRedundantTerms(thesaurusNew)
#' thesaurusNew
#'
#' ## Terms can also be explicitly removed from the thesaurus:
#' thesaurusNew <- RemoveFromThesaurus(thesaurusNew,
#'                                     c("vermilion", "cerulean", "indigo"))
#' thesaurusNew
#'
#' ## Also categories can be removed:
#' thesaurusNew <- RemoveFromThesaurus(thesaurusNew, category = "azure")
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
Thesaurus <- function(terms = list(),
                      caseSensitive = FALSE, accentSensitive = FALSE,
                      punctuationSensitive = FALSE, wordOrderSensitive = TRUE,
                      description = "")
{
  sensitiveness = c(caseSensitive = caseSensitive,
                    accentSensitive = accentSensitive,
                    punctuationSensitive = punctuationSensitive,
                    wordOrderSensitive = wordOrderSensitive)
  terms <- mapply(function(x, y) if(x %in% y) y else c(x, y),
                  names(terms), terms, SIMPLIFY = FALSE)
  Thesaurus0(terms,
             list(sensitiveness = sensitiveness, description = description))
}

Thesaurus0 <- function(terms, traits)
{
  if(!is.list(terms)) terms <- as.list(terms)
  terms <- lapply(terms, function(a) a[a != ""])
  thesaurus <- structure(terms,
                         sensitiveness = traits$sensitiveness,
                         description = traits$description,
                         class = "thesaurus")
  if(ambiguity <- ThesaurusAmbiguity(thesaurus))
    stop("The resulting thesaurus would be ambiguous.\n",
         attr(ambiguity, "errmessage"))
  thesaurus <- RemoveRedundantTerms(thesaurus)
  return(thesaurus)
}

#' @exportS3Method
as.data.frame.thesaurus <- function(x, ...,
                                    check.names = FALSE,
                                    fix.empty.names = FALSE,
                                    stringsAsFactors = FALSE)
{
  n <- max(unlist(sapply(x, length)), 0)
  paddedThes <- lapply(x, function(a) c(as.character(a), rep("", n-length(a))))
  data.frame(paddedThes, row.names = NULL, check.rows = FALSE,
             check.names = check.names, fix.empty.names = fix.empty.names,
             stringsAsFactors = stringsAsFactors)
}

#' @rdname ThesaurusManagement
#' @export
#' @importFrom lifecycle deprecated
AddToThesaurus <- function(thesaurus, terms, category = NULL,
                           newName = deprecated())
{
  if(lifecycle::is_present(newName))
  {
    lifecycle::deprecate_warn("2.0.0",
                              "AddToThesaurus(newName = )",
                              "AddToThesaurus(terms = )")
    if(!missing(terms))
    {
      argumentsByName <- names(as.list(sys.call()[-1]))
      if("terms" %in% argumentsByName || !missing(category))
        stop("Arguments `terms` and `newName` must not be set simultaneously:\n",
             "  `newName` is deprecated and replaced by `terms`.")
      category <- terms
    }
    terms <- newName
  }
  if(is.null(category)) category <- names(terms)
  if(is.null(category))
    stop('Missing category: \n',
         'Provide them as names of the argument "terms"\n',
         'or explicitly in the argument category.')
  standardNames <- StandardizeNomenclature(category, thesaurus)
  newCategories <- setdiff(standardNames, names(thesaurus))
  thesaurus[newCategories] <- newCategories
  for(i in seq_len(length(terms)))
  {
    category <- standardNames[min(i, length(standardNames))]
    thesaurus[[category]] <- c(thesaurus[[category]], terms[[i]])
  }
  if(ambiguity <- ThesaurusAmbiguity(thesaurus))
    stop("The resulting thesaurus would be ambiguous.\n",
         attr(ambiguity, "errmessage"))
  thesaurus <- RemoveRedundantTerms(thesaurus)
  return(thesaurus)
}

#' @rdname ThesaurusManagement
#' @export
RemoveFromThesaurus <- function(thesaurus, terms = NULL, category = NULL)
{
  if(!is.null(terms))
    thesaurus <- RemoveTermFromThesaurus(thesaurus, terms)
  if(!is.null(category))
    thesaurus <- RemoveCategory(thesaurus, category)
  return(thesaurus)
}

#' @rdname ThesaurusManagement
#' @export
RemoveRedundantTerms <- function(thesaurus)
{
  sensitiveness <- attr(thesaurus, "sensitiveness")
  thesaurus[] <- lapply(thesaurus,
                        function(a) a[!RedundantTerms(a, sensitiveness)])
  return(thesaurus)
}

#' @rdname ThesaurusManagement
#' @export
ThesaurusAmbiguity <- function(thesaurus)
{
  if(length(thesaurus)<2) return(FALSE)
  thesaurus <- ExpandThesaurusForWordOrderSensitiveness(thesaurus)
  thesVec <- NormalizeForSensitiveness(unlist(thesaurus, use.names = FALSE),
                                       attr(thesaurus, "sensitiveness"))
  class(thesaurus) <- "list"
  thesList <- utils::relist(thesVec, thesaurus)
  duplications <- duplicated(thesVec)
  if(!any(duplications)) return(FALSE)
  duplications <- unique(thesVec[duplications])
  ambiguities <- list()
  for(term in duplications)
  {
    categories <- names(thesList)[sapply(thesList, function(x) any(x == term))]
    if(length(categories) > 1)
    {
      messageTitle <- paste0("Ambiguity in categories ",
                             FormatListOfNames(categories))
      ambiguities[[messageTitle]] <- c(ambiguities[[messageTitle]], term)
    }
  }
  res <- length(ambiguities)>0
  if(res)
    attr(res, "errmessage") <- paste0(names(ambiguities), ". Shared term",
                                      lapply(ambiguities, FormatListOfNames,
                                             preMessage = c(":", "s:")),
                                      collapse = "\n")
  return(res)
}

#' @rdname ThesaurusManagement
#' @export
ChangeStandardInThesaurus <- function(thesaurus, terms)
{
  foundTerms <- InCategory(terms, names(thesaurus), thesaurus)
  if(!all(foundTerms))
  {
    warning(FormatListOfNames(terms[!foundTerms],
                              preMessage = c("Term", "Terms"),
                              postMessage = c("is", "are")),
            " not present in the thesaurus.")
    terms <- terms[foundTerms]
  }

  standardTerms <- StandardizeNomenclature(terms, thesaurus)
  overwrittenTerms <- duplicated(standardTerms, fromLast = TRUE)
  if(any(overwrittenTerms))
  {
    warning(FormatListOfNames(terms[overwrittenTerms],
                              preMessage = c("Term", "Terms"),
                              postMessage = c("is", "are")),
            " overwritten by following requested standards.")
    terms <- terms[!overwrittenTerms]
    standardTerms <- standardTerms[!overwrittenTerms]
  }

  for(i in seq_len(length(terms)))
  {
    categoryId <- which(names(thesaurus) == standardTerms[i])
    termId <- which(SensitiveEqual(thesaurus[[categoryId]], terms[i],
                                   attr(thesaurus, "sensitiveness")))
    names(thesaurus)[categoryId] <- terms[i]
    thesaurus[[categoryId]][termId[1]] <- thesaurus[[categoryId]][1]
    thesaurus[[categoryId]][1] <- terms[i]
  }
  return(thesaurus)
}

#
# From here internal functions. Not exported.
#
RemoveTermFromThesaurus <- function(thesaurus, terms)
{
  foundTerms <- InCategory(terms, names(thesaurus), thesaurus)
  if(!all(foundTerms))
  {
    warnParent(FormatListOfNames(terms[!foundTerms],
                                 preMessage = c("Term", "Terms"),
                                 postMessage = c("is", "are")),
               " not present in the thesaurus.")
    terms <- terms[foundTerms]
  }

  standardTerms <- StandardizeNomenclature(terms, thesaurus)
  sensitiveness <- attr(thesaurus, "sensitiveness")
  foundStandard <- SensitiveEqual(terms, standardTerms, sensitiveness)
  if(any(foundStandard))
  {
    warnParent(
      "The standard ", FormatListOfNames(standardTerms[foundStandard],
                                         preMessage = c("term", "terms")),
      " cannot be removed from the thesaurus.\n",
      "   * To change the standard term use 'ChangeStandardInThesaurus'.\n",
      "   * To remove the category use the argument 'category'."
    )
    terms <- terms[!foundStandard]
    standardTerms <- standardTerms[!foundStandard]
  }

  for(i in seq_len(length(terms)))
  {
    stdTerm <- standardTerms[i]
    termId <- SensitiveEqual(thesaurus[[stdTerm]], terms[i], sensitiveness)
    thesaurus[[stdTerm]] <- thesaurus[[stdTerm]][!termId]
  }
  return(thesaurus)
}

RemoveCategory <- function(thesaurus, category)
{
  standardCategory <- StandardizeNomenclature(category, thesaurus)

  foundCategory <- standardCategory %in% names(thesaurus)
  if(!all(foundCategory))
  {
    warnParent(FormatListOfNames(category[!foundCategory],
                                 preMessage = c("Category", "Categories"),
                                 postMessage = c("is", "are")),
               " not present in the thesaurus.")
    standardCategory <- standardCategory[foundCategory]
  }

  toRemove <- names(thesaurus) %in% standardCategory
  Thesaurus0(thesaurus[!toRemove], attributes(thesaurus))
}

warnParent <- function(..., levels = 2)
{
  # Call from at most as many levels up. By default (levels = 2)
  # coll the grandparent of `warnParent` if it exist, else its parent.
  parent_call <- sys.call(sys.parent(levels + 1) + 1)
  warning(simpleWarning(paste0(...), call = parent_call))
}

#
# Internal functions for sensitiveness
#
NormalizeForSensitiveness <- function(x, sensitiveness)
{
  if(is.list(x))
  {
    xClass <- class(x)
    class(x) <- "list"
    x <- utils::relist(NormalizeForSensitiveness(unlist(x), sensitiveness), x)
    class(x) <- xClass
    return(x)
  }
  normalizedX <- SensitivenessTransformation(x, sensitiveness)
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

RedundantTerms <- function(x, sensitiveness)
{
  if(isFALSE(sensitiveness["wordOrderSensitive"])) x <- ExpandWordOrder(x)
  x <- NormalizeForSensitiveness(x, sensitiveness)
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
#  sapply(x, function(y) any(SensitiveIn(thesaurusTerms, x,
#                                        attr(thesaurus, "sensitiveness"))))
#}

ThesaurusMissingLanguageStandard <- function(thesaurus)
{
  missingLanguageStandard <- lapply(thesaurus, length) == 0
  missing <- any(missingLanguageStandard)
  if(missing)
  {
    categories <- names(thesaurus)[missingLanguageStandard]
    attr(missing, "errmessage") <- paste0(
      "Missing language standard in thesaurus\n",
      "(", paste(attr(thesaurus, "description"), collapse = " "), "):\n",
      FormatListOfNames(categories)
    )
  }
  return(missing)
}
