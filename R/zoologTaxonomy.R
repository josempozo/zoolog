#' Taxonomy hierarchy for \pkg{zoolog}
#'
#' The taxonomy hierarchy for all taxa included in the osteometrical references
#' of the package \pkg{zoolog}.
#' This is used to allow the users to group the taxa by any taxonomical category
#' from \emph{species} to \emph{family}. See
#' \code{\link{Subtaxonomy}}.
#'
#' @importFrom Rdpack reprompt
#'
#' @format
#' The taxonomy is given as a data.frame with columns for
#' ``` {r, echo=FALSE, results='asis'}
#' res <- zoolog:::FormatListOfNames(names(zoologTaxonomy), c("\\emph{", "}"))
#' cat(paste0(" ", res, "."))
#' ```
#' Each row lists the information for one species:
#'
#' ``` {r, echo=FALSE}
#' knitr::kable(zoologTaxonomy)
#' ```
#'
#' @section File Structure:
#' \code{zoologTaxonomy} is an exported variable automatically loaded in
#' memory. In addition, the csv source file \code{zoologTaxonomy.csv}
#' generating it is included in the \pkg{zoolog} \code{extdata} folder.
#'
"zoologTaxonomy"

