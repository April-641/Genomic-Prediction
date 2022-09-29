rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP1_L_geno <- read.table("../../../breeding_program/GGP1_GP1/GGP1_GP1_L/GGP1_L_geno.txt",header = F)
GGP1_L_name <- read.table("../../../breeding_program/name_pedigree/landrace/GGP1_L_pop_name.txt",header = T)
num_GGP1_L <- 110
GGP1_L_geno_name <- list()
for (i in 1:num_GGP1_L) {
  ind <- GGP1_L_geno[,(2*i-1):(2*i)]
  GGP1_L_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP1_L_geno_name <- bind_cols(GGP1_L_geno_name)
colnames(GGP1_L_geno_name) <- GGP1_L_name[,3]
GGP1_L_vcf <- cbind(vcf_info,GGP1_L_geno_name)

write.table(GGP1_L_vcf,"GGP1_L.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
