# zoolog 1.0.1
1. Corrected Steppan's standard for Bos primigenius. Some measurements had been
   missing.
2. Corrected Davis’ standard. The change from measure SD to Davis.SD in previous
   release was an over-correction. Only tibia should have been affected by this
   change.

# zoolog 1.0.0
1. Completed the zoologTaxonomy as a new functionality structuring the taxonomy
   hierarchy for the taxa used in the references. 
2. New functions Subtaxonomy, SubtaxonomySet, and GetTaxaIn. All of them taking
   into account the zoologThesaurus$taxon
3. Added new categories in zoologThesaurus$taxon to include also genera, 
   in addition to taxa.
4. Integrated the zoologTaxonomy into the function LogRatios. This allows the
   automatic detection of data and reference sharing the same genus, although
   of different taxa.
5. Extended vignettes to incorporate description and illustration of the new
   functionalities.
6. Added several tests for the new functionalities: SubtaxonomySet function and
   LogRatios warning messages and automatic detection of cases with same genus 
   but different taxon from reference.
7. Corrected some entries in example dataset, dataValenzuelaLamas2008.
8. Corrected bug on WriteThesaurusSet.
9. Davis’ standard SD, equivalent to Von den Driesch’s DD, has been denoted as 
   Davis.SD in order to resolve its incompatibility with Von den Driesch’s SD.
   This has been modified in Davis' reference for sheep and added to the 
   thesaurus for measures.
10. Added reference "Steppan" for Bos primigenius. The standards are obtained
   from the same specimen as the reference "Degerbol", but with new and more 
   standandard measures.

# zoolog 0.5.0
1. Included new functionality structuring the taxonomy hierarchy for the
   taxa used in the references. There is now a zoologTaxonomy and a function,
   GetTaxaIn, facilitating its use.
2. Corrected a few measurements in the example dataset.
3. Added one entry in thesaurus.

# zoolog 0.4.2
1. Corrected a few measurements in the reference Equus_Johnstone.

# zoolog 0.4.1
1. Clarify in the documentation that log ratios are defined using base 10 
   logarithms.
2. All functions processing dataframes (LogRatios, RemoveNaCases, CondenseLogs,
   StandardizeDataSet) are now more robust to input data including additional 
   S3 classes (previously giving errors). The additional classes are also passed
   to the output.

# zoolog 0.4.0
1. Improved structure of function CondenseLogs. Now the methods are defined
   outside the function in a non-exported list of functions (condenseMethod).
   Now, CondenseLogs can also accept a user-defined function.
2. In addition, corrected bug appearing when the method average was applied to
   a group with only one present measure log-ratio.
3. Added some entries to the thesauri.
4. Changed the priority order in CondenseLogs following users feedback. 
   Now "BT" has priority over "Bd" as representative of Width. 

# zoolog 0.3.1
1. Correction of error when generating vignettes with locale different from
   UTF-8. The error raised in particular for operating systems with Latin-1
   default, such as debian-clang.
2. Correction of a few misspellings. 

# zoolog 0.3.0
1. Corrected bug in function CondenseLogs. 
   Previous version failed if a measure included in the grouping was not 
   present in the used reference to compute the log ratios.
   The new version is also more robust, not needing the original
   measurements, only the log ratios.
2. More systematic documentation of references. Now each reference
   description is more systematically included in the comments of the
   corresponding reference file and the help page "referencesDatabase"
   automatically reads their description from each file.
3. Added 3 new references (Haifa) for Dama, Equid, and Gazelle.
4. Added 2 new references for Equid (Johnstone) and rabbit (Nottingham).
5. Completed thesauri with new taxa, elements and measurements 
   included in the new references, and also some measurements missing 
   from previous references.

# zoolog 0.2.0
1. Improved structure of references. Now there is a database organized by taxa 
   and a method to assemble the datasets.
2. Also better documentation and correction of some mistakes in the references.
3. Enlargement of the thesauri.
4. Added the functionality `mergedMeasures` (optional parameter) to the function
   `LogRatios`
5. Corrected erroneous reference_Sus_Albarella.

# zoolog 0.1.0
First release.
