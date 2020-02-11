#usage: R flowsort_refcomp_auto.R - must be run in folder with MQtxtfiles 

#read in all files and remove extension
filenames=Sys.glob("*txt")
for (filename in filenames) {
  newFileName <- gsub("*_pri.txt", '',filename)
  assign(newFileName, read.csv(filename, header=FALSE,sep="\t"))
}

#mac to mac v mac to mic 1st
data=merge(Mac_S2_L001_tomac_MQ_first, Mac_S2_L001_tomic_MQ_first, all=TRUE, sort=FALSE, by = "V1")
#remove reads that are only present in one dataset or the other
#either from IES specific reads or reads that overlap an IES region 
data=data[complete.cases(data),]
#sample to ideal ref
diffs1= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs2= data[data$V3.x < data$V3.y,]

#mac to mac v mac to mic 2nd
data=merge(Mac_S2_L001_tomac_MQ_second, Mac_S2_L001_tomic_MQ_second, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs3= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs4= data[data$V3.x < data$V3.y,]

#wc to mac v wc to mic 1st
data=merge(SB210E_subset_formac_tomac_MQ_first, SB210E_subset_formac_tomic_MQ_first, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs5= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs6= data[data$V3.x < data$V3.y,]

#wc to mac v wc to mic second
data=merge(SB210E_subset_formac_tomac_MQ_second, SB210E_subset_formac_tomic_MQ_second, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs7= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs8= data[data$V3.x < data$V3.y,]

#setup table quadrants
mac2mac=nrow(diffs1) + nrow(diffs3)
mac2mic=nrow(diffs2) + nrow(diffs4)
wc2mac=nrow(diffs5) + nrow(diffs7)
wc2mic=nrow(diffs6) + nrow(diffs8)

datax=matrix(c(mac2mac,mac2mic,wc2mac,wc2mic), ncol=2,byrow=TRUE)
data=as.data.frame(datax)
rownames(data)=c("Macfqs_mappedpreferrentially","wcfqs_mappedpreferrentially")
colnames(data)=c("Mac_ref","Mic_ref")
data
fisher.test(data, alternative="less")

