#Extract the name(IID) of GGP3_Y and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/york/GGP3_Y_pop_name.txt >GGP3_Y_name.txt