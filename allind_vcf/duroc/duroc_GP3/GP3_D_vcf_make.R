rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP3_D_geno <- read.table("../../../breeding_program/GGP3_GP3/GGP3_GP3_D/GP3_D_geno.txt",header = F)
GP3_D_name <- read.table("../../../breeding_program/name_pedigree/duroc/GP3_D_pop_name.txt",header = T)
num_GP_D <- 500
GP3_D_geno_name <- list()
for (i in 1:num_GP_D) {
  ind <- GP3_D_geno[,(2*i-1):(2*i)]
  GP3_D_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP3_D_geno_name <- bind_cols(GP3_D_geno_name)
colnames(GP3_D_geno_name) <- GP3_D_name[,3]
GP3_D_vcf <- cbind(vcf_info,GP3_D_geno_name)

write.table(GP3_D_vcf,"GP3_D.vcf",row.names = F,col.names = T,sep = "\t",quote = F)


