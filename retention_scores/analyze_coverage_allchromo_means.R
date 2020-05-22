#USAGE: run in command line no input needed 

data=read.csv("wholechromo.mac.txt",sep=" ",header=FALSE)
a=c("mean coverage IES for mac:", sum(data$V1)/sum(data$V2))
print(a, quote=FALSE)
a=c("mean coverage mac-dest for mac:", sum(data$V3)/sum(data$V4))
print(a, quote=FALSE)

data=read.csv("wholechromo.mic.txt",sep=" ",header=FALSE)
a=c("mean coverage IES for mic:", sum(data$V1)/sum(data$V2))
print(a, quote=FALSE)
a=c("mean coverage mac-dest for mic:", sum(data$V3)/sum(data$V4))                                                           
print(a, quote=FALSE)

data=read.csv("wholechromo.wc.txt",sep=" ",header=FALSE)
a=c("mean coverage IES for wc:", (sum(data$V1)/sum(data$V2))/19)
print(a, quote=FALSE)
a=c("mean coverage mac-dest for wc:", (sum(data$V3)/sum(data$V4))/19)
print(a, quote=FALSE)

############################
#no zeros is bullshit you need the zero coverage regions to tell where there are IESs in Mac
#data=read.csv("wholechromo.mic.nozeros.txt",sep=" ",header=FALSE)
#a=c("mean coverage IES for mic.nozeros:", (sum(data$V1)/sum(data$V2))/19)
#print(a, quote=FALSE)
#a=c("mean coverage mac-dest for mic.nozeros:", (sum(data$V3)/sum(data$V4))/19)
#print(a, quote=FALSE)

#data=read.csv("wholechromo.mac.nozeros.txt",sep=" ",header=FALSE)
#a=c("mean coverage IES for mac.nozeros:", (sum(data$V1)/sum(data$V2))/19)
#print(a, quote=FALSE)
#a=c("mean coverage mac-dest for mac.nozeros:", (sum(data$V3)/sum(data$V4))/19)
#print(a, quote=FALSE)

