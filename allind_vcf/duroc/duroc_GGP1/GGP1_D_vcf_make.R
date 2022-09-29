rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP1_D_geno <- read.table("../../../breeding_program/GGP1_GP1/GGP1_GP1_D/GGP1_D_geno.txt",header = F)
GGP1_D_name <- read.table("../../../breeding_program/name_pedigree/duroc/GGP1_D_pop_name.txt",header = T)
num_GGP1_D <- 60
GGP1_D_geno_name <- list()
for (i in 1:num_GGP1_D) {
  ind <- GGP1_D_geno[,(2*i-1):(2*i)]
  GGP1_D_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP1_D_geno_name <- bind_cols(GGP1_D_geno_name)
colnames(GGP1_D_geno_name) <- GGP1_D_name[,3]
GGP1_D_vcf <- cbind(vcf_info,GGP1_D_geno_name)

write.table(GGP1_D_vcf,"GGP1_D.vcf",row.names = F,col.names = T,sep = "\t",quote = F)
