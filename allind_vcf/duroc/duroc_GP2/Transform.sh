# Add a "#" to the header of the first line of the GP2_D.vcf file obtained after running the "GP2_D_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP2_D.vcf --recode --out GP2_D
plink --file GP2_D --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP2_D_ref