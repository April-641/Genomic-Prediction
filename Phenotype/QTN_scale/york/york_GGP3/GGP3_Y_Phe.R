rm(list = ls())
setwd(getwd())
num_Pat_upd <- 20
num_Mat_upd <- 250
num_Mat_keep <- 250
#GGP3中更新的部分来自GP2，未更新的部分来自GGP2中的GP1部分（因为GGP2中未更新的部分GGP1不能再次使用，所以GGP2到GGP3时保留的个体为来自GP1的那部分母畜，GGP2中来自GGP1的那部分母畜被淘汰）
GP2_Y_Phe01 <- read.table("../york_GP2/GP2_Y_Phe01.txt",header = F)
GP2_Y_Phe03 <- read.table("../york_GP2/GP2_Y_Phe03.txt",header = F)
GP2_Y_Phe05 <- read.table("../york_GP2/GP2_Y_Phe05.txt",header = F)
GP1_Y_Phe01 <- read.table("../york_GP1/GP1_Y_Phe01.txt",header = F)
GP1_Y_Phe03 <- read.table("../york_GP1/GP1_Y_Phe03.txt",header = F)
GP1_Y_Phe05 <- read.table("../york_GP1/GP1_Y_Phe05.txt",header = F)
GGP3_Y_name <- read.table("./GGP3_Y_name.txt",header = T)

GGP3_Y_Phe01 <- list()
for (i in 1:(num_Pat_upd+num_Mat_upd)) {
  GGP3_Y_Phe01[[i]] <- GP2_Y_Phe01[grep(GGP3_Y_name[i,1],GP2_Y_Phe01$V1),]
  for (j in (num_Pat_upd+num_Mat_upd+1):(num_Pat_upd+num_Mat_upd+num_Mat_keep)) {
    GGP3_Y_Phe01[[j]] <- GP1_Y_Phe01[grep(GGP3_Y_name[j,1],GP1_Y_Phe01$V1),]  
  }
}
library(dplyr)
GGP3_Y_Phe01 <- bind_rows(GGP3_Y_Phe01)

GGP3_Y_Phe03 <- list()
for (i in 1:(num_Pat_upd+num_Mat_upd)) {
  GGP3_Y_Phe03[[i]] <- GP2_Y_Phe03[grep(GGP3_Y_name[i,1],GP2_Y_Phe03$V1),]
  for (j in (num_Pat_upd+num_Mat_upd+1):(num_Pat_upd+num_Mat_upd+num_Mat_keep)) {
    GGP3_Y_Phe03[[j]] <- GP1_Y_Phe03[grep(GGP3_Y_name[j,1],GP1_Y_Phe03$V1),]  
  }
}
library(dplyr)
GGP3_Y_Phe03 <- bind_rows(GGP3_Y_Phe03)

GGP3_Y_Phe05 <- list()
for (i in 1:(num_Pat_upd+num_Mat_upd)) {
  GGP3_Y_Phe05[[i]] <- GP2_Y_Phe05[grep(GGP3_Y_name[i,1],GP2_Y_Phe05$V1),]
  for (j in (num_Pat_upd+num_Mat_upd+1):(num_Pat_upd+num_Mat_upd+num_Mat_keep)) {
    GGP3_Y_Phe05[[j]] <- GP1_Y_Phe05[grep(GGP3_Y_name[j,1],GP1_Y_Phe05$V1),]  
  }
}
library(dplyr)
GGP3_Y_Phe05 <- bind_rows(GGP3_Y_Phe05)

save.image("GGP3_Y_Phe.RData")
write.table(GGP3_Y_Phe01,"GGP3_Y_Phe01.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP3_Y_Phe03,"GGP3_Y_Phe03.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GGP3_Y_Phe05,"GGP3_Y_Phe05.txt",quote = F,sep = "\t",row.names = F,col.names = F)


