# Function to remove the table rows with all
# measurements of interest missing (NA).
# The measurements name can be explicitly provided
# or selected by a common initial pattern.
#' @export
RemoveCasesWithNoMeasurement <- function(data,measuresName=NULL,prefix=logPrefix)
{
  names=colnames(data)
  if(is.null(measuresName))
  {
    measuresName=names[regexpr(prefix,names)==1]
  }
  else
  {
    measuresName=intersect(measuresName,names)
  }
  pruneFactors(data[rowSums(!is.na(data[,measuresName]))>0,])
}
# The default values allow to remove the rows
# with no log-ratio available.
