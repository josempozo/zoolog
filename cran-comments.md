## Submission of new version 0.4.1 (2021-09-01)
zoolog 0.4.1

Changes described in NEWS.md.

## Submission of new version 0.4.0 (2021-08-02)
zoolog 0.4.0

Changes described in NEWS.md.

## Submission of patch 0.3.1 (2021-05-04)
zoolog 0.3.1

Changes described in NEWS.md.

## Resubmission (2021-04-07)

CRAN manual revision provided the following feedback:

1. Version contains large components (0.3.0.9001)
   Pls use a serious version number such as 0.3.0 or 0.3.1

*Done*. It is now 0.3.0

2. The Date field is over a month old.
   Pls update

*Done*. Updated date to 2021-4-06.

In addition:

3. Vignettes building with r-devel-linux-x86_64-debian-clang resulted in error
   in lines 441-443 (index.Rmd).
   
I believe that the error is due to non-standard default for t.test optional
argument na.action. 
It is now explicitly set to "na.omit".

## Submission of new version (2021-04-06)

zoolog 0.2.0

Changes described in NEWS.md.


## Third resubmission (2021-02-17)

CRAN manual revision provided the following feedback:

1. If there are references describing the methods in your package, please
   add these in the description field of your DESCRIPTION file in the form
   * authors (year) <doi:...>
   * authors (year) <arXiv:...>
   * authors (year, ISBN:...)
   * or if those are not available: <https:...>
   
   with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
   auto-linking.
   (If you want to add a title as well please put it in quotes: "Title")

*Done*. Added two references:
   * (Meadow 1999, ISBN: 9783896463883)
   * Trentacoste, Nieto-Espinet, and Valenzuela-Lamas (2018) 
     <doi:10.1371/journal.pone.0208109>

2. Possibly mis-spelled words in DESCRIPTION:
   * Zooarcheological (2:8)
   * zooarchaeological (28:43)
   
*Corrected*. The spelling "zooarchaeological" is now consistently used.

3. Please add \value to .Rd files regarding exported methods and explain
   the functions results in the documentation. Please write about the
   structure of the output (class) and also what the output means. (If a
   function does not return a value, please document that too, e.g.
   \value{No return value, called for side effects} or similar)
   Missing Rd-tags:
   * dataValenzuelaLamas2008.Rd: \value
   
*Corrected*. The missing \docType{data} has now been added. 
dataValenzuelaLamas2008.Rd documents a data example, which, according to my understanding, does not require a *value* tag.

## Second resubmission (2021-02-15)

CRAN manual revision provided the following feedback:

1.  Problems when formatting CITATION entries:
     x:1: unexpected '}'

*Done*. Curly brakets were used to denote two-word last names in bibtex. 
We have now used the alternative notation (last_names, first_name) to avoid the 
curly brakets.

2.  Found the following (possibly) invalid URLs:
    URL:
https://github.com/josempozo/zoolog,%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20https://josempozo.github.io/zoolog
       From: inst/doc/index.html
       Status: 404
       Message: Not Found

*Done*. There were two web addresses separated by a return. 
We have now removed one of the addresses.

3.  URL: https://josempozo.github.io/zoolog (moved to
https://josempozo.github.io/zoolog/)
       From: DESCRIPTION
       Status: 200
       Message: OK

*Done*.

4.  URL: https://www.researchgate.net/publication/326010953 (moved to
https://www.researchgate.net/publication/326010953_Element_Measure_Standard_Biometrical_data_from_a_cow_dated_to_the_Early_Bronze_Age_Minferri_Catalonia)
       From: man/referencesDatabase.Rd
       Status: 200
       Message: OK
       
*Done*. Removed the https address. Kept only the equivalent doi.


## Resubmission (2021-02-13)

CRAN manual revision provided the following feedback:

1. Found the following (possibly) invalid URLs:
   URL: https://www.researchgate.net/publication/326010953 (moved to
https://www.researchgate.net/publication/326010953_Element_Measure_Standard_Biometrical_data_from_a_cow_dated_to_the_Early_Bronze_Age_Minferri_Catalonia)
   From: man/references.Rd
   Status: 200
   Message: OK

	Please change http --> https, add trailing slashes, or follow moved
	content as appropriate.

*Done*. The documentation has actually been restructured and improved. 

2. The Description field should not start with the package name,
   'This package' or similar.
   
*Done*

3. and please do not use directed quotes in the Description field.

*Done*

4. Found the following URLs which should use \doi (with the DOI name only):
     File 'references.Rd':
       https://doi.org/10.13140/RG.2.2.13512.78081

*Done*

We have improved the robustness and structure of several functions and data. 
Thus the current version is: zoolog 0.2.0.


## First submission (2021-01-19).

zoolog 0.1.0
