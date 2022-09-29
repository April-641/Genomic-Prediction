rm(list=ls())

setwd(getwd())
GP_Y_ind <- 5000
genetic_variance <- 1
Genetic_effect <- read.table("GP1_Y_TBV.txt",header=F)

#模拟遗传力为0.5的性状表型
env_nor_mean <- 0
env_nor_var05 <- genetic_variance
set.seed(74637289)
env_eff05 <- rnorm(GP_Y_ind,env_nor_mean,env_nor_var05)
phe05 <- Genetic_effect
phe05[,3] <- env_eff05
phe05[,4] <- phe05[,2]+phe05[,3]

#模拟遗传力为0.3的性状表型
env_nor_var03 <- genetic_variance*7/3
set.seed(16473829)
env_eff03 <- rnorm(GP_Y_ind,env_nor_mean,env_nor_var03)
phe03 <- Genetic_effect
phe03[,3] <- env_eff03
phe03[,4] <- phe03[,2]+phe03[,3]

#模拟遗传力为0.1的性状表型
env_nor_var01 <- genetic_variance*9
set.seed(74857372)
env_eff01 <- rnorm(GP_Y_ind,env_nor_mean,env_nor_var01)
phe01 <- Genetic_effect
phe01[,3] <- env_eff01
phe01[,4] <- phe01[,2]+phe01[,3]

save.image("GP1_Y_Phe.RData")
write.table(phe01,"GP1_Y_Phe01.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(phe03,"GP1_Y_Phe03.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(phe05,"GP1_Y_Phe05.txt",quote = F,sep = "\t",row.names = F,col.names = F)
