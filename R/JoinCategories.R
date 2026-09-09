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
    warning("The provided categories include the name",
            FormatListOfNames(unlist(termsNotInThesaurus),
                              preMessage = c("", "s")),
            " not belonging to any category in the thesaurus.")


  categStandard <- mapply(function(x,y) {
                            if(y %in% names(thesaurus) && !(y %in% x))
                              x <- c(y,x)
                            return(x)
                          },
                          categStandard, names(categStandard),
                          SIMPLIFY = FALSE)

  namesToAdd <- lapply(categStandard,
                       function(x) unlist(thesaurus[x], use.names = FALSE))
  namesToAdd <- mapply(function(x,y) c(x,y),
                       namesToAdd, termsNotInThesaurus,
                       SIMPLIFY = FALSE)
  jointThes <- thesaurus[!(names(thesaurus) %in%
                         c(names(namesToAdd),
                           unlist(categStandard, use.names = FALSE)))]
  jointThes <- c(jointThes, namesToAdd)
  thesAttrib <- attributes(thesaurus)
  thesAttrib <- thesAttrib[names(thesAttrib) != "names"]
  jointDescription <- lapply(categories, FormatListOfNames,
                             formatMarks = c("", ""))
  jointDescription <- mapply(paste, names(categories), jointDescription,
                             sep = " <- ", USE.NAMES = FALSE)
  thesAttrib$description <- c(thesAttrib$description,
                              "with joint categories", jointDescription)
  Thesaurus(jointThes, thesAttrib)
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
    stop("Provided categories are ambiguous: ",
         "Some name is in more than one thesaurus.")
  if(any(colSums(coincidences)<1))
    stop("Provided categories include one category not matching any thesaurus.")
  for(th in rownames(coincidences))
  {
    thesaurusSet[[th]] <- JoinCategories(thesaurusSet[[th]],
                                         joinCategories[coincidences[th,]])
  }
  return(thesaurusSet)
}
