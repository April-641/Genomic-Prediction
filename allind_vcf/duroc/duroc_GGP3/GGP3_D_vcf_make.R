rm(list=ls())
setwd(getwd())
vcf_info <- read.table("../../vcf_information.txt",header = T)
GGP3_D_geno <- read.table("../../../breeding_program/GGP3_produce/GGP3_D_produce/GGP3_D_geno.txt",header = F)
GGP3_D_name <- read.table("../../../breeding_program/name_pedigree/duroc/GGP3_D_pop_name.txt",header = T)
num_GGP3_D <- 60
GGP3_D_geno_name <- list()
for (i in 1:num_GGP3_D) {
  ind <- GGP3_D_geno[,(2*i-1):(2*i)]
  GGP3_D_geno_name[[i]]<- paste(ind[,1],ind[,2],sep = "/")
}
library(dplyr)
GGP3_D_geno_name <- bind_cols(GGP3_D_geno_name)
colnames(GGP3_D_geno_name) <- GGP3_D_name[,3]
GGP3_D_vcf <- cbind(vcf_info,GGP3_D_geno_name)

write.table(GGP3_D_vcf,"GGP3_D.vcf",row.names = F,col.names = T,sep = "\t",quote = F)


