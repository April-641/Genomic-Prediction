rm(list = ls())
setwd(getwd())
num_L_cross <- 100
GP1_L_Phe01 <- read.table("../landrace_GP1/GP1_L_Phe01.txt",header = F)
GP1_L_Phe03 <- read.table("../landrace_GP1/GP1_L_Phe03.txt",header = F)
GP1_L_Phe05 <- read.table("../landrace_GP1/GP1_L_Phe05.txt",header = F)
GP1_L_cross_name <- read.table("./GP1_L_cross_name.txt",header = T)

GP1_L_cross_Phe01 <- list()
for (i in 1:num_L_cross) {
  GP1_L_cross_Phe01[[i]] <- GP1_L_Phe01[grep(GP1_L_cross_name[i,1],GP1_L_Phe01$V1),]
}
library(dplyr)
GP1_L_cross_Phe01 <- bind_rows(GP1_L_cross_Phe01)

GP1_L_cross_Phe03 <- list()
for (i in 1:num_L_cross) {
  GP1_L_cross_Phe03[[i]] <- GP1_L_Phe03[grep(GP1_L_cross_name[i,1],GP1_L_Phe03$V1),]
}
library(dplyr)
GP1_L_cross_Phe03 <- bind_rows(GP1_L_cross_Phe03)

GP1_L_cross_Phe05 <- list()
for (i in 1:num_L_cross) {
  GP1_L_cross_Phe05[[i]] <- GP1_L_Phe05[grep(GP1_L_cross_name[i,1],GP1_L_Phe05$V1),]
}
library(dplyr)
GP1_L_cross_Phe05 <- bind_rows(GP1_L_cross_Phe05)

save.image("GP1_L_cross_Phe.RData")
write.table(GP1_L_cross_Phe01,"GP1_L_cross_Phe01.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP1_L_cross_Phe03,"GP1_L_cross_Phe03.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP1_L_cross_Phe05,"GP1_L_cross_Phe05.txt",quote = F,sep = "\t",row.names = F,col.names = F)


