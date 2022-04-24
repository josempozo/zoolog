# Collapsing dataframes columns in a single vector.
# This allows to find coincidences of all column values in a single comparison
CollapseColumns <- function(df, ..., sepMark = "--&&--")
{
  apply(cbind(df, ...), 1, paste, collapse = sepMark)
}

SplitColumns <- function(x, colNames = NULL, sepMark = "--&&--")
{
  res <- as.data.frame(t(simplify2array(strsplit(x, sepMark, fixed = TRUE))))
  colnames(res) <- colNames
  return(res)
}
