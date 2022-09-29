rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP3_L_geno <- read.table("../../../breeding_program/GGP3_GP3/GGP3_GP3_L/GP3_L_geno.txt",header = F)
GP3_L_name <- read.table("../../../breeding_program/name_pedigree/landrace/GP3_L_pop_name.txt",header = T)
num_GP3_L <- 1000
GP3_L_geno_name <- list()
for (i in 1:num_GP3_L) {
  ind <- GP3_L_geno[,(2*i-1):(2*i)]
  GP3_L_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP3_L_geno_name <- bind_cols(GP3_L_geno_name)
colnames(GP3_L_geno_name) <- GP3_L_name[,3]
GP3_L_vcf <- cbind(vcf_info,GP3_L_geno_name)

write.table(GP3_L_vcf,"GP3_L.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
