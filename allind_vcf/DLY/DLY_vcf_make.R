rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../vcf_information.txt",header = T)
DLY_geno <- read.table("../../breeding_program/DLY_produce/DLY_geno.txt",header = F)
DLY_name <- read.table("../../breeding_program/name_pedigree/DLY/DLY_pop_name.txt",header = T)
num_DLY <- 100000
DLY_geno_name <- list()
for (i in 1:num_DLY) {
  ind <- DLY_geno[,(2*i-1):(2*i)]
  DLY_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
DLY_geno_name <- bind_cols(DLY_geno_name)
colnames(DLY_geno_name) <- DLY_name[,3]
DLY_vcf <- cbind(vcf_info,DLY_geno_name)

write.table(DLY_vcf,"DLY.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
