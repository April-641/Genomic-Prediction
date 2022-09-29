rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP1_L_geno <- read.table("../../../breeding_program/GGP1_GP1/GGP1_GP1_L/GP1_L_geno.txt",header = F)
GP1_L_name <- read.table("../../../breeding_program/name_pedigree/landrace/GP1_L_pop_name.txt",header = T)
num_GP1_L <- 1000
GP1_L_geno_name <- list()
for (i in 1:num_GP1_L) {
  ind <- GP1_L_geno[,(2*i-1):(2*i)]
  GP1_L_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP1_L_geno_name <- bind_cols(GP1_L_geno_name)
colnames(GP1_L_geno_name) <- GP1_L_name[,3]
GP1_L_vcf <- cbind(vcf_info,GP1_L_geno_name)

write.table(GP1_L_vcf,"GP1_L.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
