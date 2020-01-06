#Mac MQ scores for Macref and Micref alignment 
data1=read.csv("Mac_S2_L001_tomac_MQ.txt",header=FALSE)
counts1=table(data1$V1)
mean(data1$V1)

data2=read.csv("Mac_S2_L001_tomic_MQ.txt",header=FALSE)
counts2=table(data2$V1)
mean(data2$V1)


par(mfrow=c(2,1))

barplot(counts1, log="y")
barplot(counts2, log="y")

#Mic MQ scores for Macref and Micref alignment 
data1=read.csv("Mic_S1_L001_tomic_MQ.txt",header=FALSE)
counts1=table(data1$V1)
mean(data1$V1)

data2=read.csv("Mic_S1_L001_tomac_MQ.txt",header=FALSE)
counts2=table(data2$V1)
mean(data2$V1)

par(mfrow=c(2,1))

barplot(counts1, log="y")
barplot(counts2, log="y")
