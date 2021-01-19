#remember - IRS scores are specific to EACH IES, so really we want the lines that mac scaffolds that sandiwich either side of an IES 
#Example - IES at chr2 3742264-3743994 - want the mac scaffolds either side at 3742262 (IES:3742264-3743994) 3743993
#those corresponsing mac scaffold positions (3742262 in mic is 101906 in Mac and 3743993 is 101905 [only 1 bp gap]) 
#these are the regions we want to look at for our IRS scores 
library(dplyr)

setwd("/home/aahowel3/Documents/flowsortdata/retention_scores2")
data=read.csv("mic.mac.sorted.chain",sep=" ",header=FALSE)
#final trailing column on the second line is part of the "alignment data lines"
#column = size of ungapped alignment 

#extract out comeplete rows
df1 = data[seq(1, nrow(data), 2), ]
#extract out lagging last column
df2 = data[seq(2, nrow(data), 2), ]
#glue together
df1 <- cbind(df1, V14 = df2$V1)

names(df1)=c("chain","chainscore","refname","refsize","strand","refstart","refend","queryname",
             "querysize","qstrand","querystart","queryend","chainID","ungapsize")

#order and subset
#subset my chromosome
df2=df1[with(df1,order(queryname,querystart)),]
chain_bychr=split(df2,with(df2,interaction(queryname)),drop=TRUE)

#shift columns of chain file so you can check if IES range x-y falls between gap a-b between end of one mac scaffold and beginning of another
res <- lapply(chain_bychr, function(x){
  x$queryshift = append(x$querystart[-1],x$querysize[1])
  
  x$refshift = append(x$refstart[-1],x$refend[1])
  
  x$refnameshift = append(as.character(x$refname[-1]),as.character(last(x$refname)))
  
  
  col_order = c("chain","chainscore","refname","refsize","strand","refstart","refend","refshift","refnameshift","queryname",
                "querysize","qstrand","querystart","queryend","queryshift","chainID","ungapsize")
  x = x[,col_order]
  x = x[with(x,order(queryend)),]
  
}) 

#Write to 5 different files per chromosome
write.table(res$chr1,file="chr1_chain.tsv",row.names = FALSE,sep="\t", quote=FALSE)

write.table(res$chr2,file="chr2_chain.tsv",row.names = FALSE,sep="\t", quote=FALSE)

write.table(res$chr3,file="chr3_chain.tsv",row.names = FALSE,sep="\t", quote=FALSE)

write.table(res$chr4,file="chr4_chain.tsv",row.names = FALSE,sep="\t", quote=FALSE)

write.table(res$chr5,file="chr5_chain.tsv",row.names = FALSE,sep="\t", quote=FALSE)