#Extract the name(IID) of GGP2_D and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/duroc/GGP2_D_pop_name.txt >GGP2_D_name.txt