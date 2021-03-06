% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AssembleReference.R
\name{AssembleReference}
\alias{AssembleReference}
\title{Assemble Reference}
\usage{
AssembleReference(
  combination,
  ref.db = referencesDatabase,
  thesaurus = zoologThesaurus$taxon
)
}
\arguments{
\item{combination}{A dataframe or named list. Each (column) name identifies a
taxon. Each column or list element must have a single element of type
character, identifying one of the sources included in the references'
database.}

\item{ref.db}{A reference database. This is a named list of named lists of
dataframes. The first level is named by taxon and the second level is named
by reference source. Each dataframe includes the reference for the
corresponding taxon and source. The default
\code{ref.db = \link{referencesDatabase}} is provided as package
\pkg{zoolog} data.}

\item{thesaurus}{A thesaurus for taxa.}
}
\value{
A reference dataframe.
}
\description{
Function to build a reference dataframe selecting a case for each taxon from
the available specimens in the references' database.
}
\examples{
## `referenceSets` includes a series of predefined reference compositions.
referenceSets
## Actually the package `references` is build from them.
## We can rebuild any of them:
referenceCombi <- AssembleReference(referenceSets["Combi", ])

## Define an altenative reference combining differently the references'
## database:
refComb <- list(cattle = "Nieto", sheep = "Davis", Goat = "Clutton",
                pig = "Albarella", redDeer = "Basel")
userReference <- AssembleReference(refComb)

}
