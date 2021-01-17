#' References
#'
#' Several osteometrical references are provided in \pkg{zoolog} to enable
#' researchers to use the one of their choice. The user can also use their
#' own osteometrical reference if preferred.
#'
#' @format
#' Each reference is a data.frame including 4 columns:
#' \describe{
#'   \item{TAX}{The taxon to which each reference bone belongs.}
#'   \item{EL}{The skeletal element.}
#'   \item{Measure}{The type of measurement taken on the bone.}
#'   \item{Standard}{The value of the measurement taken on the bone.}
#' }
#'
#' @section Data Source:
#' Currently, the references include reference values for the main domesticates
#' and reed deer (\emph{Bos taurus}, \emph{Ovis aries}, \emph{Capra hircus},
#' \emph{Sus domesticus}, and \emph{Cervus elaphus}). originated from the
#' following publications and resources:
#'
#' \describe{
#'   \item{Cattle - Bos taurus}{\enumerate{
#'     \item Nieto-Espinet, A. (2018). Element measure standard biometrical data
#'       from a cow dated to the Early Bronze Age (Minferri, Catalonia), digital
#'       resource, available at:
#'       \url{https://www.researchgate.net/publication/326010953} or
#'       \url{https://doi.org/10.13140/RG.2.2.13512.78081}.
#'     \item \emph{Bos taurus} Inv.nr. 2426: Hinterwälder; female; 17 years old;
#'       live weight: 340 kg; withers height: 113 cm, from reference collection
#'       in the Integrative Prähistorische und Naturwissenschaftliche
#'       Archäologie (IPNA, University of Basel, Switzerland).
#'       Measurements provided by Barbara Stopp and Sabine Deschler-Erb.
#'   }}
#'   \item{Sheep - Ovis aries}{\enumerate{
#'     \item Davis, S. J. (1996). Measurements of a group of adult female
#'       Shetland sheep skeletons from a single flock: a baseline for
#'       zooarchaeologists. Journal of archaeological science, 23(4), 593-612.
#'       Mean values of the adult female Shetland sheep measurements have been
#'       used.
#'     \item \emph{Ovis musimon} Inv.nr. 2266 (Male; adult), from reference
#'       collection in the Integrative Prähistorische und Naturwissenschaftliche
#'       Archäologie (IPNA, University of Basel, Switzerland). Measurements
#'       provided by Barbara Stopp and Sabine Deschler-Erb.
#'     \item Clutton-Brock, J., Dennis-Bryan, K., Armitage, P. L., & Jewell,
#'       P. A. (1990). Osteology of the Soay sheep. Bulletin of the British
#'       Museum, Natural History. Zoology, 56(1), 1-56. Mean measurements from
#'       the Soay sheep males aged.
#'   }}
#'   \item{Goat - Capra hircus}{\enumerate{
#'     \item Clutton-Brock, J., Dennis-Bryan, K., Armitage, P. L., & Jewell,
#'       P. A. (1990). Osteology of the Soay sheep. Bulletin of the British
#'       Museum, Natural History. Zoology, 56(1), 1-56. Mean measurements from
#'       the male/female not aged goats.
#'     \item \emph{Capra hircus} Inv.nr. 1597 (Male; adult), from reference
#'       collection in the Integrative Prähistorische und Naturwissenschaftliche
#'       Archäologie (IPNA, University of Basel, Switzerland). Measurements
#'       provided by Barbara Stopp and Sabine Deschler-Erb.
#'   }}
#'   \item{Red deer - Cervus elaphus}{\enumerate{
#'     \item \emph{Cervus elaphus} Inv.nr.2271 from reference collection in the
#'       Integrative Prähistorische und Naturwissenschaftliche Archäologie
#'       (IPNA, University of Basel, Switzerland). Measurements provided by
#'       Barbara Stopp and Sabine Deschler-Erb.
#'   }}
#' }
#'
#' @section Content of the References:
#' Each of the three references includes:
#' \describe{
#'   \item{\code{\strong{ReferenceNietoDavisAlbarella}}}{Includes the
#'     measurements from a female cow from Late Neolithic Minferri in Catalonia
#'     \insertCite{nieto2018element}{zoolog}, the mean values of the adult
#'     female Shetland sheep measurements described in
#'     \insertCite{davis1996measurements}{zoolog}, and the pig measurements from
#'     \insertCite{albarella2005neolithic}{zoolog}.}
#'   \item{\code{\strong{ReferenceBasel}}}{Includes the measurements compiled
#'     by Barbara Stopp from the reference collection in the Integrative
#'     Prähistorische und Naturwissenschaftliche Archäologie (IPNA, University
#'     of Basel, Switzerland). The specimens included are: \emph{Bos taurus}
#'     Inv.nr. 2426 (Hinterwälder; female; 17 years old; live weight: 340 kg;
#'     withers height: 113 cm), \emph{Ovis musimon} Inv.nr. 2266 (Male; adult),
#'     \emph{Capra hircus} Inv.nr. 1597 (Male; adult), \emph{Sus scrofa} Inv.nr.
#'     1446 (male; 2-3 years old; life weight: 120 kg), \emph{Cervus elaphus}
#'     Inv.nr. 2271 (male; adult).}
#'   \item{\code{\strong{ReferenceCombi}}}{Includes the most comprehensive
#'     reference for each species so that more measurements can be considered:
#'     the Late Neolithic female cow from Minferri site in present-day Catalonia
#'     \insertCite{nieto2018element}{zoolog}, the mean measurements from the
#'     Soay sheep males aged and mean measurements from male/female not aged
#'     goats from \insertCite{clutton1990osteology}{zoolog}, the pig
#'     measurements from Inv.nr. 1446 from IPNA-Basel (male; 2-3 years old; life weight:
#'     120 kg), and the red deer measurements from Inv.nr.2271 from IPNA-Basel
#'     registered by
#'     Barbara Stopp.}
#' }
#'
#' @section File Structure:
#' The three references are exported variables automatically loaded in
#' memory. In addition, they are also provided in semicolon separated format
#' files in the \pkg{zoolog} \code{extdata} folder with corresponding names:
#' \describe{
#'   \item{\code{referenceNietoDavisAlbarella.csv}}{}
#'   \item{\code{referenceBasel.csv}}{}
#'   \item{\code{referenceCombi.csv}}{}
#' }
#'
#' @references
#'   \insertAllCited{}
#'
#' @name references
#' @rdname references
"referenceNietoDavisAlbarella"

#' @format
#'
#' @rdname references
"referenceBasel"

#' @format
#'
#' @rdname references
"referenceCombi"
