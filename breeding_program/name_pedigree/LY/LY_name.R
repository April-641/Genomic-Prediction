rm(list = ls())
setwd(getwd())
num_Pat_L <- 100
num_Mat_Y <- 2000
num_prog <- 10
mat_rat <- num_Mat_Y/num_Pat_L
LY_pop <- read.table("../../LY_produce/LY_pop.txt",header = T)
GP1_L_cross_pop_name <- read.table("../landrace/GP1_L_cross_pop_name.txt",header = T)
GP1_Y_cross_pop_name <- read.table("../york/GP1_Y_cross_pop_name.txt",header = T)
LY_pop$sex <- gsub(1,"S",LY_pop$sex)
LY_pop$sex <- gsub(2,"D",LY_pop$sex)
LY_pop[,8] <- paste("PLY",LY_pop$sex,sprintf("%05d",c(1:nrow(LY_pop))),sep = "")
for (i in 1:num_Pat_L) {
  LY_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GP1_L_cross_pop_name[i,3] 
} 
for (i in 1:num_Mat_Y) {
  LY_pop[(num_prog*i-(num_prog-1)):(num_prog*i),10] <- GP1_Y_cross_pop_name[i,3] 
} 
colnames(LY_pop) <- c("gen","index","fam","infam","sir","dam","sex","IID","FID","MID")
LY_pop_name <- LY_pop[,c(1,7,8,9,10)]
LY_dam_pop_name <- subset(LY_pop_name,sex=="D")
write.table(LY_pop_name,"LY_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(LY_dam_pop_name,"LY_dam_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
