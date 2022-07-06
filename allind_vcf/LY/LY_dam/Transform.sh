# Add a "#" to the header of the first line of the LY_dam.vcf file obtained after running the "LY_dam_vcf_make.R" script
# Then run the following commands: 
plink --vcf LY_dam.vcf --recode --out LY_dam
plink --file LY_dam --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out LY_dam_ref