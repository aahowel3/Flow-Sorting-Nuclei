library(dplyr)
args = commandArgs(trailingOnly=TRUE)

#read in mac.mic.chain file per chromosome and IESs_in_mic file per chromosome as paired files 

chain=read.csv(args[1],sep="\t")
IESmic=read.csv(args[2],sep="\t")

#11111
assign_mac_scaffoldstart=function(p,q) {
  chain = chain[(chain$queryend <= (p+10) & chain$queryshift >= (q-10)),] 
  return(as.character(chain$refname))} 

IESmic$mac_scaffoldstart=mapply(assign_mac_scaffoldstart,IESmic$IES_in_chromosome_start, IESmic$IES_in_chromosome_end)

#22222
assign_mac_scaffoldend=function(p,q) {
  chain = chain[(chain$queryend <= (p+10) & chain$queryshift >= (q-10)),] 
  return(as.character(chain$refnameshift))} 

IESmic$mac_scaffoldend=mapply(assign_mac_scaffoldend,IESmic$IES_in_chromosome_start, IESmic$IES_in_chromosome_end)

#33333
assign_mac_excisionstart=function(p,q) {
  chain = chain[(chain$queryend <= (p+10) & chain$queryshift >= (q-10)),] 
  return(as.character(chain$refend))} 

IESmic$mac_excisionstart=mapply(assign_mac_excisionstart,IESmic$IES_in_chromosome_start, IESmic$IES_in_chromosome_end)

#44444
assign_mac_excisionend=function(p,q) {
  chain = chain[(chain$queryend <= (p+10) & chain$queryshift >= (q-10)),] 
  return(as.character(chain$refshift))} 

IESmic$mac_excisionend=mapply(assign_mac_excisionend,IESmic$IES_in_chromosome_start, IESmic$IES_in_chromosome_end)

IESmic$IESpresent=ifelse(IESmic$mac_scaffoldstart == "character(0)", "absent", "present")
IESmic=IESmic[!(IESmic$mac_scaffoldstart == "character(0)"),]
IESmic$mac_scaff_gap=as.integer(IESmic$mac_excisionstart) - as.integer(IESmic$mac_excisionend)
IESmic$mac_scaff_check=ifelse(IESmic$mac_scaff_gap < 50 & -50 < IESmic$mac_scaff_gap, "viable", "notviable")
IESmic=IESmic[!(IESmic$mac_scaff_check == "notviable"),]

#double check there are no IESs between 2 scaffolds, will matter when checking for the excision site in bash script 
#ifelse(IESmic$mac_scaffoldstart == IESmic$mac_scaffoldend, "TRUE", "FALSE")

#unlist mappaly columns so fit them into the write.csv function format 
IESmic$IES_fullID=paste(IESmic$IES_ID,IESmic$chromosome_name,IESmic$IES_in_chromosome_start, sep="_")
IESmic$mac_scaffoldstart=unlist(IESmic$mac_scaffoldstart)
IESmic$mac_scaffoldend=unlist(IESmic$mac_scaffoldend)
IESmic$mac_excisionstart=as.numeric(unlist(IESmic$mac_excisionstart))
IESmic$mac_excisionend=as.numeric(unlist(IESmic$mac_excisionend))

#need to flip excison sites that are reversed or samtools will not take them 
IESmic$excision_start_c = pmin(IESmic$mac_excisionend,IESmic$mac_excisionstart)
IESmic$excision_end_c = pmax(IESmic$mac_excisionend,IESmic$mac_excisionstart)

newdf=select(IESmic, IES_fullID, mac_scaffoldstart, excision_start_c, excision_end_c)

newfilename=sub("_chain.tsv","_mac_excisionsites.tsv",args[1])

write.table(newdf,file=newfilename,row.names = FALSE,sep="\t", quote=FALSE)

