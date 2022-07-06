#Extract the name(IID) of GGP2_L and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/landrace/GGP2_L_pop_name.txt >GGP2_L_name.txt