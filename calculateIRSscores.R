setwd("/home/aahowel3/Documents/flowsortdata/retention_scores2")
datamic=read.csv("chr2IRSscores_micsample.txt",sep="\t",header=FALSE)
names(datamic)=c("IES_ID","IESplus","IESminus")

datamic$IRS=(datamic$IESplus)/(datamic$IESplus + datamic$IESminus) 
datamic[is.na(datamic)] = 0 

mean(datamic$IRS)

barplot(table(datamic$IRS), main="IES Retention Scores Micronuclear FACS Sample Chromosome 2", xlab="IRS", ylab="Frequency")

setwd("/home/aahowel3/Documents/flowsortdata/retention_scores2")
datamac=read.csv("chr2IRSscores_macsample.txt",sep="\t",header=FALSE)
names(datamac)=c("IES_ID","IESplus","IESminus")

datamac$IRS=(datamac$IESplus)/(datamac$IESplus + datamac$IESminus) 
datamac[is.na(datamac)] = 0 

mean(datamac$IRS)

barplot(table(datamac$IRS), main="IES Retention Scores Macronuclear FACS Sample Chromosome 2", xlab="IRS", ylab="Frequency")

