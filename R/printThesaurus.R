#' @exportS3Method
print.thesaurus <- function(x, ...)
{
  print(as.data.frame(x), ...)
  if(!is.null(attributes(x)$sensitiveness))
  {
    cat("\nSensitiveness:\n")
    print(attributes(x)$sensitiveness)
  }
  if(!(is.null(attributes(x)$description) ||
       isTRUE(attributes(x)$description == "")))
  {
    cat("\nDescription:\n")
    cat(paste("  ", attributes(x)$description, collapse = "\n"))
  }
}

#' @export
View <- function(x, title = as.character(match.call())[2])
{
  if("thesaurus" %in% class(x))
    x <- as.data.frame(x)
  get("View", envir = as.environment("package:utils"))(x, title)
}
