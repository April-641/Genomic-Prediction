rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP2_Y_geno <- read.table("../../../breeding_program/GGP2_GP2/GGP2_GP2_Y/GP2_Y_geno.txt",header = F)
GP2_Y_name <- read.table("../../../breeding_program/name_pedigree/york/GP2_Y_pop_name.txt",header = T)
num_GP2_Y <- 5000
GP2_Y_geno_name <- list()
for (i in 1:num_GP2_Y) {
  ind <- GP2_Y_geno[,(2*i-1):(2*i)]
  GP2_Y_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP2_Y_geno_name <- bind_cols(GP2_Y_geno_name)
colnames(GP2_Y_geno_name) <- GP2_Y_name[,3]
GP2_Y_vcf <- cbind(vcf_info,GP2_Y_geno_name)

write.table(GP2_Y_vcf,"GP2_Y.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
