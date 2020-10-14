test_that("RemoveCasesWithNoMeasurement provides expected result on data example.", {
  dataExamplePruned2=RemoveCasesWithNoMeasurement(dataExample,
                                  measuresName=colnames(dataExample)[22:35])
  row.names(dataExamplePruned2)=1:(dim(dataExamplePruned2)[1])
  expect_equal(dataExamplePruned2,
               dataExamplePruned, tolerance=1e-10)
})
