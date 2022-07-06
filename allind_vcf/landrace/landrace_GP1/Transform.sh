# Add a "#" to the header of the first line of the GP1_L.vcf file obtained after running the "GP1_L_vcf_make.R" script
# Then run the following commands: 
plink --vcf GP1_L.vcf --recode --out GP1_L
plink --file GP1_L --a2-allele ../../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out GP1_L_ref