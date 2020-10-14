# Auxiliar function to remove the non-used factors after subseting
# a data.frame.
# It takes also into account if factors in the original data.frame can
# be considered numeric in the subset one.
pruneIfFactor <- function(x)
{
  if(is.factor(x))
  {
    x=factor(x)
    na.idx <- is.na(suppressWarnings(as.numeric(levels(x))))
    if(all(levels(x)[na.idx]=="" | levels(x)[na.idx]==" "))
      x=as.numeric(as.character(x))
  }
  x
}

pruneFactors <- function(data)
{
  data[] <- lapply(data, pruneIfFactor)
  data
}
# The default values allow to remove the rows
# with no log-ratio available.
