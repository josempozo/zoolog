#' Value Matching by Thesaurus Category
#'
#' Function to check if an element belongs to a category according to a
#' thesaurus. It is similar to \code{\link[base]{%in%}} and
#' \code{\link[base]{is.element}}, returning a logical vector indicating if each
#' element in a given vector is included in a given set. But \code{InCategory}
#' checks for equality assuming the equivalencies defined in the given thesaurus.
#'
#' @inheritParams StandardizeNomenclature
#' @param x Character vector to be checked for its inclusion in the category.
#' @param category Character vector identifying the categories in which the
#' inclusion of \code{x} will be checked. Each category can be identified by
#' any equivalent name in the thesaurus.
#'
#' @return
#' A logical vector of the same length as \code{x}. Each value answers the
#' question: \emph{Does the corresponding element in \code{x} belongs to any of
#' the thesaurus categories identified by \code{category}?}
#'
#' @seealso
#' \code{\link{zoologThesaurus}}, \code{\link[base]{%in%}}
#'
#' @examples
#' InCategory(c("sheep", "cattle", "goat", "red deer"),
#'            c("Ovis aries", "cabra"),
#'            zoologThesaurus$taxon)
#'
#' @export
InCategory <- function(x, category, thesaurus)
{
  thesList <- lapply(thesaurus, function(a) a[a!=""])
  category <- StandardizeNomenclature(category, thesaurus)
  namesInCategory <- as.character(unlist(thesList[category]))
  SensitiveIn(x, namesInCategory, thesaurus)
}

#
# From here internal functions. Not exported.
#
# Concept definition:
# According to the sensitiveness a term represents a set of terms.
# For a term x, we denote here the set or represented terms as [x].
# For a set x = {x_1, ... x_n}, we denote [x] := union([x_1], ..., [x_n])
# When wordOrderSensitive and punctuationSensitive are both FALSE,
# this does not define equivalent classes. In particular, two terms can
# represent different sets, but with non empty intersection.
# Thus, a careful definition of relationships is required.
#
# For each element of x, is it in y?
# For x_i \in x, is x_i \in [y]?
SensitiveIn <- function(x, y, thesaurus)
{
  if(isFALSE(attr(thesaurus, "wordOrderSensitive")))
    y <- unlist(ExpandWordOrder(y))
  xNormalized <- NormalizeForSensitiveness(x, thesaurus)
  yNormalized <- NormalizeForSensitiveness(y, thesaurus)
  xNormalized %in% yNormalized
}

# For each element of x, is the set of terms it represents a subset of y?
# For x_i \in x, does [x_i] \subset [y]?
SensitiveIncluded <- function(x, y, thesaurus)
{
  if(isFALSE(attr(thesaurus, "wordOrderSensitive")))
  {
    x <- ExpandWordOrder(x)
    y <- unlist(ExpandWordOrder(y))
  }
  x <- lapply(x, function(z) NormalizeForSensitiveness(z, thesaurus))
  y <- NormalizeForSensitiveness(y, thesaurus)
  sapply(x, function(z) any(all(z %in% y)))
}

# Does the i-th element of x and the i-th element of y represent the same set?
# Does [x_i] = [y_i]?
# If y is a single term, then each element of x is compared with it.
SensitiveEqual <- function(x, y, thesaurus)
{
  if(isFALSE(attr(thesaurus, "wordOrderSensitive")))
  {
    x <- ExpandWordOrder(x)
    y <- ExpandWordOrder(y)
  }
  x <- lapply(x, function(z) NormalizeForSensitiveness(z, thesaurus))
  y <- lapply(y, function(z) NormalizeForSensitiveness(z, thesaurus))
  mapply(setequal, x, y)
}

ExpandThesaurusForWordOrderSensitiveness <- function(thesaurus)
{
  if(isFALSE(attr(thesaurus, "wordOrderSensitive")))
  {
    thesList <- lapply(thesaurus, function(a) unique(a[a!=""]))
    thesList <- ExpandWordOrder(thesList)
    thesaurus <- ThesaurusFromList(thesList, attributes(thesaurus))
  }
  return(thesaurus)
}

JointWords <- function(x) paste(x, collapse = " ")
JointWordsPerRow <- function(x) apply(x, 1, JointWords)

WordPermutations <- function(x)
  lapply(lapply(strsplit(x, " "), pracma::perms), JointWordsPerRow)

ExpandWordOrder <- function(x)
  lapply(x, function(y) unique(unlist(WordPermutations(y))))

WordSort <- function(x, collapse = " ")
  sapply(lapply(strsplit(x, " "), sort),
         function(y) paste(y, collapse = collapse))
