# Add a "#" to the header of the first line of the GP1_Y.vcf file obtained after running the "GP1_Y_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP1_Y.vcf --recode --out GP1_Y
plink --file GP1_Y --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP1_Y_ref