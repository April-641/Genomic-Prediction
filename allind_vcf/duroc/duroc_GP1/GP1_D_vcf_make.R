rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP1_D_geno <- read.table("../../../breeding_program/GGP1_GP1/GGP1_GP1_D/GP1_D_geno.txt",header = F)
GP1_D_name <- read.table("../../../breeding_program/name_pedigree/duroc/GP1_D_pop_name.txt",header = T)
num_GP_D <- 500
GP1_D_geno_name <- list()
for (i in 1:num_GP_D) {
  ind <- GP1_D_geno[,(2*i-1):(2*i)]
  GP1_D_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP1_D_geno_name <- bind_cols(GP1_D_geno_name)
colnames(GP1_D_geno_name) <- GP1_D_name[,3]
GP1_D_vcf <- cbind(vcf_info,GP1_D_geno_name)

write.table(GP1_D_vcf,"GP1_D.vcf",row.names = F,col.names = T,sep = "\t",quote = F)


