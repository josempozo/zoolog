***zoolog***:   <img align="right" width="100" src="/inst/logos/zoologIcon.png">
Zooarcheological Analysis with Log-Ratios
================
Jose M Pozo, Silvia Valenzuela-Lamas, Angela Trentacoste, Ariadna
Nieto-Espinet and Silvia Guimarães Chiarelli
2021-01-28

[![R-CMD-check](https://github.com/josempozo/zoolog/workflows/R-CMD-check/badge.svg)](https://github.com/josempozo/zoolog/actions)
[![Build
Status](https://travis-ci.org/josempozo/zoolog.svg?branch=master)](https://travis-ci.org/josempozo/zoolog)

# Introduction

The R package ***zoolog*** includes functions and reference data to
generate and manipulate log-ratios (also known as log size index (LSI)
values) from measurements obtained on zooarchaeological material. Log
ratios are used to compare the relative (rather than the absolute)
dimensions of animals from archaeological contexts. ***zoolog*** is also
able to seamlessly integrate data and references with heterogeneous
nomenclature, which is internally managed by a *zoolog* thesaurus.

<!-- Find more details in the ***zoolog***  [documentation](https://josempozo.github.io/zoolog/vignettes/)  -->

## Installation

You can install the released version of zoolog from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("zoolog", build_vignettes=TRUE)
```

And the development version from [GitHub](https://github.com/) with:

``` r
install.packages("devtools")
library(devtools)
devtools::install_github("josempozo/zoolog@HEAD", build_vignettes = TRUE, force = TRUE)
```
