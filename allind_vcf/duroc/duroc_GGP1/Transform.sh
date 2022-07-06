# Add a "#" to the header of the first line of the GGP1_D.vcf file obtained after running the "GGP1_D_vcf_make.R" script
# Then run the following commands: 
plink --vcf GGP1_D.vcf --recode --out GGP1_D
plink --file GGP1_D --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GGP1_D_ref