# Add a "#" to the header of the first line of the GGP1_L.vcf file obtained after running the "GGP1_L_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP1_L.vcf --recode --out GGP1_L
plink --file GGP1_L --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP1_L_ref