rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP2_Y<-read.table("../../../york/york_GP2/GP2_Y.raw",header=T)

ID<-GP2_Y[,2]
GP2_Y<-as.matrix(GP2_Y[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP2_Y%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP2_Y_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



