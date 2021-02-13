#' Condense Measure Log-Ratios
#'
#' This function condenses the calculated log ratio values into a reduced number
#' of features by grouping log ratio values and selecting or calculating a
#' feature value. By default the selected groups each represents a single dimension,
#' i.e. \code{Length} and \code{Width}. Only one feature is extracted per group.
#' Currently, two methods are possible: priority (default) or average.
#'
#' This operation is motivated by two circumstances. First, not all measurements
#' are available for every bone specimen, which obstructs their direct comparison
#' and statistical analysis. Second, several measurements can be strongly
#' correlated (e.g. SD and Bd both represent bone width).
#' Thus, considering them as independent would
#' produce an over-representation of bone remains with more measurements per
#' axis. Condensing each group of measurements into a single feature
#' (e.g. one measure per axis) palliates both problems.
#'
#' Observe that an important property of the log-ratios from a reference is that
#' it makes the different measures comparable. For instance, if a bone is
#' scaled with respect to the reference, so that it homogeneously doubles its
#' width, then all width related measures
#' (\emph{Bd}, \emph{BT}, \emph{Bp}, and \emph{SD}) will give the
#' same log-ratio (\code{log(2)}). In contrast, the
#' absolute measures are not directly comparable.
#'
#' The measurement names in the grouping list are given without the
#' \code{logPrefix}. But the selection is made from the log-ratios.
#'
#' The default method is \code{"priority"}, which selects the first available
#' measure log-ratio in each group. The method \code{"average"} extracts the
#' mean per group, ignoring the non-available measures.
#' We provide the following by-default group and prioritization:
#' For lengths, the order of priority is: GL, GLl, GLm, HTC.
#' For widths, the order of priority is: Bd, BT, Bp, SD, Bfd, Bfp.
#' This order maximises the robustness and reliability of the measurements,
#' as priority is given to the most abundant, more replicable, and less age
#' dependent measurements.
#'
#' This method was first used in:
#' Trentacoste, A., Nieto-Espinet, A., & Valenzuela-Lamas, S. (2018).
#' Pre-Roman improvements to agricultural production: Evidence from livestock
#' husbandry in late prehistoric Italy.
#' PloS one, 13(12), e0208109.
#'
#' @inheritParams LogRatios
#' @param grouping A list of named character vectors. The list includes a vector
#' per selected group. Each vector gives the group of measurements in order of
#' priority. By default the groups are \code{Length = c("GL", "GLl", "GLm", "HTC")}
#' and \code{Width = c("Bd", "BT", "Bp", "SD", "Bfd", "Bfp")}. The order is
#' irrelevant for \code{method = "average"}.
#' @param method Character string indicating which method to use for extracting
#' the condensed features. Currently accepted methods: \code{"priority"}
#' (default) and \code{"average"}.
#' @return A dataframe including the input dataframe and additional columns, one
#' for each extracted condensed feature, with the corresponding name given in
#' \code{grouping}.
#' @examples
#' ## Read an example dataset:
#' dataFile <- system.file("extdata", "dataValenzuelaLamas2008.csv.gz",
#'                         package="zoolog")
#' dataExample <- utils::read.csv2(dataFile,
#'                                 quote = "\"", na = "", header = TRUE,
#'                                 fileEncoding = "UTF-8")
#' ## Compute the log-ratios and select the cases with available log ratios:
#' dataExampleWithLogs <- RemoveNACases(LogRatios(dataExample))
#' ## We can observe the first lines (excluding some columns for visibility):
#' head(dataExampleWithLogs)[, -c(6:20,32:63)]
#'
#' ## Extract the default condensed features with the default "priority" method:
#' dataExampleWithSummary <- CondenseLogs(dataExampleWithLogs)
#' head(dataExampleWithSummary)[, -c(6:20,32:63)]
#'
#' ## Extract only width with "average" method:
#' dataExampleWithSummary2 <- CondenseLogs(dataExampleWithLogs,
#'                                grouping = list(Width = c("Bd", "BT", "Bp", "SD")),
#'                                method = "average")
#' head(dataExampleWithSummary2)[, -c(6:20,32:63)]

#' @export
CondenseLogs <- function(data,
                         grouping = list(
                             Length = c("GL", "GLl", "GLm", "HTC"),
                             Width = c("Bd", "BT", "Bp", "SD", "Bfd", "Bfp") ),
                         method = "priority"
                        ) {
  summaryMeasures <- names(grouping)
  data[, summaryMeasures] <- NA
  for (sumMeasure in summaryMeasures)
  {
    measuresInData <- intersect(grouping[[sumMeasure]], colnames(data))
    logMeasuresInData <- paste0(logPrefix, measuresInData)
    if(method == "priority")
    {
      alreadySelected <- FALSE
      for (logMeasure in logMeasuresInData)
      {
        selected <- !alreadySelected & !is.na(data[, logMeasure])
        data[selected, sumMeasure] <- data[selected, logMeasure]
        alreadySelected <- alreadySelected | selected
      }
    }
    else if(method == "average")
    {
      avLog <- rowMeans(data[, logMeasuresInData], na.rm = TRUE)
      avLog[is.nan(avLog)] <- NA
      data[, sumMeasure] <- avLog
    }
    else
    {
      stop("Not recognized method. It must be \"priority\" or \"average\".")
    }
  }
  data
}
