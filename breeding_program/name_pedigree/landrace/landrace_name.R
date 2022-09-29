rm(list = ls())
setwd(getwd())
num_Pat_L <- 10
num_Mat_L <- 100
mat_rat <- num_Mat_L/num_Pat_L
num_prog <- 10
num_pat_upd_L <- num_Pat_L*1
num_mat_upd_L <- num_Mat_L*0.5
num_keep_L <- num_Mat_L-num_mat_upd_L
num_cross_L <- 100
GGP1_L_pop <- read.table("../../GGP1_GP1/GGP1_GP1_L/GGP1_L_pop.txt",header = T)
GGP1_L_pop$sex <- gsub(1,"S",GGP1_L_pop$sex)
GGP1_L_pop$sex <- gsub(2,"D",GGP1_L_pop$sex)
GGP1_L_pop[,8] <- paste("GGP1L",GGP1_L_pop$sex,sprintf("%03d",c(1:nrow(GGP1_L_pop))),sep = "")
GGP1_L_pop[,c(9,10)] <- c(0)
colnames(GGP1_L_pop) <- c("gen","index","fam","infam","sir","dam","sex","IID","FID","MID")
GP1_L_pop <- read.table("../../GGP1_GP1/GGP1_GP1_L/GP1_L_pop.txt",header = T)
GP1_L_pop$sex <- gsub(1,"S",GP1_L_pop$sex)
GP1_L_pop$sex <- gsub(2,"D",GP1_L_pop$sex)
GP1_L_pop[,8] <- paste("GP1L",GP1_L_pop$sex,sprintf("%04d",c(1:nrow(GP1_L_pop))),sep = "")
for (i in 1:num_Pat_L) {
  GP1_L_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP1_L_pop[i,8] 
}
for (i in (num_Pat_L+1):(num_Pat_L+num_Mat_L)) {
  GP1_L_pop[(num_prog*(i-num_Pat_L)-(num_prog-1)):(num_prog*(i-num_Pat_L)),10] <- GGP1_L_pop[i,8] 
}
colnames(GP1_L_pop) <- colnames(GGP1_L_pop)
GGP2_L_pop <- read.table("../../GGP2_produce/GGP2_L_produce/GGP2_L_pop.txt",header = T) 
GGP2_L_pop_upd <- list()
for (i in 1:(num_pat_upd_L+num_mat_upd_L)) {
  GGP2_L_pop_upd[[i]] <- GP1_L_pop[GGP2_L_pop$index[i],]
}
library(dplyr)
GGP2_L_pop_upd <- bind_rows(GGP2_L_pop_upd)
GGP2_L_pop_keep <- list()
for (j in (num_pat_upd_L+num_mat_upd_L+1):(num_pat_upd_L+num_mat_upd_L+num_keep_L)) {
  GGP2_L_pop_keep[[j]] <- GGP1_L_pop[GGP2_L_pop$index[j],]
}
GGP2_L_pop_keep <- bind_rows(GGP2_L_pop_keep)
GGP2_L_pop_total <- rbind(GGP2_L_pop_upd,GGP2_L_pop_keep)
GP2_L_pop <- read.table("../../GGP2_GP2/GGP2_GP2_L/GP2_L_pop.txt",header = T)
GP2_L_pop$sex <- gsub(1,"S",GP2_L_pop$sex)
GP2_L_pop$sex <- gsub(2,"D",GP2_L_pop$sex)
GP2_L_pop[,8] <- paste("GP2L",GP2_L_pop$sex,sprintf("%04d",c(1:nrow(GP2_L_pop))),sep = "")
for (i in 1:num_Pat_L) {
  GP2_L_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP2_L_pop_total[i,8]
}
for (i in (num_Pat_L+1):(num_Pat_L+num_Mat_L)) {
  GP2_L_pop[(num_prog*(i-num_Pat_L)-(num_prog-1)):(num_prog*(i-num_Pat_L)),10] <- GGP2_L_pop_total[i,8]
}
colnames(GP2_L_pop) <- colnames(GGP1_L_pop)
GGP3_L_pop <- read.table("../../GGP3_produce/GGP3_L_produce/GGP3_L_pop.txt",header = T) 
GGP3_L_pop_upd <- list()
for (i in 1:(num_pat_upd_L+num_mat_upd_L)) {
  GGP3_L_pop_upd[[i]] <- GP2_L_pop[GGP3_L_pop$index[i],]  
}
library(dplyr)
GGP3_L_pop_upd <- bind_rows(GGP3_L_pop_upd)
GGP3_L_pop_keep <- list()
for (j in (num_pat_upd_L+num_mat_upd_L+1):(num_pat_upd_L+num_mat_upd_L+num_keep_L)) {
  GGP3_L_pop_keep[[j]] <- GP1_L_pop[GGP3_L_pop$index[j],] 
}
GGP3_L_pop_keep <- bind_rows(GGP3_L_pop_keep)
GGP3_L_pop_total <- rbind(GGP3_L_pop_upd,GGP3_L_pop_keep)
GP1_L_cross_pop <- read.table("../../GGP2_produce/GGP2_L_produce/GP1_L_cross_pop.txt",header = T)
GP1_L_cross_pop_total <- list()
for (i in 1:num_cross_L) {
  GP1_L_cross_pop_total[[i]] <- GP1_L_pop[GP1_L_cross_pop$index[i],]
}
GP1_L_cross_pop_total <- bind_rows(GP1_L_cross_pop_total)
GP3_L_pop <- read.table("../../GGP3_GP3/GGP3_GP3_L/GP3_L_pop.txt",header = T)
GP3_L_pop$sex <- gsub(1,"S",GP3_L_pop$sex)
GP3_L_pop$sex <- gsub(2,"D",GP3_L_pop$sex)
GP3_L_pop[,8] <- paste("GP3L",GP3_L_pop$sex,sprintf("%04d",c(1:nrow(GP3_L_pop))),sep = "")
for (i in 1:num_Pat_L) {
  GP3_L_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP3_L_pop_total[i,8]
}
for (i in (num_Pat_L+1):(num_Pat_L+num_Mat_L)) {
  GP3_L_pop[(num_prog*(i-num_Pat_L)-(num_prog-1)):(num_prog*(i-num_Pat_L)),10] <- GGP3_L_pop_total[i,8]
}
colnames(GP3_L_pop) <- colnames(GGP1_L_pop)
GGP1_L_pop_name <- GGP1_L_pop[,c(1,7,8,9,10)]
GP1_L_pop_name <- GP1_L_pop[,c(1,7,8,9,10)]
GGP2_L_pop_name <- GGP2_L_pop_total[,c(1,7,8,9,10)]
GP2_L_pop_name <- GP2_L_pop[,c(1,7,8,9,10)]
GGP3_L_pop_name <- GGP3_L_pop_total[,c(1,7,8,9,10)]
GP1_L_cross_pop_name <- GP1_L_cross_pop_total[,c(1,7,8,9,10)]
GP3_L_pop_name <- GP3_L_pop[,c(1,7,8,9,10)]
write.table(GGP1_L_pop_name,"GGP1_L_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_L_pop_name,"GP1_L_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GGP2_L_pop_name,"GGP2_L_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP2_L_pop_name,"GP2_L_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GGP3_L_pop_name,"GGP3_L_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_L_cross_pop_name,"GP1_L_cross_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP3_L_pop_name,"GP3_L_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
