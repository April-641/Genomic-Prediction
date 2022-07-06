#Extract the name(IID) of GP1_Y_cross and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/york/GP1_Y_cross_pop_name.txt >GP1_Y_cross_name.txt