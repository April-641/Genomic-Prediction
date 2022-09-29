rm(list=ls())
setwd(getwd())
qtn <- read.table("../../qtn.txt",header=T)
GGP1_L<-read.table("../../../landrace/landrace_GGP1/GGP1_L.raw",header=T)

ID<-GGP1_L[,2]
GGP1_L<-as.matrix(GGP1_L[,-c(1:6)])
qtneff<-as.matrix(qtn$Effect)
TBV<-GGP1_L%*%qtneff
rownames(TBV)<-ID

write.table(TBV,"GGP1_L_TBV.txt",quote = F,sep = "\t",row.names = T,col.names = F)



