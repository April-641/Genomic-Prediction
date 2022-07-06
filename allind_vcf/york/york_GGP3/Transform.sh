# Add a "#" to the header of the first line of the GGP3_Y.vcf file obtained after running the "GGP3_Y_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP3_Y.vcf --recode --out GGP3_Y
plink --file GGP3_Y --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP3_Y_ref