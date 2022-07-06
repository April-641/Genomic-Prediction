rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP3_L_geno <- read.table("../../../breeding_program/GGP3_produce/GGP3_L_produce/GGP3_L_geno.txt",header = F)
GGP3_L_name <- read.table("../../../breeding_program/name_pedigree/landrace/GGP3_L_pop_name.txt",header = T)
num_GGP3_L <- 110
GGP3_L_geno_name <- list()
for (i in 1:num_GGP3_L) {
  ind <- GGP3_L_geno[,(2*i-1):(2*i)]
  GGP3_L_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP3_L_geno_name <- bind_cols(GGP3_L_geno_name)
colnames(GGP3_L_geno_name) <- GGP3_L_name[,3]
GGP3_L_vcf <- cbind(vcf_info,GGP3_L_geno_name)

write.table(GGP3_L_vcf,"GGP3_L.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
