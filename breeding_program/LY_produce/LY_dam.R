rm(list=ls())
setwd(getwd())
LY_geno <- read.table("LY_geno.txt",header = F)
LY_pop <- read.table("LY_pop.txt",header = T)
num_LY_dam <- nrow(LY_pop)/2
LY_dam_pop <- subset(LY_pop,sex==2)
LY_dam <- list()
for (i in 1:num_LY_dam) {
  LY_dam[[i]] <- LY_geno[,((2*LY_dam_pop$index[i])-1):(2*LY_dam_pop$index[i])]
}
library(dplyr)
LY_dam_geno <- bind_cols(LY_dam) 
save.image("LY_dam.RData")
write.table(LY_dam_geno,file = "LY_dam_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(LY_dam_pop,file = "LY_dam_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
