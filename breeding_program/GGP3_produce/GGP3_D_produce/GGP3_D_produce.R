rm(list=ls())
setwd(getwd())
GP2_D_geno <- read.table("../../GGP2_GP2/GGP2_GP2_D/GP2_D_geno.txt",header = F)
GP2_D_pop <- read.table("../../GGP2_GP2/GGP2_GP2_D/GP2_D_pop.txt",header = T)
GGP2_D_geno <- read.table("../../GGP2_produce/GGP2_D_produce/GGP2_D_geno.txt",header = F)
GGP2_D_pop <- read.table("../../GGP2_produce/GGP2_D_produce/GGP2_D_pop.txt",header = T)
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
GP2_D_upd_pat <- list()
for (i in 1:num_pat_upd) {
  GP2_D_upd_pat[[i]] <-  GP2_D_pop[(mat_rat*num_prog*(i-1))+(sample(grep(1,GP2_D_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),num_pat_upd/num_Pat,replace = F)),]
} 
library(dplyr)
GP2_D_upd_pat <- bind_rows(GP2_D_upd_pat)
GP2_D_upd_mat1 <- list()
for (i in 1:num_pat_upd) {
  GP2_D_upd_mat1[[i]] <-  GP2_D_pop[(mat_rat*num_prog*(i-1))+(sample(grep(2,GP2_D_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),(num_mat_upd%/%num_Pat),replace = F)),]
} 
GP2_D_upd_mat1 <- bind_rows(GP2_D_upd_mat1)
GP2_D_no_mat1_dam <- subset(GP2_D_pop[-c(GP2_D_upd_mat1$index),],sex==2)
GP2_D_upd_mat2 <- GP2_D_no_mat1_dam[(sample(1:nrow(GP2_D_no_mat1_dam),(num_mat_upd%%num_pat_upd),replace = F)),]  
library(dplyr)
GP2_D_upd_total <- bind_rows(GP2_D_upd_pat,GP2_D_upd_mat1,GP2_D_upd_mat2) 
GP2_D_upd_pop <- GP2_D_upd_total[order(GP2_D_upd_total$sex,GP2_D_upd_total$index),] 
GP2_D_upd <- list()
for (i in 1:(num_pat_upd+num_mat_upd)) {
  GP2_D_upd[[i]] <- GP2_D_geno[,((2*GP2_D_upd_pop$index[i])-1):(2*GP2_D_upd_pop$index[i])]
} 
GP2_D_upd_geno <- bind_cols(GP2_D_upd) 
GGP2_D_keep_pop <- GGP2_D_pop[(num_pat_upd+1):(num_pat_upd+num_mat_upd),] 
GGP2_D_keep <- list()
for (i in 1:num_keep) {
  GGP2_D_keep[[i]] <- GGP2_D_geno[,(2*(num_pat_upd+i)-1):(2*(num_pat_upd+i))] 
} 
GGP2_D_keep_geno <- bind_cols(GGP2_D_keep)
GGP3_D_pop <- rbind(GP2_D_upd_pop,GGP2_D_keep_pop)
GGP3_D_geno <- cbind(GP2_D_upd_geno,GGP2_D_keep_geno)
GP2_D_pop_noupd_sire <- subset(GP2_D_pop[-c(GP2_D_upd_pop$index),],sex==1)
GP2_D_cross_pop <- GP2_D_pop_noupd_sire[sort(sample(1:nrow(GP2_D_pop_noupd_sire),num_cross,replace = F)),]
GP2_D_cross <- list()
for (i in 1:num_cross) {
  GP2_D_cross[[i]] <- GP2_D_geno[,((2*GP2_D_cross_pop$index[i])-1):(2*GP2_D_cross_pop$index[i])]
}
GP2_D_cross_geno <- bind_cols(GP2_D_cross)
save.image("GGP3_D_produce.RData")
write.table(GGP3_D_geno,"GGP3_D_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP3_D_pop,"GGP3_D_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP2_D_cross_geno,"GP2_D_cross_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP2_D_cross_pop,"GP2_D_cross_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
