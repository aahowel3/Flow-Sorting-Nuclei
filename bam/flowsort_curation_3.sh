#USAGE: command line input should look like $bash flowsort_curation_3.sh *_sorted.bam
#0x0040 and 0x0080 flags seperate 1st in the pair and second in the pair reads 
#not fair to compare Mac2mac 1st in pair to Mac2mic second in pair
#3840 flags remove everything thats not primary alignment
#hard to compare set that has multiple secondary alignments to one that has a single primary alignment

mkdir -p MQ_txtfiles2

for filename in $@
do
#strips extension from input file 
	file=$(basename "$filename" _sorted.bam)
#	samtools view "${file}"_sorted_rmdup.bam | cut -f1,2,5 > MQ_txtfiles/"${file}"_MQ.txt
#	samtools view -f 0x0040 "${file}"_sorted_rmdup.bam | cut -f1,2,5 > MQ_txtfiles/"${file}"_MQ_first.txt 
#	samtools view -f 0x0080 "${file}"_sorted_rmdup.bam | cut -f1,2,5 > MQ_txtfiles/"${file}"_MQ_second.txt 
	samtools view -f 0x0040 -F 3840 "${file}"_sorted_rmdup.bam | cut -f1,2,5 > MQ_txtfiles2/"${file}"_MQ_first_pri.txt
      	samtools view -f 0x0080 -F 3840 "${file}"_sorted_rmdup.bam | cut -f1,2,5 > MQ_txtfiles2/"${file}"_MQ_second_pri.txt



done 
