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
