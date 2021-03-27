ReadCommentLines <- function(file, comment.char = "#")
{
  allLines <- stringi::stri_read_lines(file)
  GetCommentLines(allLines, comment.char)
}

GetCommentLines <- function(x, comment.char = "#")
{
  commentLines <- x[StartsBy(x, comment.char)]
  comments <- sub(paste0("([", comment.char, " ])+"), "", commentLines)
  return(comments)
}

GetAfterPattern <- function(x, pattern)
{
  xSelected <- x[StartsBy(x, pattern)]
  xWithoutInitialSpaces <- sub("( )+", "", xSelected)
  xWithoutPattern <- substring(xWithoutInitialSpaces, nchar(pattern)+1)
  sub("( )+", "", xWithoutPattern)
}

StartsBy <- function(x, pattern)
{
  xWithoutInitialSpaces <- sub("( )+", "", x)
  substring(xWithoutInitialSpaces, 1, nchar(pattern)) == pattern
}
