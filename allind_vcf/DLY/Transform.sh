# Add a "#" to the header of the first line of the DLY.vcf file obtained after running the "DLY_vcf_make.R" script
# Then run the following commands: 
plink --vcf DLY.vcf --recode --out DLY
plink --file DLY --a2-allele ../GGP1_vcf_ref.txt 2 1 --recode vcf-iid --out DLY_ref