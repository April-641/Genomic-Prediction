rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP1_D<-read.table("./GP1_D.raw",header=T)

ID<-GP1_D[,2]
GP1_D<-as.matrix(GP1_D[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP1_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP1_D_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



