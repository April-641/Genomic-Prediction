rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP1_Y<-read.table("../../../york/york_GP1/GP1_Y.raw",header=T)

ID<-GP1_Y[,2]
GP1_Y<-as.matrix(GP1_Y[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP1_Y%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP1_Y_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



