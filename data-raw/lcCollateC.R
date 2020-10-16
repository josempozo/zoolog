lcCollateC <- function(x)
{
  lc_collocate0 <- Sys.getlocale("LC_COLLATE")
  Sys.setlocale("LC_COLLATE","C")
  x
  invisible(Sys.setlocale("LC_COLLATE",lc_collocate0))
}
