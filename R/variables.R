# Namespace variables
logPrefix <- "log"
# For the moment, assumed to be in the correct path:
referencesLog <- read.table("~/Silvia/Biometry/ReferencesLog.csv",
  dec = ",", sep = ";", quote = "\"",
  header = TRUE, stringsAsFactors = TRUE
)
dataExample <- read.table("~/Silvia/Biometry/DataExample.csv",
  dec = ",", sep = ";", quote = "\"", na = "",
  header = TRUE, stringsAsFactors = TRUE,
  fileEncoding = "UTF-8"
)
dataExamplePruned <- read.table("~/Silvia/Biometry/DataExamplePruned.csv",
  dec = ",", sep = ";", quote = "\"", na = "",
  header = TRUE, stringsAsFactors = TRUE,
  fileEncoding = "UTF-8"
)
dataExamplePrunedWithLog <- read.table("~/Silvia/Biometry/DataExamplePrunedWithLog.csv",
  dec = ",", sep = ";", quote = "\"", na = "",
  header = TRUE, stringsAsFactors = TRUE,
  fileEncoding = "UTF-8"
)
dataExampleWithLog <- read.table("~/Silvia/Biometry/DataExampleWithLog.csv",
  dec = ",", sep = ";", quote = "\"", na = "",
  header = TRUE, stringsAsFactors = TRUE,
  fileEncoding = "UTF-8"
)
dataExampleWithLogPruned <- read.table("~/Silvia/Biometry/DataExampleWithLogPruned.csv",
  dec = ",", sep = ";", quote = "\"", na = "",
  header = TRUE, stringsAsFactors = TRUE,
  fileEncoding = "UTF-8"
)
dataExampleWithLogPrunedPrioritized <- read.table("~/Silvia/Biometry/DataExampleWithLogPrunedPrioritized.csv",
  dec = ",", sep = ";", quote = "\"", na = "",
  header = T, stringsAsFactors = TRUE,
  fileEncoding = "UTF-8"
)
