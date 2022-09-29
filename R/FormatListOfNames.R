# Function to help format vector of names to be used in the documentation.
FormatListOfNames <- function(names, formatMarks = c("\\emph{", "}"))
{
  n <- length(names)
  if(n == 0) return("")
  formatedNames <- paste0(formatMarks[1], names, formatMarks[2])
  if(n == 1) return(formatedNames)
  formatedNames[n] <- paste0("and ", formatedNames[n])
  comma <- ", "
  if(n == 2) comma <- " "
  paste0(formatedNames, collapse = comma)
}
