## Several tests for the main zoolog functions.
## For this we need a precomputed test data:

lc_collocate0 <- Sys.getlocale("LC_COLLATE")
Sys.setlocale("LC_COLLATE","C")

load(system.file("testdata", "testData.rda", package="zoolog"))

caprineCategories = list(ovis = c("ovis", "capra", "oc"))
test_that("LogRatios provides expected result on data example.", {
  expect_equal(LogRatios(testData, ref = reference$NietoDavisAlbarella,
                         joinCategories = caprineCategories,
                         mergedMeasures = list(c("GL", "GLl"))),
               testDataWithLog, tolerance = 1e-10)
})

test_that("RemoveNACases on data example with log-ratios.", {
  expect_equal(RemoveNACases(testDataWithLog),
               testDataWithLogPruned,
               tolerance = 1e-10
  )
})

test_that("CondenseLogs on data example with log-ratios.", {
  expect_equal(CondenseLogs(testDataWithLogPruned),
               testDataWithLogPrunedPrioritized, tolerance=1e-10)
})


test_that("RemoveNACases on data example.", {
  exampleMeasureNames <- colnames(testData)[22:35]
  expect_equal(RemoveNACases(testData,
                             measureNames = exampleMeasureNames),
               testDataPruned,
               tolerance = 1e-10
  )
})

test_that("LogRatios provides expected result on pruned data example.", {
  expect_equal(LogRatios(testDataPruned, ref = reference$NietoDavisAlbarella,
                         joinCategories = caprineCategories,
                         mergedMeasures = list(c("GL", "GLl"))),
               testDataPrunedWithLog, tolerance=1e-10)
})

invisible(Sys.setlocale("LC_COLLATE",lc_collocate0))
