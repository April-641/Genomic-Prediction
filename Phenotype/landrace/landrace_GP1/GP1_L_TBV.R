rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP1_L<-read.table("./GP1_L.raw",header=T)

ID<-GP1_L[,2]
GP1_D<-as.matrix(GP1_L[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP1_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP1_L_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



