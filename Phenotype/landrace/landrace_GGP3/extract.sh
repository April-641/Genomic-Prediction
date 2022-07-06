#Extract the name(IID) of GGP3_L and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/landrace/GGP3_L_pop_name.txt >GGP3_L_name.txt