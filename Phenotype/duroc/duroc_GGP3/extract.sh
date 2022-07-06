#Extract the name(IID) of GGP3_D and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/duroc/GGP3_D_pop_name.txt >GGP3_D_name.txt