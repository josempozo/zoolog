#' Thesaurus Set for \pkg{zoolog}
#'
#' The thesaurus set defined for the package \pkg{zoolog}.
#' This is used to make the methods robust to different nomenclatures used
#' in datasets created by different authors.
#' The \code{zoologThesaurus} is generated from an internal thesaurus set
#' structured by language. The set of available languages can be
#' accessed and the active languages can be controlled by the user
#' (see \code{\link{ActiveLanguages}}). The language defining the standard
#' nomenclature can also be controlled by the user (see
#' \code{\link{SetStandardLanguage}}). Alternativelly, the user can use other
#' thesaurus sets or modify the provided thesaurus set (see
#' \code{\link{ThesaurusManagement}} and \code{\link{ThesaurusReaderWriter}}).
#'
#' @format
#' A thesaurus set is an object of an S3 class named "thesaurusSet". It
#' comprises a list of thesauri with additional attributes:
#' \describe{
#'   \item{names}{Character vector with the name of each thesaurus.}
#'   \item{applyToColNames}{Logical vector indicating whether each thesaurus
#'           should be applied to the column names of the data frame.}
#'   \item{applyToColValues}{Logical vector indicating whether each thesaurus
#'           should be applied to the values in the corresponding column of
#'           the data frame.}
#'   \item{filename}{Character vector with the source file of each thesaurus.}
#'   \item{class}{"thesaurusSet".}
#' }
#'
#' The examples below show the list of four thesauri included in the provided
#' \code{zoologThesurus}.
#'
#' Each thesaurus is an object of an S3 class named "thesaurus", internally
#' based on a list of categories and some additional attributes. Each category
#' is a vector of characters, representing terms with equivalent meaning in the
#' intended application. The name of each list element identifies the category
#' and is used as the standard when applying
#' \code{\link{StandardizeNomenclature}}.
#'
#' The terms in each category must not be included in any other, since this
#' would make the thesaurus ambiguous (see \code{\link{ThesaurusAmbiguity}}).
#'
#' Each thesaurus has the following attributes:
#' \describe{
#'   \item{names}{The name identifying the categories and their standard name
#'           by default.}
#'   \item{sensitiveness}{A named logical vector indicating the sensitiveness
#'           of the thesaurus with respect to the following aspects:
#'           \describe{
#'           \item{\code{caseSensitive:}}{Should the terms in the thesaurus be
#'                 considered case-sensitive?}
#'           \item{\code{accentSensitive:}}{Should the terms be differentiated
#'                 by the presence of accent marks?}
#'           \item{\code{punctuationSensitive:}}{Should the terms be
#'                 differentiated by the presence of punctuation marks?}
#'           \item{\code{wordOrderSensitive:}}{Should multi-word terms be
#'                 differentiated by the order of the words?}
#'   }}
#'   \item{description}{Character summarazing the thesaurus purpose and/or
#'           source.}
#'   \item{class}{"thesaurus".}
#' }
#'
#' The class "thesaurus" has a specialized method print, which conveniently
#' formats the list of categories and the sensitiveness and
#' description in a more readable form (see \code{\link{print.thesaurus}}).
#'
#' Each thesaurus has different sensitiveness.
#' The identifier thesaurus is case, accent, and punctuation insensitive, so
#' that, for instance, "Especie" is equivalent to "ESPECIE" or "Espècie".
#' The taxon thesaurus is case, accent, and punctuation insensitive, so that
#' "Bos" is equivalent to "bos" or "Bos.".
#' The element thesaurus is case, accent, punctuation, and also word-order
#' insensitive, so that "Molar 1 inferior" is equivalent to "Inferior Molar 1".
#' In contrast, the measure thesaurus is case, punctuation and word-order
#' sensitive, so that, for instance, "Dd" is distinguished from "DD".
#'
#' The examples below show the content and characteristics of the identifier
#' thesaurus in \code{zoologThesaurus}.
#'
#' @section File Structure:
#' \code{zoologThesaurus} is an exported variable automatically loaded in
#' memory. It is automatically generated from an internal thesaurus structured
#' by languages and according to the selected active languages and standard
#' language. In addition,
#' the source files generating the internal thesarus are included in the
#' \pkg{zoolog} \code{extdata} folder. There is one file for the thesaurus set
#' main structure, one file for each included thesaurus, and one file for each
#' available language in each thesaurus. All of them are in json format.
#' Thus, they can be examined and/or modified in any text editor.
#' The files are:
#' \describe{
#'   \item{\code{zoologThesaurusSet.json}}{Defines the main structure of the
#'     thesaurus set. It has a main key declaring the class,
#'     \code{thesaurusSet}, and four subkeys: \code{description},
#'     \code{thesaurus} (including the name and the filename (without
#'     extension) of each included thesaurus), \code{applyToColNames}, and
#'     \code{applyToColValues} (logical vectors; their meaning coinciding with
#'     the description above).}
#'   \item{\code{identifierThesaurus.json}}{Thesaurus for the identifiers
#'     typically used as column names in zooarchaeological data. This file gives
#'     the language structure of the thesaurus. It has a main key declaring the
#'     class, \code{thesaurusLanguageSet}, and three subkeys:
#'     \code{description}, \code{sensitiveness} (with one subkey for each type
#'     as described above), and \code{language} (including the name and the
#'     filename (without extension) of each included language).}
#'   \item{\code{identifierThesaurus_####.json}}{Each of the listed files,
#'     presenting the corresponding contribution to the thesaurus by one of the
#'     languages. They have a main key declaring the class,
#'     \code{thesaurus}, and two subkeys: \code{description} and
#'     \code{categories}. The latter includes one entry for each term category.
#'     In particular, this includes the categories required by
#'     \code{\link{LogRatios}} to identify the bone types and the measure
#'     names in the data and the references:
#'     \emph{Taxon}, \emph{Element}, \emph{Measure}, and \emph{Standard}.
#'     It also includes other categories structuring the data such as
#'     \emph{Site}, \emph{Stratigraphic Unit}, \emph{Chronology}, and
#'     \emph{Laterality}, among others.}
#'   \item{\code{taxonThesaurus.json}}{Thesaurus for the taxa.
#'     This file gives the language structure of the thesaurus and the
#'     sensitiveness.}
#'   \item{\code{taxonThesaurus_####.json}}{Each of the listed files for each
#'     language. There is one entry for each category of taxon considered.}
#'   \item{\code{elementThesaurus.json}}{Thesaurus for the skeletal elements.
#'     This file gives the language structure of the thesaurus and the
#'     sensitiveness.}
#'   \item{\code{elementThesaurus_####.json}}{Each of the listed files for each
#'     language. One entry for each anatomical element.}
#'   \item{\code{measureThesaurus.json}}{Thesaurus for the measure names. This
#'     thesarurus is not structured by language. Thus, it directly defines the
#'     categories and the sensitiveness. One category entry for each measure.}
#' }
#'
#' For each language-specific thesaurus, except for "Base", the first element
#' of each category defines the corresponding language-specific standard term
#' (see \code{\link{SetStandardLanguage}}).
#'
#' @seealso
#' \code{\link{ThesaurusReaderWriter}}, \code{\link{ThesaurusManagement}},
#' \code{\link{print.thesaurus}}, and \code{\link{ActiveLanguages}}.
#'
#' @examples
#' ## Internally, the characteristics of the thesaurus set are stored
#' ## as attributes
#' attributes(zoologThesaurus)
#' ## They can be better visualized as:
#' summary(zoologThesaurus)
#' ## A more expanded information of its content, included a summary of
#' ## each constituent thesaurus, can be directly printed
#' zoologThesaurus
#' ## Full content of the identifier thesaurus:
#' zoologThesaurus$identifier
#'
"zoologThesaurus"

