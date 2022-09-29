rm(list=ls())

setwd(getwd())
library(tibble)
num_qtn <- 2000

GGP1_vcf_info <- read.table("GGP1_vcf.txt",header = T)
set.seed(23746928)
qtn_row <- sort(sample(grep("A|T|C|G",GGP1_vcf_info[,5]),num_qtn,replace = F))
qtn <- GGP1_vcf_info[c(qtn_row),c(1:5)] 
set.seed(28746529)
qtn_eff_num <- rgamma(num_qtn,shape = 0.4,scale = 1/1.66) 
set.seed(48793569)
qtn_pos_or_neg <- sample(c("-","+"),size = num_qtn,replace = T)
qtn_eff <- as.numeric(paste(qtn_pos_or_neg,qtn_eff_num,sep = ""))
qtn[,6] <- qtn_eff
colnames(qtn) <- c("CHROM","POS","ID","REF","ALT","Effect")
qtnid<-as.data.frame(qtn[,3])

save.image("QTN_produce.RData")
write.table(qtn,"qtn.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(qtnid,"QTNid.txt",quote = F,sep = "\t",row.names = F,col.names = F)
