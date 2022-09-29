rm(list = ls())
setwd(getwd())
num_D_cross <- 100
GP2_D_Phe01 <- read.table("../duroc_GP2/GP2_D_Phe01.txt",header = F)
GP2_D_Phe03 <- read.table("../duroc_GP2/GP2_D_Phe03.txt",header = F)
GP2_D_Phe05 <- read.table("../duroc_GP2/GP2_D_Phe05.txt",header = F)
GP2_D_cross_name <- read.table("./GP2_D_cross_name.txt",header = T)

GP2_D_cross_Phe01 <- list()
for (i in 1:num_D_cross) {
  GP2_D_cross_Phe01[[i]] <- GP2_D_Phe01[grep(GP2_D_cross_name[i,1],GP2_D_Phe01$V1),]
}
library(dplyr)
GP2_D_cross_Phe01 <- bind_rows(GP2_D_cross_Phe01)

GP2_D_cross_Phe03 <- list()
for (i in 1:num_D_cross) {
  GP2_D_cross_Phe03[[i]] <- GP2_D_Phe03[grep(GP2_D_cross_name[i,1],GP2_D_Phe03$V1),]
}
library(dplyr)
GP2_D_cross_Phe03 <- bind_rows(GP2_D_cross_Phe03)

GP2_D_cross_Phe05 <- list()
for (i in 1:num_D_cross) {
  GP2_D_cross_Phe05[[i]] <- GP2_D_Phe05[grep(GP2_D_cross_name[i,1],GP2_D_Phe05$V1),]
}
library(dplyr)
GP2_D_cross_Phe05 <- bind_rows(GP2_D_cross_Phe05)

save.image("GP2_D_cross_Phe.RData")
write.table(GP2_D_cross_Phe01,"GP2_D_cross_Phe01.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP2_D_cross_Phe03,"GP2_D_cross_Phe03.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(GP2_D_cross_Phe05,"GP2_D_cross_Phe05.txt",quote = F,sep = "\t",row.names = F,col.names = F)


