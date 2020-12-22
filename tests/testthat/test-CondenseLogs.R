test_that("CondenseLogs on data example with log-ratios.", {
  expect_equal(CondenseLogs(dataExampleWithLogPruned),
               dataExampleWithLogPrunedPrioritized, tolerance=1e-10)
})
