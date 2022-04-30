ReadReferenceDatabase <- function(file)
{
  referencesDatabase <- list()
  refDbStruct <- utils::read.csv2(file,
                                  quote = "\"", na.strings = "",
                                  header = TRUE,
                                  comment.char = "#",
                                  fileEncoding = "UTF-8",
                                  stringsAsFactors = FALSE)
  for(i in 1:nrow(refDbStruct))
  {
    referencesDatabase[[refDbStruct$Taxon[i]]][[refDbStruct$Source[i]]] <-
      utils::read.csv2(paste0("inst/extdata/", refDbStruct$Filename[i]),
                       quote = "\"", na.strings = "",
                       header = TRUE,
                       comment.char = "#",
                       fileEncoding = "UTF-8")
  }
  referencesDatabase
}
