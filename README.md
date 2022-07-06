# Genomic-Prediction
This directory contains source data and scripts related to the manuscript "Genomic prediction using commercial crossbred population in pigs".
Repository contains:
-Phase.zip: Vcf files and haplotype text files of GGP1 population after phasing, divided by breeds. The contents of the zip are as follows,
    Duroc: duroc.vcf, GGP1_D_geno.txt
    Landrace: landrace.vcf, GGP1_L_geno.txt
    Yorkshire: york.vcf, GGP1_Y_geno.txt
-breeding_program: Scripts for genotypic simulation of the mating processes for each generation in the crossbreeding system of this experiment.
-allind_vcf: The haplotype text file of each population obtained after genotypic simulation was converted to vcf format.
-Phenotype: The true breeding value of each individual was calculated based on the extracted QTL, and then summed with the environmental effect to obtain the phenotypic value of each individual.
