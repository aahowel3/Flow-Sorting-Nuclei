setwd("~/Documents/flowsortdata/retention_scores")
#locations of IES in the mic supercontigs but not the chromosomes itself
data1=read.csv("IES_coordinates.csv")
#file that links locations of mic supercontigs to mic actual chromosomes
data2=read.csv("contig_to_chromosome.csv")
#dont do command below, there are IESs that still belong to "unassigned" super contigs that dont appear in mic chromosomes
#data2=data2[data2$Chromosome.superassembly != "unassigned",]
#can't create IES bedfile for the IES references because locations are in the supercontigs not chromosomes
#need to link IES location in supercontig to actual chromosomes
#primary keys linking the 2 files is the "supercontig" name 

library(tidyverse)
#wow that was suspisciously easy, god bless tidyverse
data3=left_join(data1,data2,by="supercontig")

#rename columns to something that makes sense
colnames(data3)=c("supercontig","IES_in_supercontig_start","IES_in_supercontig_end","IES_ID","IES_size",
  "start_supercontig","end_supercontig","chromosome_name","supercontig_in_chromosome_start",
  "supercontig_in_chromosome_end")

#2 conditions - if data2 start coord end coord are reverse (4000-1 instead of pos 1-4000) 
#have to reverse IES start and end as well to get accurate placement in mic chromosome
a=data3$IES_in_chromosome_start=data3$supercontig_in_chromosome_start + (data3$start_supercontig-data3$IES_in_supercontig_end)
b=data3$IES_in_chromosome_start=data3$supercontig_in_chromosome_start + data3$IES_in_supercontig_start 

data3=mutate(data3, IES_in_chromosome_start = ifelse(data3$start_supercontig > data3$end_supercontig, a, b))
data3$IES_in_chromosome_end=data3$IES_in_chromosome_start + data3$IES_size

#why is final file not the same length as IES file? 
#some "unique" IES ids occur multiple times because the supercontigs occur multiple times in data2
#supercontigs may assemble in multiple areas
#the IES associated with that supercontig at that position will also be duplicated
occur=table(data3$IES_ID)

#split data3 by chromosome, what is an IES position in 1 chromo may not be in another 
chromo1=data3[data3$chromosome_name == "chr1",]
write.table(chromo1,file="chr1_IESs_inmic.tsv",row.names = FALSE,sep="\t", quote=FALSE)

chromo2=data3[data3$chromosome_name == "chr2",]
write.table(chromo2,file="chr2_IESs_inmic.tsv",row.names = FALSE,sep="\t", quote=FALSE)

chromo3=data3[data3$chromosome_name == "chr3",]
write.table(chromo3,file="chr3_IESs_inmic.tsv",row.names = FALSE,sep="\t", quote=FALSE)

chromo4=data3[data3$chromosome_name == "chr4",]
write.table(chromo4,file="chr4_IESs_inmic.tsv",row.names = FALSE,sep="\t", quote=FALSE)

chromo5=data3[data3$chromosome_name == "chr5",]
write.table(chromo5,file="chr5_IESs_inmic.tsv",row.names = FALSE,sep="\t", quote=FALSE)
