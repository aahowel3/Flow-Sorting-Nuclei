#MODIFIED  FOR WHOLE CELL DATA SUBSETS
#Mic/Mac flowsort data on hines /work/aahowel3/flowsortdata/whole_cell
#USAGE: command line input should look like $bash flowsort_curation_wc.sh *R1.fq
#trimmomatic adapter file in same directory TruSeq-3-PE-2.fa


#use input argument @ for unspecified number of arguments
for arg in "$@"
do
#strips out Mic or Mac part of filename, can then use the basename to specify the R1 and R2 files with the same basename in the trimmomatic command
        file=$(basename "$arg" _R1.fq)
#runs trimmomatic on each read pair - outupts are 2 trimed files and 2 untrimmed files where the discarded reads go
        trimmomatic PE "${file}_R1.fq" "${file}_R2.fq" "${file}_R1.trim.fq" "${file}_R1.untrim.fq" "${file}_R2.trim.fq" "${file}_R2.untrim.fq" SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10
	fastqc "${file}_R1.trim.fq" "${file}_R2.trim.fq"
done

 

