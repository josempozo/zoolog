test_that("PrioritizeLogs on data example with log-ratios.", {
  expect_equal(PrioritizeLogs(dataExampleWithLogPruned),
               dataExampleWithLogPrunedPrioritized, tolerance=1e-10)
})
