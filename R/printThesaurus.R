#' @exportS3Method
print.thesaurus <- function(x, ...)
{
  print(as.data.frame(x), ...)
  sensNames <- c("caseSensitive", "accentSensitive", "punctuationSensitive",
                 "wordOrderSensitive")
  sensitiveness <- sapply(
    sensNames,
    function(a) {y <- attributes(x)[[a]]; if(is.null(y)) NA else y}
  )
  cat("\nSensitiveness:\n")
  print(sensitiveness)
  cat("\nDescription:\n")
  cat(paste("  ", attributes(x)[["description"]], collapse = "\n"))
}

#' @export
View <- function(x, title = as.character(match.call())[2])
{
  if("thesaurus" %in% class(x))
    x <- as.data.frame(x)
  get("View", envir = as.environment("package:utils"))(x, title)
}
