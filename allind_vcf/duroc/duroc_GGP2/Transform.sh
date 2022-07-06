# Add a "#" to the header of the first line of the GGP2_D.vcf file obtained after running the "GGP2_D_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP2_D.vcf --recode --out GGP2_D
plink --file GGP2_D --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP2_D_ref