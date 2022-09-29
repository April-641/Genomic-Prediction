rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
LY_geno <- read.table("../../../breeding_program/LY_produce/LY_geno.txt",header = F)
LY_name <- read.table("../../../breeding_program/name_pedigree/LY/LY_pop_name.txt",header = T)
num_LY <- 20000
LY_geno_name <- list()
for (i in 1:num_LY) {
  ind <- LY_geno[,(2*i-1):(2*i)]
  LY_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
LY_geno_name <- bind_cols(LY_geno_name)
colnames(LY_geno_name) <- LY_name[,3]
LY_vcf <- cbind(vcf_info,LY_geno_name)

write.table(LY_vcf,"LY.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
