# Add a "#" to the header of the first line of the GP2_Y.vcf file obtained after running the "GP2_Y_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP2_Y.vcf --recode --out GP2_Y
plink --file GP2_Y --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP2_Y_ref