rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
LY<-read.table("../../../LY/LY.raw",header=T)

ID<-LY[,2]
LY<-as.matrix(LY[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-LY%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"LY_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



