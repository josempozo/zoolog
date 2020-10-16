
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zoolog

<!-- badges: start -->

<!-- badges: end -->

The goal of zoolog is to help zooarchaeologists to calculate log ratios
from measurements following: Von den Driesch, A. (1976) “A guide to the
measurement of animal bones from archaeological sites”, Institut für
Palaeoanatomie, Domestikationsforschung und Geschichte der Tiermedizin
of the University of Munich (Vol. 1). Peabody Museum Press. and Davis,
S. J. M. (1992) “A rapid method for recording information about mammal
bones from archaeological sites”. London: HBMC AM Laboratory report
19/92. (for HTC).

## Installation

You can install the released version of zoolog from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("zoolog")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("josempozo/zoolog")
```

## Example

This example reads a dataset from a file in csv format and compute the
log-ratios. Then, the cases with no available log-ratios are removed.
Finally the resulting dataset is saved in a file in csv format.

``` r
library(zoolog)
## Set the path in your computer to find the dataset csv file:
currentDir=getwd();
setwd('~/Silvia/Biometry')
BIOM = read.table("DataExample.csv",
                  dec=",", sep=";", quote="\"", header=T, na="",
                  fileEncoding="UTF-8")
BIOMwithLog=LogRatios(BIOM);
BIOMwithLogPruned=RemoveCasesWithNoMeasurement(BIOMwithLog)
write.table(BIOMwithLogPruned, "LogValuesBIOM.csv", 
            sep= ";", dec=",", quote=F, row.names=F, na="", 
            fileEncoding="UTF-8")
setwd(currentDir)
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!
