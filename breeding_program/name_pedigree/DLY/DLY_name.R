rm(list = ls())
setwd(getwd())
num_Pat_D <- 100
num_Mat_LY <- 10000
num_prog <- 10
mat_rat <- num_Mat_LY/num_Pat_D
DLY_pop <- read.table("../../DLY_produce/DLY_pop.txt",header = T)
GP2_D_cross_pop_name <- read.table("../duroc/GP2_D_cross_pop_name.txt",header = T)
LY_dam_pop_name <- read.table("../LY/LY_dam_pop_name.txt",header = T)
DLY_pop$sex <- gsub(1,"S",DLY_pop$sex)
DLY_pop$sex <- gsub(2,"D",DLY_pop$sex)
DLY_pop[,8] <- paste("SDLY",DLY_pop$sex,sprintf("%06d",c(1:nrow(DLY_pop))),sep = "")
for (i in 1:num_Pat_D) {
  DLY_pop[((mat_rat*num_prog*i)-(mat_rat*num_prog-1)):(mat_rat*num_prog*i),9] <- GP2_D_cross_pop_name[i,3] 
} 
for (i in 1:num_Mat_LY) {
  DLY_pop[(num_prog*i-(num_prog-1)):(num_prog*i),10] <- LY_dam_pop_name[i,3] 
} 
colnames(DLY_pop) <- c("gen","index","fam","infam","sir","dam","sex","IID","FID","MID")
DLY_pop_name <- DLY_pop[,c(1,7,8,9,10)]
write.table(DLY_pop_name,"DLY_pop_name.txt",quote = F,sep = "\t",row.names = F,col.names = T)
