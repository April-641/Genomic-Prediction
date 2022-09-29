rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP3_Y<-read.table("./GP3_Y.raw",header=T)

ID<-GP3_Y[,2]
GP3_D<-as.matrix(GP3_Y[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP3_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP3_Y_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



