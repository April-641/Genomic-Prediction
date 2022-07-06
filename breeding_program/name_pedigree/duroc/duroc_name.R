rm(list = ls())
setwd(getwd())
num_Pat_D <- 10
num_Mat_D <- 50
mat_rat <- num_Mat_D/num_Pat_D
num_prog <- 10
num_pat_upd_D <- num_Pat_D*1
num_mat_upd_D <- num_Mat_D*0.5
num_keep_D <- num_Mat_D-num_mat_upd_D
num_cross_D <- 100
GGP1_D_pop <- read.table("../../GGP1_GP1/GGP1_GP1_D/GGP1_D_pop.txt",header = T)
GGP1_D_pop$sex <- gsub(1,"S",GGP1_D_pop$sex)
GGP1_D_pop$sex <- gsub(2,"D",GGP1_D_pop$sex)
GGP1_D_pop[,8] <- paste("GGP1D",GGP1_D_pop$sex,sprintf("%02d",c(1:nrow(GGP1_D_pop))),sep = "")
GGP1_D_pop[,c(9,10)] <- c(0)
colnames(GGP1_D_pop) <- c("gen","index","fam","infam","sir","dam","sex","IID","FID","MID")
GP1_D_pop <- read.table("../../GGP1_GP1/GGP1_GP1_D/GP1_D_pop.txt",header = T)
GP1_D_pop$sex <- gsub(1,"S",GP1_D_pop$sex)
GP1_D_pop$sex <- gsub(2,"D",GP1_D_pop$sex)
GP1_D_pop[,8] <- paste("GP1D",GP1_D_pop$sex,sprintf("%03d",c(1:nrow(GP1_D_pop))),sep = "")
for (i in 1:num_Pat_D) {
  GP1_D_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP1_D_pop[i,8] 
}
for (i in (num_Pat_D+1):(num_Pat_D+num_Mat_D)) {
  GP1_D_pop[(num_prog*(i-num_Pat_D)-(num_prog-1)):(num_prog*(i-num_Pat_D)),10] <- GGP1_D_pop[i,8] 
}
colnames(GP1_D_pop) <- colnames(GGP1_D_pop)
GGP2_D_pop <- read.table("../../GGP2_produce/GGP2_D_produce/GGP2_D_pop.txt",header = T) 
GGP2_D_pop_upd <- list()
for (i in 1:(num_pat_upd_D+num_mat_upd_D)) {
  GGP2_D_pop_upd[[i]] <- GP1_D_pop[GGP2_D_pop$index[i],]
}
library(dplyr)
GGP2_D_pop_upd <- bind_rows(GGP2_D_pop_upd)
GGP2_D_pop_keep <- list()
for (j in (num_pat_upd_D+num_mat_upd_D+1):(num_pat_upd_D+num_mat_upd_D+num_keep_D)) {
  GGP2_D_pop_keep[[j]] <- GGP1_D_pop[GGP2_D_pop$index[j],]
}
GGP2_D_pop_keep <- bind_rows(GGP2_D_pop_keep)
GGP2_D_pop_total <- rbind(GGP2_D_pop_upd,GGP2_D_pop_keep)
GP2_D_pop <- read.table("../../GGP2_GP2/GGP2_GP2_D/GP2_D_pop.txt",header = T)
GP2_D_pop$sex <- gsub(1,"S",GP2_D_pop$sex)
GP2_D_pop$sex <- gsub(2,"D",GP2_D_pop$sex)
GP2_D_pop[,8] <- paste("GP2D",GP2_D_pop$sex,sprintf("%03d",c(1:nrow(GP2_D_pop))),sep = "")
for (i in 1:num_Pat_D) {
  GP2_D_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP2_D_pop_total[i,8]
}
for (i in (num_Pat_D+1):(num_Pat_D+num_Mat_D)) {
  GP2_D_pop[(num_prog*(i-num_Pat_D)-(num_prog-1)):(num_prog*(i-num_Pat_D)),10] <- GGP2_D_pop_total[i,8]
}
colnames(GP2_D_pop) <- colnames(GGP1_D_pop)
GGP3_D_pop <- read.table("../../GGP3_produce/GGP3_D_produce/GGP3_D_pop.txt",header = T) 
GGP3_D_pop_upd <- list()
for (i in 1:(num_pat_upd_D+num_mat_upd_D)) {
  GGP3_D_pop_upd[[i]] <- GP2_D_pop[GGP3_D_pop$index[i],]  
}
library(dplyr)
GGP3_D_pop_upd <- bind_rows(GGP3_D_pop_upd)
GGP3_D_pop_keep <- list()
for (j in (num_pat_upd_D+num_mat_upd_D+1):(num_pat_upd_D+num_mat_upd_D+num_keep_D)) {
  GGP3_D_pop_keep[[j]] <- GP1_D_pop[GGP3_D_pop$index[j],] 
}
GGP3_D_pop_keep <- bind_rows(GGP3_D_pop_keep)
GGP3_D_pop_total <- rbind(GGP3_D_pop_upd,GGP3_D_pop_keep)
GP2_D_cross_pop <- read.table("../../GGP3_produce/GGP3_D_produce/GP2_D_cross_pop.txt",header = T)
GP2_D_cross_pop_total <- list()
for (i in 1:num_cross_D) {
  GP2_D_cross_pop_total[[i]] <- GP2_D_pop[GP2_D_cross_pop$index[i],]
}
GP2_D_cross_pop_total <- bind_rows(GP2_D_cross_pop_total)
GP3_D_pop <- read.table("../../GGP3_GP3/GGP3_GP3_D/GP3_D_pop.txt",header = T)
GP3_D_pop$sex <- gsub(1,"S",GP3_D_pop$sex)
GP3_D_pop$sex <- gsub(2,"D",GP3_D_pop$sex)
GP3_D_pop[,8] <- paste("GP3D",GP3_D_pop$sex,sprintf("%03d",c(1:nrow(GP3_D_pop))),sep = "")
for (i in 1:num_Pat_D) {
  GP3_D_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GGP3_D_pop_total[i,8]
}
for (i in (num_Pat_D+1):(num_Pat_D+num_Mat_D)) {
  GP3_D_pop[(num_prog*(i-num_Pat_D)-(num_prog-1)):(num_prog*(i-num_Pat_D)),10] <- GGP3_D_pop_total[i,8]
}
colnames(GP3_D_pop) <- colnames(GGP1_D_pop)
GGP1_D_pop_name <- GGP1_D_pop[,c(1,7,8,9,10)]
GP1_D_pop_name <- GP1_D_pop[,c(1,7,8,9,10)]
GGP2_D_pop_name <- GGP2_D_pop_total[,c(1,7,8,9,10)]
GP2_D_pop_name <- GP2_D_pop[,c(1,7,8,9,10)]
GGP3_D_pop_name <- GGP3_D_pop_total[,c(1,7,8,9,10)]
GP2_D_cross_pop_name <- GP2_D_cross_pop_total[,c(1,7,8,9,10)]
GP3_D_pop_name <- GP3_D_pop[,c(1,7,8,9,10)]
write.table(GGP1_D_pop_name,"GGP1_D_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP1_D_pop_name,"GP1_D_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GGP2_D_pop_name,"GGP2_D_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP2_D_pop_name,"GP2_D_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GGP3_D_pop_name,"GGP3_D_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP2_D_cross_pop_name,"GP2_D_cross_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(GP3_D_pop_name,"GP3_D_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
