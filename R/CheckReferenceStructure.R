# Function to help checking the structure of the reference dataset.
# It will check if the included colnames, measures and taxa are included in the
# corresponding thesaurus.
CheckReferenceStructure <- function(ref)
{
  if(!is.data.frame(ref)) {
    for(name in names(ref))
    {
      print(paste("Checking", name))
      CheckReferenceStructure(ref[[name]])
    }
  } else {
    CheckRefColNames(ref)
    CheckReferenceForNewTerms(ref, "TAX", zoologThesaurus$taxon)
    CheckReferenceForNewTerms(ref, "EL", zoologThesaurus$element)
    CheckReferenceForNewTerms(ref, "Measure", zoologThesaurus$measure)
  }
}

CheckRefColNames <- function(ref)
{
  cols <- c("TAX", "EL", "Measure", "Standard")
  expectedColNames <- StandardizeNomenclature(cols, zoologThesaurus$identifier)
  refColNames <- StandardizeNomenclature(names(ref), zoologThesaurus$identifier)
  if(!all.equal(refColNames, expectedColNames))
    print(paste("Reference with non-expected column names:\n\t",
                names(ref)))
}

CheckReferenceForNewTerms <- function(ref, column, thesaurus)
{
  colId <- which(InCategory(names(ref), column, zoologThesaurus$identifier))
  missingTerms <- is.na(StandardizeNomenclature(ref[, colId], thesaurus,
                                                mark.unknown = TRUE))
  if(any(missingTerms))
  {
    print(paste0("New ", column, " names not included in the thesaurus:"))
    print(ref[missingTerms, ])
  }
}
