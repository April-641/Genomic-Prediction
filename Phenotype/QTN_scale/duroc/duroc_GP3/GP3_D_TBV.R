rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP3_D<-read.table("../../../duroc/duroc_GP3/GP3_D.raw",header=T)

ID<-GP3_D[,2]
GP3_D<-as.matrix(GP3_D[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP3_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP3_D_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



