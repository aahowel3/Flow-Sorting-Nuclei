#alignment continuation from flowsortcuration.sh 
#USAGE: command line input should look like $bash flowsort_curation_2_wc.sh *R1.trim.fq

#creates directories to store intermediate files 
mkdir -p sam
mkdir -p bam

for filename in $@
do
#strips extension from input file 
	file=$(basename "$filename" _R1.trim.fq)
#aligns paired end fastqs to reference 
	bwa mem /storage/reference_genomes/tetrahymena_thermophila/mac/mac.genome.fasta "${file}"_R1.trim.fq "${file}"_R2.trim.fq > sam/"${file}"_tomac.sam
#converts sam to bam, sorts and indexes bam
	samtools view -S -b sam/"${file}"_tomac.sam > bam/"${file}"_tomac.bam
	samtools sort -o bam/"${file}"_tomac_sorted.bam bam/"${file}"_tomac.bam
	samtools rmdup bam/"${file}"_tomac_sorted.bam bam/"${file}"_tomac_sorted_rmdup.bam
	samtools index bam/"${file}"_tomac_sorted_rmdup.bam 

#now do the same process for both but to the mic reference genome 
	bwa mem /storage/reference_genomes/tetrahymena_thermophila/mic/mic.genome.fasta "${file}"_R1.trim.fq "${file}"_R2.trim.fq > sam/"${file}"_tomic.sam
#converts sam to bam, sorts and indexes bam
	samtools view -S -b sam/"${file}"_tomic.sam > bam/"${file}"_tomic.bam
	samtools sort -o bam/"${file}"_tomic_sorted.bam bam/"${file}"_tomic.bam
	samtools rmdup bam/"${file}"_tomic_sorted.bam bam/"${file}"_tomic_sorted_rmdup.bam
	samtools index bam/"${file}"_tomic_sorted_rmdup.bam  
done 
