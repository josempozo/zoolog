#' Example dataset
#'
#' The dataset provided as an example originates from
#' \insertCite{valenzuela2008alimentacio}{zoolog}. The dataset is written in
#' Catalan, with the exception of some headings to facilitate understanding of
#' its contents.
#'
#' @importFrom Rdpack reprompt
#'
#' @format
#' The dataset is provided in the \pkg{zoolog} \code{extdata} folder as a file
#' in semicolon-separated values format but compressed with
#' gzip to reduce its size:
#' \describe{
#'   \item{`dataValenzuelaLamas2008.csv.gz`}{}
#' }
#' The file is provided in UTF-8 encoding. The file encoding is relevant
#' because the dataset contains accents and special characters that needs to be
#' correctly displayed. It can
#' be directly open by `utils::read.csv2`, provided that the correct
#' encoding is set (see examples below).
#'
#' Every row of the data.frame refers to one individual bone fragment unless
#' otherwise stated in the \emph{Observations} field ("Observacions").
#'
#' All the measurements are expressed in millimetres and were obtained with a
#' manual calliper.
#'
#' The main headings in the database are:
#' \describe{
#'   \item{Site}{The faunal remains from three Iron Age archaeological sites were recorded
#' 	(ALP = Alorda Park, TFC = Turó de la Font de la Canya, OLD = Olèrdola).}
#'   \item{N inv	}{A correlative number for each fragment.}
#'   \item{UE}{Refers to the Stratigraphic Unit (SU in English).}
#'   \item{Especie}{Refers to the species.}
#'   \item{Os}{Refers to the skeletal element.}
#'   \item{Fragment}{Refers to the preserved part in the vertical axis (distal, proximal, diaphysis,
#'	 etc.).}
#'   \item{Lat}{Bone laterality: right (d) or left (e).}
#'   \item{Vora}{Refers to the preserved part in relation to the circumference (c), or a vertically,
#' 	 transversally and obliquely fragmented (sto).}
#'   \item{Fract}{Refers to fracture during field excavation or lab work.}
#'   \item{Tafo}{Refers to anthropic and post-depositional alterations.}
#'   \item{Grau}{Refers to degree of bone alteration in a scale from 0 (no alteration) to 4 (diaphysis completely altered).}
#'   \item{Epif}{Degree of fusion: s= fused, ns= unfused, ec = fusion visible. Also tooth wear is recorded here following \insertCite{gardeisen1997exploitation}{zoolog}.}
#'   \item{Sexe}{Sex: male (masc) / female (fem).}
#'   \item{Traces}{Refers to butchery marks. It may also include other observations.}
#'   \item{Observacions}{Observations.}
#'   \item{Recinte}{Refers to the number of silo structure (e.g. SJ8) or the room (e.g. AB)
#' 	from which the material originates.}
#'   \item{TPQ}{Absolute chronology in Terminus Post Quem.}
#'   \item{TAQ}{Absolute chronology in Terminus Ante Quem.}
#'  \item{Period}{Chronological phasing.}
#'  \item{Capsa}{Box number that contains the item.}
#'  \item{Measurement codes }{The nomenclature follows \insertCite{von1976guide}{zoolog}.}
#' }
#'
#' @examples
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package="zoolog")
#' dataExample <- utils::read.csv2(dataFile,
#'                                 na.strings = "",
#'                                 encoding = "UTF-8",
#'                                 stringsAsFactors = TRUE)
#'
#' @references
#'   \insertAllCited{}
#'
#' @name dataValenzuelaLamas2008
#' @docType data
NULL
