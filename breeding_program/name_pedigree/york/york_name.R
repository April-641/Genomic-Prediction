rm(list = ls())
setwd(getwd())
num_Pat_Y <- 20
num_Mat_Y <- 500
mat_rat <- num_Mat_Y/num_Pat_Y
num_prog <- 10
num_pat_upd_Y <- num_Pat_Y*1
num_mat_upd_Y <- num_Mat_Y*0.5
num_keep_Y <- num_Mat_Y-num_mat_upd_Y
num_cross_Y <- 2000
GGP1_Y_pop <- read.table("../../GGP1_GP1/GGP1_GP1_Y/GGP1_Y_pop.txt",header = T)
GGP1_Y_pop$sex <- gsub(1,"S",GGP1_Y_pop$sex)
GGP1_Y_pop$sex <- gsub(2,"D",GGP1_Y_pop$sex)
GGP1_Y_pop[,8] <- paste("GGP1Y",GGP1_Y_pop$sex,sprintf("%03d",c(1:nrow(GGP1_Y_pop))),sep = "")
GGP1_Y_pop[,c(9,10)] <- c(0)
colnames(GGP1_Y_pop) <- c("gen","index","fam","infam","sir","dam","sex","IID","FID","MID")
GP1_Y_pop <- read.table("../../GGP1_GP1/GGP1_GP1_Y/GP1_Y_pop.txt",header = T)
GP1_Y_pop$sex <- gsub(1,"S",GP1_Y_pop$sex)
GP1_Y_pop$sex <- gsub(2,"D",GP1_Y_pop$sex)
GP1_Y_pop[,8] <- paste("GP1Y",GP1_Y_pop$sex,sprintf("%04d",c(1:nrow(GP1_Y_pop))),sep = "")
for (i in 1:num_Pat_Y) {
  GP1_Y_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP1_Y_pop[i,8] 
}
for (i in (num_Pat_Y+1):(num_Pat_Y+num_Mat_Y)) {
  GP1_Y_pop[(num_prog*(i-num_Pat_Y)-(num_prog-1)):(num_prog*(i-num_Pat_Y)),10] <- GGP1_Y_pop[i,8] 
}
colnames(GP1_Y_pop) <- colnames(GGP1_Y_pop)
GGP2_Y_pop <- read.table("../../GGP2_produce/GGP2_Y_produce/GGP2_Y_pop.txt",header = T) 
GGP2_Y_pop_upd <- list()
for (i in 1:(num_pat_upd_Y+num_mat_upd_Y)) {
  GGP2_Y_pop_upd[[i]] <- GP1_Y_pop[GGP2_Y_pop$index[i],]
}
library(dplyr)
GGP2_Y_pop_upd <- bind_rows(GGP2_Y_pop_upd)
GGP2_Y_pop_keep <- list()
for (j in (num_pat_upd_Y+num_mat_upd_Y+1):(num_pat_upd_Y+num_mat_upd_Y+num_keep_Y)) {
  GGP2_Y_pop_keep[[j]] <- GGP1_Y_pop[GGP2_Y_pop$index[j],]
}
GGP2_Y_pop_keep <- bind_rows(GGP2_Y_pop_keep)
GGP2_Y_pop_total <- rbind(GGP2_Y_pop_upd,GGP2_Y_pop_keep)
GP2_Y_pop <- read.table("../../GGP2_GP2/GGP2_GP2_Y/GP2_Y_pop.txt",header = T)
GP2_Y_pop$sex <- gsub(1,"S",GP2_Y_pop$sex)
GP2_Y_pop$sex <- gsub(2,"D",GP2_Y_pop$sex)
GP2_Y_pop[,8] <- paste("GP2Y",GP2_Y_pop$sex,sprintf("%04d",c(1:nrow(GP2_Y_pop))),sep = "")
for (i in 1:num_Pat_Y) {
  GP2_Y_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP2_Y_pop_total[i,8]
}
for (i in (num_Pat_Y+1):(num_Pat_Y+num_Mat_Y)) {
  GP2_Y_pop[(num_prog*(i-num_Pat_Y)-(num_prog-1)):(num_prog*(i-num_Pat_Y)),10] <- GGP2_Y_pop_total[i,8]
}
colnames(GP2_Y_pop) <- colnames(GGP1_Y_pop)
GGP3_Y_pop <- read.table("../../GGP3_produce/GGP3_Y_produce/GGP3_Y_pop.txt",header = T) 
GGP3_Y_pop_upd <- list()
for (i in 1:(num_pat_upd_Y+num_mat_upd_Y)) {
  GGP3_Y_pop_upd[[i]] <- GP2_Y_pop[GGP3_Y_pop$index[i],]  
}
library(dplyr)
GGP3_Y_pop_upd <- bind_rows(GGP3_Y_pop_upd)
GGP3_Y_pop_keep <- list()
for (j in (num_pat_upd_Y+num_mat_upd_Y+1):(num_pat_upd_Y+num_mat_upd_Y+num_keep_Y)) {
  GGP3_Y_pop_keep[[j]] <- GP1_Y_pop[GGP3_Y_pop$index[j],] 
}
GGP3_Y_pop_keep <- bind_rows(GGP3_Y_pop_keep)
GGP3_Y_pop_total <- rbind(GGP3_Y_pop_upd,GGP3_Y_pop_keep)
GP1_Y_cross_pop <- read.table("../../GGP2_produce/GGP2_Y_produce/GP1_Y_cross_pop.txt",header = T)
GP1_Y_cross_pop_total <- list()
for (i in 1:num_cross_Y) {
  GP1_Y_cross_pop_total[[i]] <- GP1_Y_pop[GP1_Y_cross_pop$index[i],]
}
GP1_Y_cross_pop_total <- bind_rows(GP1_Y_cross_pop_total)
GP3_Y_pop <- read.table("../../GGP3_GP3/GGP3_GP3_Y/GP3_Y_pop.txt",header = T)
GP3_Y_pop$sex <- gsub(1,"S",GP3_Y_pop$sex)
GP3_Y_pop$sex <- gsub(2,"D",GP3_Y_pop$sex)
GP3_Y_pop[,8] <- paste("GP3Y",GP3_Y_pop$sex,sprintf("%04d",c(1:nrow(GP3_Y_pop))),sep = "")
for (i in 1:num_Pat_Y) {
  GP3_Y_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP3_Y_pop_total[i,8]
}
for (i in (num_Pat_Y+1):(num_Pat_Y+num_Mat_Y)) {
  GP3_Y_pop[(num_prog*(i-num_Pat_Y)-(num_prog-1)):(num_prog*(i-num_Pat_Y)),10] <- GGP3_Y_pop_total[i,8]
}
colnames(GP3_Y_pop) <- colnames(GGP1_Y_pop)
GGP1_Y_pop_name <- GGP1_Y_pop[,c(1,7,8,9,10)]
GP1_Y_pop_name <- GP1_Y_pop[,c(1,7,8,9,10)]
GGP2_Y_pop_name <- GGP2_Y_pop_total[,c(1,7,8,9,10)]
GP2_Y_pop_name <- GP2_Y_pop[,c(1,7,8,9,10)]
GGP3_Y_pop_name <- GGP3_Y_pop_total[,c(1,7,8,9,10)]
GP1_Y_cross_pop_name <- GP1_Y_cross_pop_total[,c(1,7,8,9,10)]
GP3_Y_pop_name <- GP3_Y_pop[,c(1,7,8,9,10)]
write.table(GGP1_Y_pop_name,"GGP1_Y_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_Y_pop_name,"GP1_Y_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GGP2_Y_pop_name,"GGP2_Y_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP2_Y_pop_name,"GP2_Y_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GGP3_Y_pop_name,"GGP3_Y_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_Y_cross_pop_name,"GP1_Y_cross_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP3_Y_pop_name,"GP3_Y_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
