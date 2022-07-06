#Extract the name(IID) of GP1_L_cross and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/landrace/GP1_L_cross_pop_name.txt >GP1_L_cross_name.txt