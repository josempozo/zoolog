test_that("RemoveNACases on data example.", {
  exampleMeasuresName <- colnames(dataExample)[22:35]
  expect_equal(RemoveNACases(dataExample,
                             measureNames = exampleMeasuresName),
               dataExamplePruned,
               tolerance = 1e-10
  )
})
