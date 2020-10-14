test_that("RemoveCasesWithNoMeasurement provides expected result on data example with log-ratios.", {
  dataExampleWithLogPruned2=RemoveCasesWithNoMeasurement(dataExampleWithLog)
  n=dim(dataExampleWithLogPruned2)[2]
  for(i in 1:n)
    if(all(is.na(dataExampleWithLogPruned2[,i])) &
          is.numeric(dataExampleWithLogPruned2[,i]))
      dataExampleWithLogPruned2[,i]=as.logical(dataExampleWithLogPruned2[,i])
  row.names(dataExampleWithLogPruned2)=1:(dim(dataExampleWithLogPruned2)[1])
  expect_equal(dataExampleWithLogPruned2,
               dataExampleWithLogPruned, tolerance=1e-10)
})
