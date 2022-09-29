rm(list=ls())
setwd(getwd())
qtn <- read.table("../qtn.txt",header=T)
DLY<-read.table("../../DLY/DLY.raw",header=T)

ID<-DLY[,2]
DLY<-as.matrix(DLY[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-DLY%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"DLY_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



