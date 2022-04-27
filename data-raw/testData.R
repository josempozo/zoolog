## Code to prepare several test data by applying zoolog functions to a small
## dataset. They are necessary for the package tests.
## They are stored in the system folder inst/testdata/.

source("data-raw/lcCollateC.R")
lcCollateC({
  caprineCategories = list(ovis = c("ovis", "capra", "oc"))
  testData <- read.csv2("inst/testdata/testData.csv",
                        quote = "\"", na = "",
                        header = TRUE, stringsAsFactors = TRUE,
                        fileEncoding = "UTF-8"
  )
  testDataWithLog_Basel <- LogRatios(testData, ref = reference$Basel,
                                     mergedMeasures = list(c("GL", "GLl", "GLpe")))
  testDataWithLog_BaselNoGenus <- LogRatios(testData, ref = reference$Basel,
                                     mergedMeasures = list(c("GL", "GLl", "GLpe")),
                                     useGenusIfUnambiguous = FALSE)
  testDataWithLog <- LogRatios(testData, ref = reference$NietoDavisAlbarella,
                               joinCategories = caprineCategories,
                               mergedMeasures = c("GL", "GLl", "GLpe"))
  testDataWithLogPruned <- RemoveNACases(testDataWithLog)
  testDataWithLogPrunedPrioritized <- CondenseLogs(testDataWithLogPruned)
  exampleMeasureNames <- colnames(testData)[22:35]
  testDataPruned <- RemoveNACases(testData,
                                  measureNames = exampleMeasureNames)
  testDataPrunedWithLog <- LogRatios(testDataPruned,
                                     ref = reference$NietoDavisAlbarella,
                                     joinCategories = caprineCategories,
                                     mergedMeasures = c("GL", "GLl", "GLpe"))
})

write.csv2(testDataWithLog_Basel,
           "inst/testdata/testDataWithLog_Basel.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")
write.csv2(testDataWithLog_BaselNoGenus,
           "inst/testdata/testDataWithLog_BaselNoGenus.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")
write.csv2(testDataWithLog,
           "inst/testdata/testDataWithLog.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")
write.csv2(testDataWithLogPruned,
           "inst/testdata/testDataWithLogPruned.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")
write.csv2(testDataWithLogPrunedPrioritized,
           "inst/testdata/testDataWithLogPrunedPrioritized.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")
write.csv2(testDataPruned,	"inst/testdata/testDataPruned.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")
write.csv2(testDataPrunedWithLog,
           "inst/testdata/testDataPrunedWithLog.csv",
           row.names=FALSE, quote=FALSE, na="",
           fileEncoding = "UTF-8")


save(testData,
     testDataWithLog_Basel,
     testDataWithLog_BaselNoGenus,
     testDataWithLog,
     testDataWithLogPruned,
     testDataWithLogPrunedPrioritized,
     testDataPruned,
     testDataPrunedWithLog,
     file = file.path(system.file("testdata", package="zoolog"),
                      "testData.rda"),
     version = 2)
