rm(list=ls())

setwd(getwd())
library(tibble)
GP_Y_ind <- 5000
num_qtn <- 100

qtn <- read.table("../../qtn.txt",header=T)
GP1_Y_vcf <- read.table("./GP1_Y_ref.vcf",header = T)
qtn_row <- read.table("../../qtn_row.txt",header=F)
qtn_row <- as.numeric(qtn_row$V1)
qtn_geno <- GP1_Y_vcf[c(qtn_row),]
Genetic_effect=colnames(qtn_geno)
Genetic_effect <- as_tibble(Genetic_effect)

for (i in 10:ncol(qtn_geno)) {
  qtn_geno[,i] <- gsub("0/0","0",qtn_geno[,i])
  qtn_geno[,i] <- gsub("0/1","1",qtn_geno[,i])
  qtn_geno[,i] <- gsub("1/0","1",qtn_geno[,i])
  qtn_geno[,i] <- gsub("1/1","2",qtn_geno[,i])
  qtn_geno[,i] <- as.numeric(qtn_geno[,i])
}
qtn_geno[,8] <- qtn$Effect

for (i in 10:ncol(qtn_geno)) {
  tmp <- qtn_geno[,c(8,i)]
  for (j in 1:num_qtn) {
    tmp[j,3] <- tmp[j,1] %*% tmp[j,2]
    Genetic_effect[i,2] <- sum(tmp[,3])
  }
}
Genetic_effect <- Genetic_effect[-c(1:9),] #到这步才去除那些不需要的表头，因为可以和上一个for循环的i对应
colnames(Genetic_effect) <- c("IID","A_effect")

save.image("GP1_Y_TBV.RData")
write.table(qtn_geno,"GP1_Y_qtn_geno.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(Genetic_effect,"GP1_Y_TBV.txt",quote = F,sep = "\t",row.names = F,col.names = F)