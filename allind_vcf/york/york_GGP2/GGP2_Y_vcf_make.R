rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP2_Y_geno <- read.table("../../../breeding_program/GGP2_produce/GGP2_Y_produce/GGP2_Y_geno.txt",header = F)
GGP2_Y_name <- read.table("../../../breeding_program/name_pedigree/york/GGP2_Y_pop_name.txt",header = T)
num_GGP2_Y <- 520
GGP2_Y_geno_name <- list()
for (i in 1:num_GGP2_Y) {
  ind <- GGP2_Y_geno[,(2*i-1):(2*i)]
  GGP2_Y_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP2_Y_geno_name <- bind_cols(GGP2_Y_geno_name)
colnames(GGP2_Y_geno_name) <- GGP2_Y_name[,3]
GGP2_Y_vcf <- cbind(vcf_info,GGP2_Y_geno_name)

write.table(GGP2_Y_vcf,"GGP2_Y.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
