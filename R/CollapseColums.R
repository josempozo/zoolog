# Collapsing dataframes columns in a single vector.
# This allows to find coincidences of all column values in a single comparison
CollapseColumns <- function(df, ..., sepMark = "--&&--")
{
  apply(cbind(df, ...), 1, paste, collapse = sepMark)
}
