## Several tests for the main zoolog functions.
## For this we need a precomputed test data:
load(file.path(system.file("testdata", package="zoolog"),
               "testData.rda"))

test_that("LogRatios provides expected result on data example.", {
  expect_equal(LogRatios(dataExample), dataExampleWithLog, tolerance = 1e-10)
})

test_that("RemoveNACases on data example with log-ratios.", {
  expect_equal(RemoveNACases(dataExampleWithLog),
               dataExampleWithLogPruned,
               tolerance = 1e-10
  )
})

test_that("CondenseLogs on data example with log-ratios.", {
  expect_equal(CondenseLogs(dataExampleWithLogPruned),
               dataExampleWithLogPrunedPrioritized, tolerance=1e-10)
})


test_that("RemoveNACases on data example.", {
  exampleMeasureNames <- colnames(dataExample)[22:35]
  expect_equal(RemoveNACases(dataExample,
                             measureNames = exampleMeasureNames),
               dataExamplePruned,
               tolerance = 1e-10
  )
})

test_that("LogRatios provides expected result on pruned data example.", {
  expect_equal(LogRatios(dataExamplePruned), dataExamplePrunedWithLog, tolerance=1e-10)
})
