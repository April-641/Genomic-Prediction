rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP2_D<-read.table("./GP2_D.raw",header=T)

ID<-GP2_D[,2]
GP2_D<-as.matrix(GP2_D[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP2_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP2_D_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



