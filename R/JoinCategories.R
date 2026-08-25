JoinCategories <- function(thesaurus, categories)
{
  if(length(categories) == 0) return(thesaurus)
  categStandard <- lapply(categories, StandardizeNomenclature,
                          thesaurus, mark.unknown = TRUE)
  categStandard <- lapply(categStandard, unique)
  names(categStandard) <- lapply(names(categories), StandardizeNomenclature,
                                 thesaurus)
  termsNotInThesaurus <- mapply(function(x, y) y[is.na(x)],
                                categStandard, categories,
                                SIMPLIFY = FALSE)
  if(any(is.na(unlist(categStandard))))
    warning(paste0("The provided categories include the name",
                   FormatListOfNames(unlist(termsNotInThesaurus),
                                     formatMarks = c("\"", "\""),
                                     preMessage = c("", "s")),
                  " not belonging to any category in the thesaurus."))


  categStandard <- mapply(function(x,y) {
                            if(y %in% names(thesaurus) && !(y %in% x))
                              x <- c(y,x)
                            return(x)
                          },
                          categStandard, names(categStandard),
                          SIMPLIFY = FALSE)

  thesList <- lapply(thesaurus, function(a) a[a!=""])
  namesToAdd <- lapply(categStandard,
                       function(x) as.character(unlist(thesList[x])))
  namesToAdd <- mapply(function(x,y,z) c(x,y,z),
                       names(namesToAdd), namesToAdd, termsNotInThesaurus,
                       SIMPLIFY = FALSE)
  thesList <- thesList[!(names(thesList) %in%
                           c(names(namesToAdd),
                             as.character(unlist(categStandard))))]
  thesList <- c(thesList, namesToAdd)
  thesNew <- ThesaurusFromList(thesList, attributes(thesaurus))
  if(ambiguity <- ThesaurusAmbiguity(thesNew))
    stop(paste0("Joining these categories would result in ambiguous thesaurus.\n",
                attr(ambiguity, "errmessage")))
  return(thesNew)
}

SmartJoinCategories <- function(thesaurusSet, joinCategories)
{
  if(length(joinCategories)==0) return(thesaurusSet)
  coincidences <- sapply(joinCategories, function(x) {
    sapply(thesaurusSet, function(y) {
      normalizedThes <- NormalizeForSensitiveness(y, y)
      normalizedX <- NormalizeForSensitiveness(x, y)
      any(normalizedX %in% as.character(
        unlist(lapply(normalizedThes, function(a) a[a!=""]))))
    })
  })
  if(any(colSums(coincidences)>1))
    stop(paste("Provided categories are ambiguous:",
               "Some name is in more than one thesaurus."))
  if(any(colSums(coincidences)<1))
    stop(paste("Provided categories include one category",
               "not matching any thesaurus."))
  for(th in rownames(coincidences))
  {
    thesaurusSet[[th]] <- JoinCategories(thesaurusSet[[th]],
                                         joinCategories[coincidences[th,]])
  }
  return(thesaurusSet)
}
