rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP3_Y_geno <- read.table("../../../breeding_program/GGP3_GP3/GGP3_GP3_Y/GP3_Y_geno.txt",header = F)
GP3_Y_name <- read.table("../../../breeding_program/name_pedigree/york/GP3_Y_pop_name.txt",header = T)
num_GP3_Y <- 5000
GP3_Y_geno_name <- list()
for (i in 1:num_GP3_Y) {
  ind <- GP3_Y_geno[,(2*i-1):(2*i)]
  GP3_Y_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP3_Y_geno_name <- bind_cols(GP3_Y_geno_name)
colnames(GP3_Y_geno_name) <- GP3_Y_name[,3]
GP3_Y_vcf <- cbind(vcf_info,GP3_Y_geno_name)

write.table(GP3_Y_vcf,"GP3_Y.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
