rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP3_Y_geno <- read.table("../../../breeding_program/GGP3_produce/GGP3_Y_produce/GGP3_Y_geno.txt",header = F)
GGP3_Y_name <- read.table("../../../breeding_program/name_pedigree/york/GGP3_Y_pop_name.txt",header = T)
num_GGP3_Y <- 520
GGP3_Y_geno_name <- list()
for (i in 1:num_GGP3_Y) {
  ind <- GGP3_Y_geno[,(2*i-1):(2*i)]
  GGP3_Y_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP3_Y_geno_name <- bind_cols(GGP3_Y_geno_name)
colnames(GGP3_Y_geno_name) <- GGP3_Y_name[,3]
GGP3_Y_vcf <- cbind(vcf_info,GGP3_Y_geno_name)

write.table(GGP3_Y_vcf,"GGP3_Y.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
