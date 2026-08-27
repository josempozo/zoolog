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

test_that("ReadThesaurusSet is the exact inverse of WriteThesaurusSet.", {
  file <- file.path(tempdir(), "thesaurusSet.csv")
  WriteThesaurusSet(zoologThesaurusByLanguage, file)
  thesaurusSet <- ReadThesaurusSet(file)
  expect_equal(thesaurusSet, zoologThesaurusByLanguage)
})

test_that("SetActiveLanguages correctly taken into account by LogRatios (1).", {
  testData2 <- testData[1:50, ]
  testDataWithLog_Basel2 <- testDataWithLog_Basel[1:50, ]
  testDataWithLog_Basel2$TAX[2] <- testData2$TAX[2] <- "vaca"
  testDataWithLog_Basel2$logBd[2] <- NA
  SetActiveLanguages(c("Base", "English"))
  suppressWarnings(testData2Log <- LogRatios(testData2, ref = reference$Basel))
  expect_equal(testData2Log, testDataWithLog_Basel2)
})

test_that("SetActiveLanguages correctly taken into account by LogRatios (2).", {
  testData2 <- testData[1:50, ]
  testDataWithLog_Basel2 <- testDataWithLog_Basel[1:50, ]
  testDataWithLog_Basel2$TAX[2] <- testData2$TAX[2] <- "vaca"
  SetActiveLanguages(AllAvailableLanguages())
  suppressWarnings(testData2Log <- LogRatios(testData2, ref = reference$Basel))
  expect_equal(testData2Log, testDataWithLog_Basel2)
})

test_that("StandardizeDataSet with SetStandardLanguage to Portuguese.", {
  SetStandardLanguage("Portuguese")
  suppressWarnings(testDataPruned_std <- StandardizeDataSet(testDataPruned))
  SetStandardLanguage("Base")
  expect_equal(testDataPruned_std, testDataPruned_Portuguese)
})

test_that("Check correct error message for thesaurus ambiguity", {
  expect_error(
    AddToThesaurus(NewThesaurus(wordOrderSensitive = FALSE),
      list(red = c("vermilion", "scarlet", "ruby", "cherry", "carmine"),
           blue = c("sky blue", "azure", "sapphire", "cyan", "let scar"),
           brown = c("hazel", "chocolate-coloured", "brunette", "blueSky"))
    ),
    paste0("The resulting thesaurus would be ambiguous.", smthng,
           "categories", smthng, "red", smthng, "blue", smthng,
           "Shared", smthng, "scarlet", smthng,
           "categories", smthng, "blue", smthng, "brown", smthng,
           "Shared", smthng, "bluesky", smthng)
  )
})

test_that("References' Taxa, elements, and measures included in thesauri.", {
  refCheckMessage <- capture_output(
    zoolog:::CheckReferenceStructure(referencesDatabase))
  refCheckExpectedMessage <- capture_output(
    for(name in names(referencesDatabase))
    {
      print(paste("Checking", name))
      for(ref in names(referencesDatabase[[name]]))
        print(paste("Checking", ref))
    }
  )
  expect_equal(refCheckMessage, refCheckExpectedMessage)
})

invisible(Sys.setlocale("LC_COLLATE",lc_collocate0))
