rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP2_L_geno <- read.table("../../../breeding_program/GGP2_produce/GGP2_L_produce/GGP2_L_geno.txt",header = F)
GGP2_L_name <- read.table("../../../breeding_program/name_pedigree/landrace/GGP2_L_pop_name.txt",header = T)
num_GGP2_L <- 110
GGP2_L_geno_name <- list()
for (i in 1:num_GGP2_L) {
  ind <- GGP2_L_geno[,(2*i-1):(2*i)]
  GGP2_L_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP2_L_geno_name <- bind_cols(GGP2_L_geno_name)
colnames(GGP2_L_geno_name) <- GGP2_L_name[,3]
GGP2_L_vcf <- cbind(vcf_info,GGP2_L_geno_name)

write.table(GGP2_L_vcf,"GGP2_L.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
