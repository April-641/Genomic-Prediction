rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP1_L_cross_geno <- read.table("../../../breeding_program/GGP2_produce/GGP2_L_produce/GP1_L_cross_geno.txt",header = F)
GP1_L_cross_name <- read.table("../../../breeding_program/name_pedigree/landrace/GP1_L_cross_pop_name.txt",header = T)
num_cross_L <- 100
GP1_L_cross_geno_name <- list()
for (i in 1:num_cross_L) {
  ind <- GP1_L_cross_geno[,(2*i-1):(2*i)]
  GP1_L_cross_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP1_L_cross_geno_name <- bind_cols(GP1_L_cross_geno_name)
colnames(GP1_L_cross_geno_name) <- GP1_L_cross_name[,3]
GP1_L_cross_vcf <- cbind(vcf_info,GP1_L_cross_geno_name)

write.table(GP1_L_cross_vcf,"GP1_L_cross.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
