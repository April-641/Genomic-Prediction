#Extract the name(IID) of GGP2_Y and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/york/GGP2_Y_pop_name.txt >GGP2_Y_name.txt