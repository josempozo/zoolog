test_that("RemoveNACases on data example with log-ratios.", {
  expect_equal(RemoveNACases(dataExampleWithLog),
               dataExampleWithLogPruned,
               tolerance = 1e-10
  )
})
