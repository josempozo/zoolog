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
#' (\emph{BT}, \emph{Bd}, \emph{Bp}, \emph{SD}, ...) will give the
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
#' For widths, the order of priority is: BT, Bd, Bp, SD, Bfd, Bfp.
#' For depths, the order of priority is: Dd, DD, BG, Dp
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
#' Alternatively, a user-defined \code{method} can be provided as a function
#' with a single argument (data.frame) assumed to have as columns the measure
#' log-ratios determined by the \code{grouping}.
#'
#' @inheritParams LogRatios
#' @param grouping A list of named character vectors. The list includes a vector
#' per selected group. Each vector gives the group of measurements in order of
#' priority. By default the groups are
#' \code{Length = c("GL", "GLl", "GLm", "HTC")},
#' \code{Width = c("BT", "Bd", "Bp", "SD", "Bfd", "Bfp")}, and
#' \code{Depth = c("Dd", "DD", "BG", "Dp")}.
#' The order is irrelevant for \code{method = "average"}.
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
#'                                 na.strings = "",
#'                                 encoding = "UTF-8")
#' ## For illustration purposes we keep now only a subset of cases to make
#' ## the example run sufficiently fast.
#' ## Avoid this step if you want to process the full example dataset.
#' dataExample <- dataExample[1:1000, ]
#'
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
#'                                grouping = list(Width = c("BT", "Bd", "Bp", "SD")),
#'                                method = "average")
#' head(dataExampleWithSummary2)[, -c(6:20,32:63)]

#' @export
CondenseLogs <- function(data,
                         grouping = list(
                             Length = c("GL", "GLl", "GLm", "HTC"),
                             Width = c("BT", "Bd", "Bp", "SD", "Bfd", "Bfp"),
                             Depth = c("Dd", "DD", "BG", "Dp") ),
                         method = "priority"
                        ) {

  if(!is.data.frame(data)) stop("data must be a data.frame.")
  if(is.character(method) && (method %in% names(condenseMethod)))
    method <- condenseMethod[[method]]
  if(!is.function(method))
    stop(paste0("Not recognized method.\n",
                "Predefined accepted methods are ",
                paste0(paste0("\"", names(condenseMethod), "\""),
                       collapse = ", "), ".\n",
                "Alternatively, it can be a user defined function."))

  summaryMeasures <- names(grouping)
  data[, summaryMeasures] <- NA
  for (sumMeasure in summaryMeasures)
  {
    groupingWithLog <- paste0(logPrefix, grouping[[sumMeasure]])
    logMeasuresInData <- intersect(groupingWithLog, colnames(data))
    dataSelected <- as.data.frame(data[, logMeasuresInData])
    data[, sumMeasure] <- method(dataSelected)
  }
  return(data)
}


condenseMethod <- list(
  priority = function(data)
  {
    alreadySelected <- FALSE
    res <- rep(NA, nrow(data))
    for(logMeasure in colnames(data))
    {
      selected <- !alreadySelected & !is.na(data[, logMeasure])
      res[selected] <- data[selected, logMeasure]
      alreadySelected <- alreadySelected | selected
    }
    return(res)
  },

  average = function(data)
  {
    avLog <- rowMeans(data, na.rm = TRUE)
    avLog[is.nan(avLog)] <- NA
    return(avLog)
  }
)
