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
