rm(list = ls())
setwd(getwd())
num_LY_dam <- 10000
LY_Phe01 <- read.table("../LY/LY_Phe01.txt",header = F)
LY_Phe03 <- read.table("../LY/LY_Phe03.txt",header = F)
LY_Phe05 <- read.table("../LY/LY_Phe05.txt",header = F)
LY_dam_name <- read.table("./LY_dam_name.txt",header = T)

LY_dam_Phe01 <- list()
for (i in 1:num_LY_dam) {
  LY_dam_Phe01[[i]] <- LY_Phe01[grep(LY_dam_name[i,1],LY_Phe01$V1),]
}
library(dplyr)
LY_dam_Phe01 <- bind_rows(LY_dam_Phe01)

LY_dam_Phe03 <- list()
for (i in 1:num_LY_dam) {
  LY_dam_Phe03[[i]] <- LY_Phe03[grep(LY_dam_name[i,1],LY_Phe03$V1),]
}
library(dplyr)
LY_dam_Phe03 <- bind_rows(LY_dam_Phe03)

LY_dam_Phe05 <- list()
for (i in 1:num_LY_dam) {
  LY_dam_Phe05[[i]] <- LY_Phe05[grep(LY_dam_name[i,1],LY_Phe05$V1),]
}
library(dplyr)
LY_dam_Phe05 <- bind_rows(LY_dam_Phe05)

save.image("LY_dam_Phe.RData")
write.table(LY_dam_Phe01,"LY_dam_Phe01.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(LY_dam_Phe03,"LY_dam_Phe03.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(LY_dam_Phe05,"LY_dam_Phe05.txt",quote = F,sep = "\t",row.names = F,col.names = F)


