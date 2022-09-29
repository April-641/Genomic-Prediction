rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP1_Y_cross_geno <- read.table("../../../breeding_program/GGP2_produce/GGP2_Y_produce/GP1_Y_cross_geno.txt",header = F)
GP1_Y_cross_name <- read.table("../../../breeding_program/name_pedigree/york/GP1_Y_cross_pop_name.txt",header = T)
num_cross_Y <- 2000
GP1_Y_cross_geno_name <- list()
for (i in 1:num_cross_Y) {
  ind <- GP1_Y_cross_geno[,(2*i-1):(2*i)]
  GP1_Y_cross_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP1_Y_cross_geno_name <- bind_cols(GP1_Y_cross_geno_name)
colnames(GP1_Y_cross_geno_name) <- GP1_Y_cross_name[,3]
GP1_Y_cross_vcf <- cbind(vcf_info,GP1_Y_cross_geno_name)

write.table(GP1_Y_cross_vcf,"GP1_Y_cross.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
