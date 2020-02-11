#create a 1million read subset of a whole cell mic+mac sample (ancestor, not GE'd) to compare to our purified mic/mac sample
#R1 = ~500,000 R2 = ~500,000 (look at fastqc report of Mac and Mic TRIMMED to see how many reads you need to sample)
#there is sample _1_ and sample _2_ of SB210E in datasets folder, you only need 1 so you're using _1_ 

#for filename in /storage/datasets/Tetrahymena_thermophila/2017-04-17/fastq/SB210E*_1_*R1*.fastq
#do
#	cat $filename >> SB210E_R1.fastq
#done 

#for filename in /storage/datasets/Tetrahymena_thermophila/2017-04-17/fastq/SB210E*_1_*R2*.fastq
#do
#        cat $filename >> SB210E_R2.fastq
#done

#need to rename these so that R1 and R2 are what are trimmmed off at the end no the "formac/mic" identifier 
seqtk sample -s100 SB210E_R1.fastq 503983 > SB210E_subset_formac_R1.fq 
seqtk sample -s100 SB210E_R2.fastq 503983 > SB210E_subset_formac_R2.fq

seqtk sample -s100 SB210E_R1.fastq 434228 > SB210E_subset_formic_R1.fq
seqtk sample -s100 SB210E_R1.fastq 434228 > SB210E_subset_formic_R2.fq


