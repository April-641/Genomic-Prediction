rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GP3_L<-read.table("../../../landrace/landrace_GP3/GP3_L.raw",header=T)

ID<-GP3_L[,2]
GP3_L<-as.matrix(GP3_L[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GP3_L%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GP3_L_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



