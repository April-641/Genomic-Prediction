rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP2_D_geno <- read.table("../../../breeding_program/GGP2_produce/GGP2_D_produce/GGP2_D_geno.txt",header = F)
GGP2_D_name <- read.table("../../../breeding_program/name_pedigree/duroc/GGP2_D_pop_name.txt",header = T)
num_GGP2_D <- 60
GGP2_D_geno_name <- list()
for (i in 1:num_GGP2_D) {
  ind <- GGP2_D_geno[,(2*i-1):(2*i)]
  GGP2_D_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP2_D_geno_name <- bind_cols(GGP2_D_geno_name)
colnames(GGP2_D_geno_name) <- GGP2_D_name[,3]
GGP2_D_vcf <- cbind(vcf_info,GGP2_D_geno_name)

write.table(GGP2_D_vcf,"GGP2_D.vcf",row.names = F,col.names = T,sep = "\t",quote = F)


