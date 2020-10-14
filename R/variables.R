#Namespace variables
logPrefix="log"
# For the moment, assumed to be in the correct path:
referencesLog=read.table("/Users/jose/Silvia/Biometry/ReferencesLog.csv",
                      dec=",", sep= ";", quote="\"", header=T)
dataExample=read.table("/Users/jose/Silvia/Biometry/DataExample.csv",
                      dec=",", sep= ";", quote="\"", header=T, na="",
                      fileEncoding = "UTF-8")
dataExamplePruned=read.table("/Users/jose/Silvia/Biometry/DataExamplePruned.csv",
                      dec=",", sep= ";", quote="\"", header=T, na="",
                      fileEncoding = "UTF-8")
dataExamplePrunedWithLog=read.table("/Users/jose/Silvia/Biometry/DataExamplePrunedWithLog.csv",
                      dec=",", sep= ";", quote="\"", header=T, na="",
                      fileEncoding = "UTF-8")
dataExampleWithLog=read.table("/Users/jose/Silvia/Biometry/DataExampleWithLog.csv",
                      dec=",", sep= ";", quote="\"", header=T, na="",
                      fileEncoding = "UTF-8")
dataExampleWithLogPruned=read.table("/Users/jose/Silvia/Biometry/DataExampleWithLogPruned.csv",
                      dec=",", sep= ";", quote="\"", header=T, na="",
                      fileEncoding = "UTF-8")
dataExampleWithLogPrunedPrioritized=read.table("/Users/jose/Silvia/Biometry/DataExampleWithLogPrunedPrioritized.csv",
                      dec=",", sep= ";", quote="\"", header=T, na="",
                      fileEncoding = "UTF-8")
