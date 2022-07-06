# Add a "#" to the header of the first line of the GP1_L_cross.vcf file obtained after running the "GP1_L_cross_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP1_L_cross.vcf --recode --out GP1_L_cross
plink --file GP1_L_cross --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP1_L_cross_ref