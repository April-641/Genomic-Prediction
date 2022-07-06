# Add a "#" to the header of the first line of the GGP3_D.vcf file obtained after running the "GGP3_D_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP3_D.vcf --recode --out GGP3_D
plink --file GGP3_D --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP3_D_ref