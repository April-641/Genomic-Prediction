rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP2_L_geno <- read.table("../../../breeding_program/GGP2_GP2/GGP2_GP2_L/GP2_L_geno.txt",header = F)
GP2_L_name <- read.table("../../../breeding_program/name_pedigree/landrace/GP2_L_pop_name.txt",header = T)
num_GP2_L <- 1000
GP2_L_geno_name <- list()
for (i in 1:num_GP2_L) {
  ind <- GP2_L_geno[,(2*i-1):(2*i)]
  GP2_L_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP2_L_geno_name <- bind_cols(GP2_L_geno_name)
colnames(GP2_L_geno_name) <- GP2_L_name[,3]
GP2_L_vcf <- cbind(vcf_info,GP2_L_geno_name)

write.table(GP2_L_vcf,"GP2_L.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
