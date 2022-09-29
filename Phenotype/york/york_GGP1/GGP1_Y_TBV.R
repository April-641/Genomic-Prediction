rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GGP1_Y<-read.table("./GGP1_Y.raw",header=T)

ID<-GGP1_Y[,2]
GGP1_D<-as.matrix(GGP1_Y[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GGP1_D%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GGP1_Y_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



