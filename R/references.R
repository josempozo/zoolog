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
#'   \item{Standard}{The value of the measurement taken on the bone.
#'     All the measurements are expressed in millimetres.}
#' }
#'
#' @section Data Source:
#' Currently, the references include reference values for the main domesticates
#' and their agriotypes (\emph{Bos}, \emph{Ovis}, \emph{Capra},
#' \emph{Sus}), and red deer (\emph{Cervus elaphus}) drawn from the
#' following publications and resources:
#'
#' \describe{
#'   \item{**Cattle - *Bos***}{\describe{
#'     \item{Nieto}{*Bos taurus*. Female cow dated to the Early Bronze Age
#'       (Minferri, Catalonia), in \insertCite{nieto2018element;textual}{zoolog}.
#'     }
#'     \item{Basel}{*Bos taurus*. Inv.nr. 2426 (Hinterwälder; female; 17 years old;
#'       live weight: 340 kg; withers height: 113 cm), from
#'       \insertCite{stopp2018Basel;textual}{zoolog}.}
#'     \item{Degerbøl}{*Bos primigenius*. Female aurochs from
#'       \insertCite{degerbol1970urus;textual}{zoolog}.}
#'     \item{Johnstone}{*Bos taurus*. Standard values from means of cattle
#'       measures from Period II (Late Iron Age to Romano-British transition)
#'       of Elms Farm, Heybridge
#'       \insertCite{johnstone2002late}{zoolog}.}
#'   }}
#'   \item{**Sheep - *Ovis***}{\describe{
#'     \item{Davis}{*Ovis aries*. Mean values of measurements from a group of adult female
#'       Shetland sheep skeletons from a single flock
#'     \insertCite{davis1996measurements}{zoolog}.
#'     }
#'     \item{Basel}{*Ovis musimon*. Inv.nr. 2266 (male; adult), from
#'       \insertCite{stopp2018Basel;textual}{zoolog}.}
#'     \item{Clutton}{*Ovis aries*. Mean measurements from a group of male Soay
#'       sheep of known age
#'       \insertCite{clutton1990osteology}{zoolog}.}
#'     \item{Uerpmann}{*Ovis orientalis*. Field Museum of Chicago catalogue
#'       number: FMC 57951 (female; western Iran)
#'       from \insertCite{uerpmann1994animal;textual}{zoolog}.}
#'   }}
#'   \item{**Goat - *Capra***}{\describe{
#'     \item{Basel}{*Capra hircus*. Inv.nr. 1597 (male; adult), from
#'       \insertCite{stopp2018Basel;textual}{zoolog}.}
#'     \item{Clutton}{*Capra hircus*. Mean measurements from a group of goats of unknown age
#'       and sex \insertCite{clutton1990osteology}{zoolog}.}
#'     \item{Uerpmann}{Measurements based on female and male *Capra aegagrus*,
#'       Natural History Museum in London number: BMNH 651 M and L2 (Taurus
#'       Mountains in southern Turkey) from
#'       \insertCite{uerpmann1994animal;textual}{zoolog}.}
#'   }}
#'   \item{**Pig - *Sus***}{\describe{
#'     \item{Albarella}{*Sus domesticus*. Mean measurements from a group of Late Neolithic
#'       pigs from Durrington Walls, England
#'       \insertCite{albarella2005neolithic}{zoolog}.}
#'     \item{Basel}{*Sus scrofa*. Inv.nr. 1446 (male; 2-3 years old; life
#'       weight: 120 kg) from \insertCite{stopp2018Basel;textual}{zoolog}.}
#'     \item{Hongo}{*Sus scrofa*. Averaged left and right measurements of a
#'       female wild board from near Elaziğ, Turkey. Museum of Comparative
#'       Zoology, Harvard University, specimen #51621
#'       \insertCite{hongo2000faunal}{zoolog}.}
#'     \item{Payne}{Measurements based on a sample of modern wild boar,
#'       *Sus scrofa libycus*, (male and female; Kizilcahamam, Turkey) from
#'       \insertCite{payne1988components;textual}{zoolog}, Appendix 2.}
#'   }}
#'   \item{**Red deer - *Cervus elaphus***}{\describe{
#'     \item{Basel}{*Cervus elaphus*. Inv.nr. 2271 (male; adult) from
#'       \insertCite{stopp2018Basel;textual}{zoolog}.}
#'   }}
#' }
#'
#' The \pkg{zoolog} variable `referencesDatabase` collects all these
#' references. It is structured as a named list of named lists, following the
#' hierarchy described above:
#' ``` {r}
#' str(referencesDatabase, max.level = 2)
#' ````
#'
#' @section Reference Sets:
#' The references' database is organized per taxon. However, in general the
#' zooarchaeological data to be analysed includes several taxa. Thus, the
#' reference dataframe should include one reference standard for each relevant
#' taxon.
#' The \pkg{zoolog} variable \code{referenceSets} defines four possible
#' references:
#' ``` {r, eval = FALSE}
#' referenceSets
#' ```
#'
#' ``` {r, echo=FALSE}
#' refSetsAux <- referenceSets
#' refSetsAux[is.na(refSetsAux)] <- ""
#' knitr::kable(refSetsAux)
#' ```
#'
#' Each row defines a reference set consisting of a reference source for
#' each taxon (column). The function
#' \code{\link{AssembleReference}} allows us to build the reference set
#' taking the selected taxon-specific references from the
#' \code{referencesDatabase}.
#'
#' The \pkg{zoolog} variable \code{reference} is a named list including the
#' references defined by \code{referenceSets}:
#' ``` {r}
#' str(reference)
#' ````
#'
#' `reference$Combi` includes the most comprehensive reference for each
#' species so that more measurements can be considered. It is the default
#' reference for computing the [log ratios][LogRatios].
#'
#' If desired, the user can define their own combinations or can also use
#' their own references, which must be a dataframe with the format described
#' above.
#'
#' @section File Structure:
#' `referencesDatabase`, `refereceSets`, and `reference` are exported variables
#' automatically loaded in memory. In addition, \pkg{zoolog} provides in the
#' \code{extdata} folder a set of semicolon separated files (csv), generating
#' them:
#' \describe{
#'   \item{`referenceSets.csv`}{Defines `referenceSets`.}
#'   \item{`referencesDatabase.csv`}{Defines the structure of
#'     `referencesDatabase`.}
#'   \item{...}{A csv file for each taxon-specific reference, as named in
#'     `referencesDatabase.csv`.}
#' }
#' ``` {r}
#' utils::read.csv2(system.file("extdata", "referencesDatabase.csv",
#'                              package = "zoolog"))
#' ```
#'
#' @references
#'   \insertAllCited{}
#'
#' @section Acknowledgement:
#' We are grateful to Barbara Stopp and Sabine
#' Deschler-Erb for providing the Basel references
#' \insertCite{stopp2018Basel}{zoolog}
#' together with the permission to publish them as part of \pkg{zoolog}.
#'
#' We thank also Francesca Slim and Dimitris Filioglou for providing the
#' Groningen references
#' \insertCite{degerbol1970urus,uerpmann1994animal,hongo2000faunal}{zoolog}.
#'
#' We thank Claudia Minniti for providing Johnstone's references
#' \insertCite{johnstone2002late}{zoolog}.
#'
#' @name referencesDatabase
#' @rdname referencesDatabase
"reference"

#' @format
#'
#' @rdname referencesDatabase
"referenceSets"

#' @format
#'
#' @rdname referencesDatabase
"referencesDatabase"

