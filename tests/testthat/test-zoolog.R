## Several tests for the main zoolog functions.
## For this we need a precomputed test data:
load(system.file("testdata", "testData.rda", package="zoolog"))

test_that("LogRatios provides expected result on data example.", {
  expect_equal(LogRatios(testData), testDataWithLog, tolerance = 1e-10)
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
  exampleMeasureNames <- colnames(dataExample)[22:35]
  expect_equal(RemoveNACases(testData,
                             measureNames = exampleMeasureNames),
               testDataPruned,
               tolerance = 1e-10
  )
})

test_that("LogRatios provides expected result on pruned data example.", {
  expect_equal(LogRatios(testDataPruned), testDataPrunedWithLog, tolerance=1e-10)
})
