test_that("LogRatios provides expected result on pruned data example.", {
  expect_equal(LogRatios(dataExamplePruned), dataExamplePrunedWithLog, tolerance=1e-10)
})
