rm(list=ls())
setwd(getwd())
GP1_Y_geno <- read.table("../../GGP1_GP1/GGP1_GP1_Y/GP1_Y_geno.txt",header = F)
GP1_Y_pop <- read.table("../../GGP1_GP1/GGP1_GP1_Y/GP1_Y_pop.txt",header = T)
GGP1_Y_geno <- read.table("../../GGP1_GP1/GGP1_GP1_Y/GGP1_Y_geno.txt",header = F)
GGP1_Y_pop <- read.table("../../GGP1_GP1/GGP1_GP1_Y/GGP1_Y_pop.txt",header = T)
num_Pat <- 20
num_Mat <- 500
num_prog <- 10
mat_rat <- num_Mat/num_Pat
num_pat_upd <- num_Pat*1
num_mat_upd <- num_Mat*0.5
num_keep <- num_Mat-num_mat_upd
num_cross <- 2000
num_mat_upd%/%num_pat_upd  
num_mat_upd%%num_pat_upd  
GP1_Y_upd_pat <- list()
for (i in 1:num_pat_upd) {
  GP1_Y_upd_pat[[i]] <-  GP1_Y_pop[(mat_rat*num_prog*(i-1))+(sample(grep(1,GP1_Y_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),num_pat_upd/num_Pat,replace = F)),]
} 
library(dplyr)
GP1_Y_upd_pat <- bind_rows(GP1_Y_upd_pat)
GP1_Y_upd_mat1 <- list()
for (i in 1:num_pat_upd) {
  GP1_Y_upd_mat1[[i]] <-  GP1_Y_pop[(mat_rat*num_prog*(i-1))+(sample(grep(2,GP1_Y_pop[(mat_rat*num_prog*i-((mat_rat*num_prog)-1)):(mat_rat*num_prog*i),7]),(num_mat_upd%/%num_Pat),replace = F)),]
} 
GP1_Y_upd_mat1 <- bind_rows(GP1_Y_upd_mat1)
GP1_Y_no_mat1_dam <- subset(GP1_Y_pop[-c(GP1_Y_upd_mat1$index),],sex==2)
GP1_Y_upd_mat2 <- GP1_Y_no_mat1_dam[(sample(1:nrow(GP1_Y_no_mat1_dam),(num_mat_upd%%num_pat_upd),replace = F)),]  
GP1_Y_upd_total <- bind_rows(GP1_Y_upd_pat,GP1_Y_upd_mat1,GP1_Y_upd_mat2) 
GP1_Y_upd_pop <- GP1_Y_upd_total[order(GP1_Y_upd_total$sex,GP1_Y_upd_total$index),] 
GP1_Y_upd <- list()
for (i in 1:(num_pat_upd+num_mat_upd)) {
  GP1_Y_upd[[i]] <- GP1_Y_geno[,((2*GP1_Y_upd_pop$index[i])-1):(2*GP1_Y_upd_pop$index[i])]
} 
GP1_Y_upd_geno <- bind_cols(GP1_Y_upd) 
GGP1_Y_keep_ind <- sort(sample(c((num_Pat+1):(num_Pat+num_Mat)),num_keep,replace = F))
GGP1_Y_keep_pop <- GGP1_Y_pop[c(GGP1_Y_keep_ind),]
GGP1_Y_keep <- list()
for (i in 1:num_keep) {
  GGP1_Y_keep[[i]] <- GGP1_Y_geno[,((2*GGP1_Y_keep_ind[i])-1):(2*GGP1_Y_keep_ind[i])] 
} 
GGP1_Y_keep_geno <- bind_cols(GGP1_Y_keep)
GGP2_Y_pop <- rbind(GP1_Y_upd_pop,GGP1_Y_keep_pop)
GGP2_Y_geno <- cbind(GP1_Y_upd_geno,GGP1_Y_keep_geno)
GP1_Y_pop_noupd_sire <- subset(GP1_Y_pop[-c(GP1_Y_upd_pop$index),],sex==2)
GP1_Y_cross_pop <- GP1_Y_pop_noupd_sire[sort(sample(1:nrow(GP1_Y_pop_noupd_sire),num_cross,replace = F)),]
GP1_Y_cross <- list()
for (i in 1:num_cross) {
  GP1_Y_cross[[i]] <- GP1_Y_geno[,((2*GP1_Y_cross_pop$index[i])-1):(2*GP1_Y_cross_pop$index[i])]
}
GP1_Y_cross_geno <- bind_cols(GP1_Y_cross)
save.image("GGP2_Y_produce.RData")
write.table(GGP2_Y_geno,"GGP2_Y_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP2_Y_pop,"GGP2_Y_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_Y_cross_geno,"GP1_Y_cross_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP1_Y_cross_pop,"GP1_Y_cross_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
