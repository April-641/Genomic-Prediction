rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP2_L<-read.table("./GP2_L.raw",header=T)

ID<-GP2_L[,2]
GP2_D<-as.matrix(GP2_L[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP2_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP2_L_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



