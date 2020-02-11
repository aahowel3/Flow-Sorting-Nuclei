#usage: R flowsort_refcomp_auto.R - must be run in folder with MQtxtfiles 

#read in all files and remove extension
filenames=Sys.glob("*txt")
for (filename in filenames) {
  newFileName <- gsub("*_pri.txt", '',filename)
  assign(newFileName, read.csv(filename, header=FALSE,sep="\t"))
}

#mic to mic v mic to mac 1st
data=merge(Mic_S1_L001_tomic_MQ_first, Mic_S1_L001_tomac_MQ_first, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs1= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs2= data[data$V3.x < data$V3.y,]

#mic to mic v mic to mac second
data=merge(Mic_S1_L001_tomic_MQ_second, Mic_S1_L001_tomac_MQ_second, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs3= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs4= data[data$V3.x < data$V3.y,]

#wc to mac v wc to mic 1st
data=merge(SB210E_subset_formic_tomac_MQ_first, SB210E_subset_formic_tomic_MQ_first, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs5= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs6= data[data$V3.x < data$V3.y,]

#wc to mac v wc to mic second
data=merge(SB210E_subset_formic_tomac_MQ_second, SB210E_subset_formic_tomic_MQ_second, all=TRUE, sort=FALSE, by = "V1")
data=data[complete.cases(data),]
#sample to ideal ref
diffs7= data[data$V3.x > data$V3.y,]
#sample to nonideal ref 
diffs8= data[data$V3.x < data$V3.y,]

#setup table quadrants
mic2mic=nrow(diffs1) + nrow(diffs3)
mic2mac=nrow(diffs2) + nrow(diffs4)
wc2mac=nrow(diffs5) + nrow(diffs7)
wc2mic=nrow(diffs6) + nrow(diffs8)

datax=matrix(c(mic2mic,mic2mac,wc2mic,wc2mac), ncol=2,byrow=TRUE)
data=as.data.frame(datax)
rownames(data)=c("Micfqs_mappedpreferrentially","wcfqs_mappedpreferrentially")
colnames(data)=c("Mic_ref","Mac_ref")
data
fisher.test(data, alternative="greater")