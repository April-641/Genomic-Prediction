rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
LY_dam_geno <- read.table("../../../breeding_program/LY_produce/LY_dam_geno.txt",header = F)
LY_dam_name <- read.table("../../../breeding_program/name_pedigree/LY/LY_dam_pop_name.txt",header = T)
num_LY_dam <- 10000
LY_dam_geno_name <- list()
for (i in 1:num_LY_dam) {
  ind <- LY_dam_geno[,(2*i-1):(2*i)]
  LY_dam_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
LY_dam_geno_name <- bind_cols(LY_dam_geno_name)
colnames(LY_dam_geno_name) <- LY_dam_name[,3]
LY_dam_vcf <- cbind(vcf_info,LY_dam_geno_name)

write.table(LY_dam_vcf,"LY_dam.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
