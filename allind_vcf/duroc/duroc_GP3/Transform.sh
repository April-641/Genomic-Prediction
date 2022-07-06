# Add a "#" to the header of the first line of the GP3_D.vcf file obtained after running the "GP3_D_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP3_D.vcf --recode --out GP3_D
plink --file GP3_D --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP3_D_ref