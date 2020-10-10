# To avoid the over-representation of bone remains with more than one measurement per axis (e.g. SD and Bd), it is better to do a priorisation of measurements and only take one per bone remain. In lengths, the first option is GL, then HTC. Regarding the widths, the order of priority is: Bd, BT, Bp, SD. This order maximises the robustness and reliability of the measurements, as priority is given to the most abundant, more replicable, and less age dependent measurements.
# We first used this method in: Trentacoste, A., Nieto-Espinet, A., & Valenzuela-Lamas, S. (2018). Pre-Roman improvements to agricultural production: Evidence from livestock husbandry in late prehistoric Italy. PloS one, 13(12), e0208109.
#' @export
PrioritizeLogs <- function(
  data,
  priority=list(	Length=c("GL","HTC"),
                 Width=c("Bd","BT","Bp","SD") ) )
{
  summaryMeasures=names(priority)
  data[,summaryMeasures]=NA
  for(sumMeasure in summaryMeasures)
  {
    alreadySelected=FALSE
    measuresInData=intersect(priority[[sumMeasure]],colnames(data))
    for(measure in measuresInData)
    {
      logMeasure=paste0(logPrefix,measure)
      selected = !alreadySelected & !is.na(data[,logMeasure])
      data[selected,sumMeasure] = data[selected,logMeasure]
      alreadySelected = alreadySelected | selected
    }
  }
  data
}
