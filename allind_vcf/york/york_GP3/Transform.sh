# Add a "#" to the header of the first line of the GP3_Y.vcf file obtained after running the "GP3_Y_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP3_Y.vcf --recode --out GP3_Y
plink --file GP3_Y --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP3_Y_ref