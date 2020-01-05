#USAGE: command line input should look like $bash flowsort_curation_2.sh *_sorted.bam

mkdir -p MQ_txtfiles

for filename in $@
do
#strips extension from input file 
	file=$(basename "$filename" _sorted.bam)
	samtools view "${file}"_sorted.bam | cut -f5 > MQ_txtfiles/"${file}"_MQ.txt
done 
