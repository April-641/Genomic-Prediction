rm(list=ls())
setwd(getwd())
GP1_D_geno <- read.table("../../GGP1_GP1/GGP1_GP1_D/GP1_D_geno.txt",header = F)
GP1_D_pop <- read.table("../../GGP1_GP1/GGP1_GP1_D/GP1_D_pop.txt",header = T)
GGP1_D_geno <- read.table("../../GGP1_GP1/GGP1_GP1_D/GGP1_D_geno.txt",header = F)
GGP1_D_pop <- read.table("../../GGP1_GP1/GGP1_GP1_D/GGP1_D_pop.txt",header = T)
num_Pat <- 10
num_Mat <- 50
num_prog <- 10
mat_rat <- num_Mat/num_Pat
num_pat_upd <- num_Pat*1
num_mat_upd <- num_Mat*0.5
num_keep <- num_Mat-num_mat_upd
num_cross <- 100
num_mat_upd%/%num_pat_upd  
num_mat_upd%%num_pat_upd  
GP1_D_upd_pat <- list()
for (i in 1:num_pat_upd) {
  GP1_D_upd_pat[[i]] <-  GP1_D_pop[(mat_rat*num_prog*(i-1))+(sample(grep(1,GP1_D_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),num_pat_upd/num_Pat,replace = F)),]
} 
library(dplyr)
GP1_D_upd_pat <- bind_rows(GP1_D_upd_pat)
GP1_D_upd_mat1 <- list()
for (i in 1:num_pat_upd) {
  GP1_D_upd_mat1[[i]] <-  GP1_D_pop[(mat_rat*num_prog*(i-1))+(sample(grep(2,GP1_D_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),(num_mat_upd%/%num_Pat),replace = F)),]
} 
GP1_D_upd_mat1 <- bind_rows(GP1_D_upd_mat1)
GP1_D_no_mat1_dam <- subset(GP1_D_pop[-c(GP1_D_upd_mat1$index),],sex==2)
GP1_D_upd_mat2 <- GP1_D_no_mat1_dam[(sample(1:nrow(GP1_D_no_mat1_dam),(num_mat_upd%%num_pat_upd),replace = F)),]  
library(dplyr)
GP1_D_upd_total <- bind_rows(GP1_D_upd_pat,GP1_D_upd_mat1,GP1_D_upd_mat2) 
GP1_D_upd_pop <- GP1_D_upd_total[order(GP1_D_upd_total$sex,GP1_D_upd_total$index),] 
GP1_D_upd <- list()
for (i in 1:(num_pat_upd+num_mat_upd)) {
  GP1_D_upd[[i]] <- GP1_D_geno[,((2*GP1_D_upd_pop$index[i])-1):(2*GP1_D_upd_pop$index[i])]
} 
GP1_D_upd_geno <- bind_cols(GP1_D_upd) 
GGP1_D_keep_ind <- sort(sample(c((num_Pat+1):(num_Pat+num_Mat)),num_keep,replace = F))
GGP1_D_keep_pop <- GGP1_D_pop[c(GGP1_D_keep_ind),]
GGP1_D_keep <- list()
for (i in 1:num_keep) {
  GGP1_D_keep[[i]] <- GGP1_D_geno[,((2*GGP1_D_keep_ind[i])-1):(2*GGP1_D_keep_ind[i])] 
} 
GGP1_D_keep_geno <- bind_cols(GGP1_D_keep)
GGP2_D_pop <- rbind(GP1_D_upd_pop,GGP1_D_keep_pop)
GGP2_D_geno <- cbind(GP1_D_upd_geno,GGP1_D_keep_geno)
save.image("GGP2_D_produce.RData")
write.table(GGP2_D_geno,"GGP2_D_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP2_D_pop,"GGP2_D_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
