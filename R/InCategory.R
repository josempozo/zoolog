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
#'            c("ovis", "capra"),
#'            zoologThesaurus$taxon)
#'
#' @export
InCategory <- function(x, category, thesaurus)
{
  thesList <- lapply(thesaurus, function(a) a[a!=""])
  category <- StandardizeNomenclature(category, thesaurus)
  namesInCategory <- as.character(unlist(thesList[category]))
  namesInCategory <- NormalizeForSensitiveness(thesaurus, namesInCategory)$x
  x <- NormalizeForSensitiveness(thesaurus, x)$x
  x %in% namesInCategory
}
