rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP1_Y_geno <- read.table("../../../breeding_program/GGP1_GP1/GGP1_GP1_Y/GGP1_Y_geno.txt",header = F)
GGP1_Y_name <- read.table("../../../breeding_program/name_pedigree/york/GGP1_Y_pop_name.txt",header = T)
num_GGP1_Y <- 520
GGP1_Y_geno_name <- list()
for (i in 1:num_GGP1_Y) {
  ind <- GGP1_Y_geno[,(2*i-1):(2*i)]
  GGP1_Y_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP1_Y_geno_name <- bind_cols(GGP1_Y_geno_name)
colnames(GGP1_Y_geno_name) <- GGP1_Y_name[,3]
GGP1_Y_vcf <- cbind(vcf_info,GGP1_Y_geno_name)

write.table(GGP1_Y_vcf,"GGP1_Y.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
