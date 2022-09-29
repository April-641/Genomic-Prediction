rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GP2_D_geno <- read.table("../../../breeding_program/GGP2_GP2/GGP2_GP2_D/GP2_D_geno.txt",header = F)
GP2_D_name <- read.table("../../../breeding_program/name_pedigree/duroc/GP2_D_pop_name.txt",header = T)
num_GP_D <- 500
GP2_D_geno_name <- list()
for (i in 1:num_GP_D) {
  ind <- GP2_D_geno[,(2*i-1):(2*i)]
  GP2_D_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GP2_D_geno_name <- bind_cols(GP2_D_geno_name)
colnames(GP2_D_geno_name) <- GP2_D_name[,3]
GP2_D_vcf <- cbind(vcf_info,GP2_D_geno_name)

write.table(GP2_D_vcf,"GP2_D.vcf",row.names = F,col.names = T,sep = "\t",quote = F)


