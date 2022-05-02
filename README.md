[![R-CMD-check](https://github.com/josempozo/zoolog/workflows/R-CMD-check/badge.svg)](https://github.com/josempozo/zoolog/actions)
[![Build Status](https://travis-ci.org/josempozo/zoolog.svg?branch=master)](https://travis-ci.org/josempozo/zoolog)

# ***zoolog**:* <img align="right" width="12.5%" style="min-width:0.65in"  src="https://josempozo.github.io/zoolog/inst/logos/zoologIcon.png"> <br> Zooarchaeological Analysis with Log-Ratios
> [Jose M Pozo](mailto:josmpozo@gmail.com), 
[Angela Trentacoste](mailto:angela.trentacoste@arch.ox.ac.uk), 
[Ariadna Nieto-Espinet](mailto:arinietoespinet@gmail.com),
[Silvia Guimarães Chiarelli](mailto:biguimaraes@hotmail.com) and
[Silvia Valenzuela-Lamas](mailto:svalenzuela@imf.csic.es)


The R package ***zoolog*** includes functions and reference data to
generate and manipulate log-ratios (also known as log size index (LSI)
values) from measurements obtained on zooarchaeological material. Log
ratios are used to compare the relative (rather than the absolute)
dimensions of animals from archaeological contexts 
(Meadow 1999, ISBN: 9783896463883). 
***zoolog*** is also able to seamlessly integrate data and references with
heterogeneous nomenclature, which is internally managed by a *zoolog* thesaurus.
A preliminary version of the zoolog methods was first used by 
Trentacoste, Nieto-Espinet, and Valenzuela-Lamas (2018) 
<https://doi.org/10.1371/journal.pone.0208109>.

Find more details in the ***zoolog***  [documentation](https://josempozo.github.io/zoolog/articles/).

## Installation

You can install the released version of zoolog from
[CRAN](https://CRAN.R-project.org/package=zoolog) with:

``` r
install.packages("zoolog")
```

And the development version from [GitHub](https://github.com/josempozo/zoolog/) with:

``` r
install.packages("devtools")
devtools::install_github("josempozo/zoolog@HEAD", build_vignettes = TRUE)
```

## Acknowledgements

Several fellow colleagues helped building the Thesaurus and tested the
code, increasing its robustness: Moussab Albesso, Canan Cakirlar, 
Jwana Chahoud, Jacopo De Grossi, Dimitrios Filioglou, Armelle Gardeisen, 
Sierra Harding, Pilar Iborra, Michael MacKinnon, Nimrod Marom, Claudia 
Minniti, Francesca Slim, Barbara Stopp, and Emmanuelle Vila. 
We are grateful to them for their comments and help.

We are particularly grateful to Sabine Deschler-Erb and Barbara Stopp, 
from the University of Basel (Switzerland) for making the reference values 
of several specimens available through the ICAZ Roman Period Working Group, 
which have been included here with their permission. We also thank Francesca 
Slim and Dimitris Filioglou from the University of Groningen, Claudia Minniti
from University of Salento, Sierra Harding and Nimrod Marom from the University 
of Haifa, Carly Ameen and Helene Benkert from the University of Exeter, and 
Mikolaj Lisowski from the University of York for providing additional reference 
sets. Allowen Evin (CNRS-ISEM Montpellier) saw potential pitfalls in the use of 
Davis' references for sheep, which have been now solved.
