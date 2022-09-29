rm(list = ls())
setwd(getwd())
num_Pat_upd <- 20
num_Mat_upd <- 250
num_Mat_keep <- 250
GP1_Y_Phe01 <- read.table("../york_GP1/GP1_Y_Phe01.txt",header = F)
GP1_Y_Phe03 <- read.table("../york_GP1/GP1_Y_Phe03.txt",header = F)
GP1_Y_Phe05 <- read.table("../york_GP1/GP1_Y_Phe05.txt",header = F)
GGP1_Y_Phe01 <- read.table("../york_GGP1/GGP1_Y_Phe01.txt",header = F)
GGP1_Y_Phe03 <- read.table("../york_GGP1/GGP1_Y_Phe03.txt",header = F)
GGP1_Y_Phe05 <- read.table("../york_GGP1/GGP1_Y_Phe05.txt",header = F)
GGP2_Y_name <- read.table("./GGP2_Y_name.txt",header = T)

GGP2_Y_Phe01 <- list()
for (i in 1:(num_Pat_upd+num_Mat_upd)) {
  GGP2_Y_Phe01[[i]] <- GP1_Y_Phe01[grep(GGP2_Y_name[i,1],GP1_Y_Phe01$V1),]
  for (j in (num_Pat_upd+num_Mat_upd+1):(num_Pat_upd+num_Mat_upd+num_Mat_keep)) {
    GGP2_Y_Phe01[[j]] <- GGP1_Y_Phe01[grep(GGP2_Y_name[j,1],GGP1_Y_Phe01$V1),]  
  }
}
library(dplyr)
GGP2_Y_Phe01 <- bind_rows(GGP2_Y_Phe01)

GGP2_Y_Phe03 <- list()
for (i in 1:(num_Pat_upd+num_Mat_upd)) {
  GGP2_Y_Phe03[[i]] <- GP1_Y_Phe03[grep(GGP2_Y_name[i,1],GP1_Y_Phe03$V1),]
  for (j in (num_Pat_upd+num_Mat_upd+1):(num_Pat_upd+num_Mat_upd+num_Mat_keep)) {
    GGP2_Y_Phe03[[j]] <- GGP1_Y_Phe03[grep(GGP2_Y_name[j,1],GGP1_Y_Phe03$V1),]  
  }
}
library(dplyr)
GGP2_Y_Phe03 <- bind_rows(GGP2_Y_Phe03)

GGP2_Y_Phe05 <- list()
for (i in 1:(num_Pat_upd+num_Mat_upd)) {
  GGP2_Y_Phe05[[i]] <- GP1_Y_Phe05[grep(GGP2_Y_name[i,1],GP1_Y_Phe05$V1),]
  for (j in (num_Pat_upd+num_Mat_upd+1):(num_Pat_upd+num_Mat_upd+num_Mat_keep)) {
    GGP2_Y_Phe05[[j]] <- GGP1_Y_Phe05[grep(GGP2_Y_name[j,1],GGP1_Y_Phe05$V1),]  
  }
}
library(dplyr)
GGP2_Y_Phe05 <- bind_rows(GGP2_Y_Phe05)

save.image("GGP2_Y_Phe.RData")
write.table(GGP2_Y_Phe01,"GGP2_Y_Phe01.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP2_Y_Phe03,"GGP2_Y_Phe03.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP2_Y_Phe05,"GGP2_Y_Phe05.txt",quote = F,sep = "\t",row.names = F,col.names = F)


