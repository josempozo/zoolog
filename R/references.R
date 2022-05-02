#' References
#'
#' Several osteometrical references are provided in \pkg{zoolog} to enable
#' researchers to use the one of their choice. The user can also use their
#' own osteometrical reference if preferred.
#'
#' @importFrom Rdpack reprompt
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
#' \emph{Sus}), and other less frequent species, such as red deer and donkey,
#' drawn from the following publications and resources:
#'
#' ``` {r, echo=FALSE, results='asis'}
#' refDatabase <- read.csv2("inst/extdata/referencesDatabase.csv")
#' res <- "\\describe{\n"
#' for(genus in unique(refDatabase$Genus))
#' {
#'   res <- paste0(res, "\\item{**", genus, "**}{\\describe{\n")
#'   for(i in which(refDatabase$Genus == genus))
#'   {
#'     file <- paste0("inst/extdata/", refDatabase$Filename[i])
#'     description <- ReadCommentLines(file)
#'     nameLine <- which(StartsBy(description, "REFERENCE:"))
#'     if(length(nameLine)>0) {
#'       name <- GetAfterPattern(description[nameLine[1]], "REFERENCE:")
#'       description <- description[-nameLine[1]]
#'     } else {
#'       name <- refDatabase$Source[i]
#'     }
#'     res <- paste0(res, "\\item{", name, "}{")
#'     sourceLine <- which(StartsBy(description, "SOURCE:"))
#'     if(length(sourceLine)>0)
#'       description <- description[1:(sourceLine[1]-1)]
#'     description <- paste(description, collapse = "\n")
#'     res <- paste0(res, description)
#'     res <- paste0(res, "}\n")
#'   }
#'   res <- paste0(res, "}}\n")
#' }
#' cat(paste(res, "}\n"))
#' ```
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
#' knitr::kable(referenceSets)
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
#' We are grateful to Barbara Stopp and Sabine Deschler-Erb
#' (University of Basel, Switzerland)
#' for providing the Basel references for cattle, sheep, goat, wild boar,
#' and red deer \insertCite{stopp2018Basel}{zoolog},
#' together with the permission to publish them as part of \pkg{zoolog}.
#'
#' We thank also Francesca Slim and Dimitris Filioglou (University of Groningen)
#' for providing the references for aurochs, mouflon, wild goat, and wild boar
#' \insertCite{degerbol1970urus,uerpmann1994animal,hongo2000faunal}{zoolog}
#' in the Groningen set.
#'
#' We thank Claudia Minniti (University of Salento) for providing Johnstone's
#' reference for cattle \insertCite{johnstone2002late}{zoolog}.
#'
#' We are also grateful to Sierra Harding and Nimrod Marom (University of Haifa)
#' for providing the Haifa standard measurements for donkey, gazelle, and
#' fallow deer \insertCite{Harding2021}{zoolog}.
#'
#' We thank Carly Ameen and Helene Benkert (University of Exeter) for providing
#' references for horse \insertCite{johnstone2004biometric}{zoolog} and rabbit
#' \insertCite{Ameen2021}{zoolog}.
#'
#' We thank Mikolaj Lisowski (University of York) for pointing to the existence
#' of the improved reference for Bos primigenius
#' \insertCite{steppan2001ur}{zoolog} and providing its source.
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

