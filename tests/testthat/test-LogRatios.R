test_that("LogRatios provides expected result on data example.", {
  expect_equal(LogRatios(dataExample), dataExampleWithLog, tolerance=1e-10)
})
