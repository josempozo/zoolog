test_that("PrioritizeLogs provides expected result on data example.", {
  dataExampleWithLogPrunedPrioritized2=PrioritizeLogs(
    dataExampleWithLogPruned )
  expect_equal(dataExampleWithLogPrunedPrioritized2,
               dataExampleWithLogPrunedPrioritized, tolerance=1e-10)
})
