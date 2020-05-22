#######################################################
#NOW finding out average coverage for positions within IES coordinates in Mic chromo and positions in Mac-dest regions
#Need to seperate out by chromosome, what is an IES position in 1 chromo may not be in another 
args = commandArgs(trailingOnly=TRUE)

#read in IESs chromosome X and Coverage chromosome X as paired files 
data3=read.csv(args[1],sep="\t",header=TRUE)
data4=read.csv(args[2],sep="\t",header=FALSE)


#if any position appears between the columns IES_in_chromo_start and IES_in_chromo_end 
data4$state = ifelse(sapply(data4$V2, function(p) 
  any(data3$IES_in_chromosome_start <= p & data3$IES_in_chromosome_end >= p)),"IES", NA)

IES=subset(data4, state == "IES")
Mac_dest=data4[is.na(data4$state),]

a=c(sum(IES$V3),length(IES$V3),sum(Mac_dest$V3),length(Mac_dest$V3))
print(a, quote=FALSE)



