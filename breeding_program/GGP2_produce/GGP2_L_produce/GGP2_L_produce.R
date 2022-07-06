rm(list=ls())
setwd(getwd())
GP1_L_geno <- read.table("../../GGP1_GP1/GGP1_GP1_L/GP1_L_geno.txt",header = F)
GP1_L_pop <- read.table("../../GGP1_GP1/GGP1_GP1_L/GP1_L_pop.txt",header = T)
GGP1_L_geno <- read.table("../../GGP1_GP1/GGP1_GP1_L/GGP1_L_geno.txt",header = F)
GGP1_L_pop <- read.table("../../GGP1_GP1/GGP1_GP1_L/GGP1_L_pop.txt",header = T)
num_Pat <- 10
num_Mat <- 100
num_prog <- 10
mat_rat <- num_Mat/num_Pat
num_pat_upd <- num_Pat*1
num_mat_upd <- num_Mat*0.5
num_keep <- num_Mat-num_mat_upd
num_cross <- 100
num_mat_upd%/%num_pat_upd  
num_mat_upd%%num_pat_upd  
GP1_L_upd_pat <- list()
for (i in 1:num_pat_upd) {
  GP1_L_upd_pat[[i]] <-  GP1_L_pop[(mat_rat*num_prog*(i-1))+(sample(grep(1,GP1_L_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),num_pat_upd/num_Pat,replace = F)),]
} 
library(dplyr)
GP1_L_upd_pat <- bind_rows(GP1_L_upd_pat)
GP1_L_upd_mat1 <- list()
for (i in 1:num_pat_upd) {
  GP1_L_upd_mat1[[i]] <-  GP1_L_pop[(mat_rat*num_prog*(i-1))+(sample(grep(2,GP1_L_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),(num_mat_upd%/%num_Pat),replace = F)),]
} 
GP1_L_upd_mat1 <- bind_rows(GP1_L_upd_mat1)
GP1_L_no_mat1_dam <- subset(GP1_L_pop[-c(GP1_L_upd_mat1$index),],sex==2)
GP1_L_upd_mat2 <- GP1_L_no_mat1_dam[(sample(1:nrow(GP1_L_no_mat1_dam),(num_mat_upd%%num_pat_upd),replace = F)),]  
library(dplyr)
GP1_L_upd_total <- bind_rows(GP1_L_upd_pat,GP1_L_upd_mat1,GP1_L_upd_mat2) 
GP1_L_upd_pop <- GP1_L_upd_total[order(GP1_L_upd_total$sex,GP1_L_upd_total$index),] 
GP1_L_upd <- list()
for (i in 1:(num_pat_upd+num_mat_upd)) {
  GP1_L_upd[[i]] <- GP1_L_geno[,((2*GP1_L_upd_pop$index[i])-1):(2*GP1_L_upd_pop$index[i])]
} 
GP1_L_upd_geno <- bind_cols(GP1_L_upd) 
GGP1_L_keep_ind <- sort(sample(c((num_Pat+1):(num_Pat+num_Mat)),num_keep,replace = F)) 
GGP1_L_keep_pop <- GGP1_L_pop[c(GGP1_L_keep_ind),]
GGP1_L_keep <- list()
for (i in 1:num_keep) {
  GGP1_L_keep[[i]] <- GGP1_L_geno[,((2*GGP1_L_keep_ind[i])-1):(2*GGP1_L_keep_ind[i])] 
} 
GGP1_L_keep_geno <- bind_cols(GGP1_L_keep)
GGP2_L_pop <- rbind(GP1_L_upd_pop,GGP1_L_keep_pop)
GGP2_L_geno <- cbind(GP1_L_upd_geno,GGP1_L_keep_geno)
GP1_L_pop_noupd_sire <- subset(GP1_L_pop[-c(GP1_L_upd_pop$index),],sex==1)
GP1_L_cross_pop <- GP1_L_pop_noupd_sire[sort(sample(1:nrow(GP1_L_pop_noupd_sire),num_cross,replace = F)),]
GP1_L_cross <- list()
for (i in 1:num_cross) {
  GP1_L_cross[[i]] <- GP1_L_geno[,((2*GP1_L_cross_pop$index[i])-1):(2*GP1_L_cross_pop$index[i])]
}
GP1_L_cross_geno <- bind_cols(GP1_L_cross)
save.image("GGP2_L_produce.RData")
write.table(GGP2_L_geno,"GGP2_L_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP2_L_pop,"GGP2_L_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_L_cross_geno,"GP1_L_cross_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP1_L_cross_pop,"GP1_L_cross_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
