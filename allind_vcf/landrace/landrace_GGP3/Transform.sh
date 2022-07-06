# Add a "#" to the header of the first line of the GGP3_L.vcf file obtained after running the "GGP3_L_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP3_L.vcf --recode --out GGP3_L
plink --file GGP3_L --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP3_L_ref