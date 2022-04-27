## Several tests for the main zoolog functions.
## For this we need a precomputed test data:

lc_collocate0 <- Sys.getlocale("LC_COLLATE")
Sys.setlocale("LC_COLLATE","C")

load(system.file("testdata", "testData.rda", package="zoolog"))

smthng <- "[[:print:][:space:]]+"
test_that("LogRatio on data example with assumed taxon in genus.", {
  expect_warning(expect_warning(
    expect_equal(LogRatios(testData, ref = reference$Basel,
                           mergedMeasures = list(c("GL", "GLl", "GLpe"))),
                 testDataWithLog_Basel, tolerance = 1e-10),
    paste0("Sus scrofa", smthng, "cases of Sus domesticus", smthng,
           "Ovis orientalis", smthng, "cases of Ovis aries", smthng,
           "useGenusIfUnambiguous")),
    paste0("Data includes", smthng,
           "Caprini", smthng, "Tribe", smthng,
           "reference for Ovis orientalis or Capra hircus", smthng,
           "joinCategories", smthng, "use any of them.")
  )
})

test_that("LogRatio on data example without assumed taxon in genus.", {
  expect_warning(
    expect_equal(LogRatios(testData, ref = reference$Basel,
                           mergedMeasures = list(c("GL", "GLl", "GLpe")),
                           useGenusIfUnambiguous = FALSE),
                 testDataWithLog_BaselNoGenus, tolerance = 1e-10),
    paste0("Data includes", smthng,
           "Caprini", smthng, "Tribe", smthng,
           "reference for Ovis orientalis or Capra hircus", smthng,
           "joinCategories", smthng, "use any of them.")
  )
})

caprineCategories = list(ovar = SubtaxonomySet("caprine"))
test_that("Defining caprineCategories using SubtaxonomySet.", {
  expect_equal(caprineCategories,
               list(ovar = c("Ovis aries", "Ovis orientalis",
                             "Capra hircus", "Capra aegagrus",
                             "Ovis", "Capra", "Caprini")))
})

test_that("LogRatio expected result on data example with joinCategories.", {
  expect_equal(LogRatios(testData, ref = reference$NietoDavisAlbarella,
                         joinCategories = caprineCategories,
                         mergedMeasures = list(c("GL", "GLl", "GLpe"))),
               testDataWithLog, tolerance = 1e-10)
})

test_that("RemoveNACases on data example with log-ratios.", {
  expect_equal(RemoveNACases(testDataWithLog),
               testDataWithLogPruned,
               tolerance = 1e-10
  )
})

test_that("CondenseLogs on data example with log-ratios.", {
  expect_equal(CondenseLogs(testDataWithLogPruned),
               testDataWithLogPrunedPrioritized, tolerance=1e-10)
})


test_that("RemoveNACases on data example.", {
  exampleMeasureNames <- colnames(testData)[22:35]
  expect_equal(RemoveNACases(testData,
                             measureNames = exampleMeasureNames),
               testDataPruned,
               tolerance = 1e-10
  )
})

test_that("LogRatios provides expected result on pruned data example.", {
  expect_equal(LogRatios(testDataPruned, ref = reference$NietoDavisAlbarella,
                         joinCategories = caprineCategories,
                         mergedMeasures = list(c("GL", "GLl", "GLpe"))),
               testDataPrunedWithLog, tolerance=1e-10)
})

invisible(Sys.setlocale("LC_COLLATE",lc_collocate0))
