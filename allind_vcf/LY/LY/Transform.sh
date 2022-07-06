# Add a "#" to the header of the first line of the LY.vcf file obtained after running the "LY_vcf_make.R" script
# Then run the following commands: 
plink --vcf LY.vcf --recode --out LY
plink --file LY --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out LY_ref