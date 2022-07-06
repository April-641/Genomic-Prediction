#Extract the name(IID) of LY_dam and export the column to a new file
awk ‘{print $3}’ ../../../breeding_program/name_pedigree/LY/LY_dam_pop_name.txt >LY_dam_name.txt