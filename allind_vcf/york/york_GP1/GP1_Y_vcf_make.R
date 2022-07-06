rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP1_Y_geno <- read.table("../../../breeding_program/GGP1_GP1/GGP1_GP1_Y/GP1_Y_geno.txt",header = F)
GP1_Y_name <- read.table("../../../breeding_program/name_pedigree/york/GP1_Y_pop_name.txt",header = T)
num_GP1_Y <- 5000
GP1_Y_geno_name <- list()
for (i in 1:num_GP1_Y) {
  ind <- GP1_Y_geno[,(2*i-1):(2*i)]
  GP1_Y_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP1_Y_geno_name <- bind_cols(GP1_Y_geno_name)
colnames(GP1_Y_geno_name) <- GP1_Y_name[,3]
GP1_Y_vcf <- cbind(vcf_info,GP1_Y_geno_name)

write.table(GP1_Y_vcf,"GP1_Y.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
