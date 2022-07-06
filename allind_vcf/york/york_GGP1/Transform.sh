# Add a "#" to the header of the first line of the GGP1_Y.vcf file obtained after running the "GGP1_Y_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP1_Y.vcf --recode --out GGP1_Y
plink --file GGP1_Y --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP1_Y_ref