#' Thesaurus Set for \pkg{zoolog}
#'
#' The thesaurus set defined for the package \pkg{zoolog}.
#' This is used to make the methods robust to different nomenclatures used
#' in datasets created by different authors. The user can also use other
#' thesaurus sets, or can modify the provided thesaurus set (see
#' \code{\link{ThesaurusManagement}} and \code{\link{ThesaurusReaderWriter}}).
#'
#' @format
#' A thesaurus set is a list of thesauri with additional attributes:
#' \describe{
#'   \item{names}{Character vector with the name of each thesaurus.}
#'   \item{applyToColNames}{Logical vector indicating whether each thesaurus
#'           should be applied to the column names of the data frame.}
#'   \item{applyToColValues}{Logical vector indicating whether each thesaurus
#'           should be applied to the values in the corresponding column of
#'           the data frame.}
#'   \item{filename}{Character vector with the source file of each thesaurus.}
#' }
#'
#' The examples below show the list of four thesauri included in the provided
#' \code{zoologThesurus}.
#'
#' Each thesaurus is a data frame also with additional attributes. Each column
#' of the data frame is a category of names with equivalent meaning in the
#' intended application. The column name identifies the category and is used
#' as the standard when applying \code{\link{StandardizeNomenclature}}.
#'
#' The names in each column (category) must not be included in any other
#' column, since this would make the thesaurus ambiguous (see
#' \code{\link{ThesaurusAmbiguity}}).
#'
#' Each thesaurus has the following attributes:
#' \describe{
#'   \item{names}{The standard name for the categories.}
#'   \item{class}{"data.frame"}
#'   \item{row.names}{Irrelevant}
#'   \item{caseSensitive}{Logical indicating whether the names in the thesaurus
#'           should be considered case-sensitive.}
#'   \item{accentSensitive}{Logical indicating whether the names in the
#'           thesaurus should be differentiated by the presence of accent
#'           marks.}
#'   \item{punctuationSensitive}{Logical indicating whether the names in the
#'           thesaurus should be differentiated by the presence of punctuation
#'           marks.}
#' }
#'
#' The examples below show the content and characteristics of the first
#' thesaurus in \code{zoologThesaurus}.
#'
#' @section File Structure:
#' \code{zoologThesaurus} is an exported variable automatically loaded in
#' memory. In addition, the source files generating it are included in the
#' \pkg{zoolog} \code{extdata} folder. There is one file for the thesaurus set
#' main structure and one file for each included thesaurus. All of them are in
#' semicolon separated format. Thus, they can be examined in any text editor
#' or imported into any spreadsheet application. The files are:
#' \describe{
#'   \item{\code{zoologThesaurusSet.csv}}{Defines the main structure of the
#'     thesaurus set. It has a row for each thesaurus and seven columns
#'     (\emph{ThesaurusName}, \emph{FileName}, \emph{CaseSensitive},
#'     \emph{AccentSensitive}, \emph{PunctuationSensitive},
#'     \emph{ApplyToColNames}, and \emph{ApplyToColValues}).
#'     Their meaning coincides with the description above. Observe that the
#'     case, accent, and punctuation sensitiveness is stored here, instead of
#'     in each thesaurus.}
#'   \item{\code{identifierThesaurus.csv}}{Thesaurus for the identifiers used
#'     in \code{\link{LogRatios}} to identify the bone types and the measure
#'     names in the data and the references. It has for columns:
#'     \emph{Taxon}, \emph{Element}, \emph{Measure}, and \emph{Standard}.}
#'   \item{\code{taxonThesaurus.csv}}{Thesaurus for the taxa. There is one
#'     column for each category of taxon considered.}
#'   \item{\code{elementThesaurus.csv}}{Thesaurus for the skeletal elements.
#'     One column for each category.}
#'   \item{\code{measureThesaurus.csv}}{Thesaurus for the measure names.
#'     One column for each category.}
#' }
#'
#' @examples
#' ## List of thesaurus names and characteristics in the thesaurus set:
#' attributes(zoologThesaurus)
#' ## Content of the first thesaurus:
#' zoologThesaurus$identifier
#' attributes(zoologThesaurus$identifier)
#'
"zoologThesaurus"

