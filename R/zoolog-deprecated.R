#' Deprecated functions in package **zoolog**
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' These functions are provided for compatibility with older versions of
#' **zoolog** only, and may be defunct as soon as of the next release.
#'
#' Please, use the recommended replacement functions with equivalent
#' functionality:
#'
#' - \code{NewThesaurus} has been replaced by \code{\link{Thesaurus}}.
#' But mind the new signature if using positional (unnamed) parameters.
#' For instance:
#'   - \code{NewThesaurus(caseSensitive = TRUE)} is directly replaced
#'     by \code{Thesaurus(caseSensitive = TRUE)}
#'   - But \code{NewThesaurus(TRUE)} should be replaced by
#'     \code{Thesaurus(list(), TRUE)}
#'
#' - \code{RemoveRepeatedNames} has been replaced by
#' \code{\link{RemoveRedundantTerms}}.
#'
#' @inheritParams ThesaurusManagement
#' @param caseSensitive,accentSensitive,punctuationSensitive
#' Logical. They set the case, accent, and punctuation sensitiveness
#' (\code{FALSE} by default) of the thesaurus.
#'

#' @name zoolog-deprecated
#' @keywords internal
NULL

#' @rdname zoolog-deprecated
#' @export
NewThesaurus <- function(caseSensitive = FALSE, accentSensitive = FALSE,
                         punctuationSensitive = FALSE)
{
  lifecycle::deprecate_warn("2.0.0",
                            "NewThesaurus()",
                            "Thesaurus()")
  Thesaurus(list(), caseSensitive, accentSensitive, punctuationSensitive)
}

#' @rdname zoolog-deprecated
#' @export
RemoveRepeatedNames <- function(thesaurus)
{
  lifecycle::deprecate_warn("2.0.0",
                            "RemoveRepeatedNames()",
                            "RemoveRedundantTerms()")
  RemoveRedundantTerms(thesaurus)
}
