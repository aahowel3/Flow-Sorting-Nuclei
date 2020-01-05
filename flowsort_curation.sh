#Mic/Mac flowsort data on hines /work/aahowel3/flowsortdata
#USAGE: command line input should look like $bash flowsort_curation.sh *R1_001.fastq.gz
#trimmomatic adapter file in same directory TruSeq-3-PE-2.fa


#use input argument @ for unspecified number of arguments
for arg in "$@"
do
#strips out Mic or Mac part of filename, can then use the basename to specify the R1 and R2 files with the same basename in the trimmomatic command
        file=$(basename "$arg" _R1_001.fastq.gz)
#runs trimmomatic on each read pair - outupts are 2 trimed files and 2 untrimmed files where the discarded reads go
        trimmomatic PE "${file}_R1_001.fastq.gz" "${file}_R2_001.fastq.gz" "${file}_R1_001.trim.fastq.gz" "${file}_R1_001.untrim.fastq.gz" "${file}_R2_001.trim.fastq.gz" "${file}_R2_001.untrim.fastq.gz" SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10
	fastqc "${file}_R1_001.trim.fastq.gz" "${file}_R2_001.trim.fastq.gz"
done

 

