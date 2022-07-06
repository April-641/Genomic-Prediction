#Extract the name(IID) of GP2_D_cross and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/duroc/GP2_D_cross_pop_name.txt >GP2_D_cross_name.txt