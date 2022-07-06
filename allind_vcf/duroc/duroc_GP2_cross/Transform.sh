# Add a "#" to the header of the first line of the GP2_D_cross.vcf file obtained after running the "GP2_D_cross_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP2_D_cross.vcf --recode --out GP2_D_cross
plink --file GP2_D_cross --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP2_D_cross_ref