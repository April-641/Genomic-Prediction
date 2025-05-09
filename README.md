# Genomic-Prediction
This directory contains source data and scripts related to the manuscript "Genomic prediction in pigs using data from a commercial crossbred population: insights from the Duroc x (Landrace x Yorkshire) three-way crossbreeding system" and "Optimisation of variance component estimation and genomic prediction in a commercial crossbred population of Duroc x (Landrace x Yorkshire) three-way pigs".

Repository contains:

-Phase.zip: Vcf files and haplotype text files of GGP1 population after phasing, divided by breeds. The contents of the zip are as follows,

    Duroc: duroc.vcf, GGP1_D_geno.txt
    
    Landrace: landrace.vcf, GGP1_L_geno.txt
    
    Yorkshire: york.vcf, GGP1_Y_geno.txt
    
-breeding_program: Scripts for genotype simulation of the mating processes for each generation in the crossbreeding system of this research.

-allind_vcf: The haplotype text file of each population obtained after genotype simulation was converted to vcf format and the corresponding ped/map file was obtained.

-Phenotype: The true breeding value of each individual was calculated based on the simulated QTLs, and then summed with the environmental effect to obtain the phenotypic value of each individual.

-select: which contains the text file of the reference allele of the markers passed quality control filters.
