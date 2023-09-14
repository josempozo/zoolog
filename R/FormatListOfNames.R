# Function to help format vector of names to be used in the documentation.
FormatListOfNames <- function(names, formatMarks = c("\\emph{", "}"),
                              preMessage = NULL, postMessage = NULL)
{
  n <- length(names)
  if(n == 0) return("")
  formatedNames <- paste0(formatMarks[1], names, formatMarks[2])
  preN <- min(length(preMessage), n)
  postN <- min(length(postMessage), n)
  if(n > 1) formatedNames[n] <- paste0("and ", formatedNames[n])
  comma <- ", "
  if(n == 2) comma <- " "
  paste(c(preMessage[preN],
          paste0(formatedNames, collapse = comma),
          postMessage[postN]), collapse = " ")
}
