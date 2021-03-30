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
  expectedColNames <- c("TAX", "EL", "Measure", "Standard")
  if(!all.equal(names(ref), expectedColNames))
    print(paste("Reference with non-expected column names:\n\t",
                names(ref)))
}

CheckReferenceForNewTerms <- function(ref, column, thesaurus)
{
  missingTerms <- is.na(StandardizeNomenclature(ref[, column], thesaurus,
                                                mark.unknown = TRUE))
  if(any(missingTerms))
  {
    print(paste0("New ", column, " names not included in the thesaurus:"))
    print(ref[missingTerms, ])
  }
}
