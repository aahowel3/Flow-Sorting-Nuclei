#run in /retention_scores/coverage folder, no input needed 

#create a coverage file of each sample (mic,mac,wc) mapped to mic reference 
#no input just run script as bash retentionscores_modified.sh

#align the wc dataset to the mic ref -> coverage should be 47(45+2)/2 ratio to mac-destined sequences vs. IESs
#this was done in wc_alignment folder

#align the mic only sample to the mic ref -> coverage should be 2 ratio across the board 
#align the mac only sample to the mic ref -> coverage should be 45 ratio to mac-destined sequences and 0 at IESs 
#YOU HAVE THESE ALIGNMENTS ALREADY /work/aahowel3/flowsortdata/2931489_Howell/bam/
#pull existing files and use samtools depth + coverage histogram script to generate images 


# -a is to include positions that include 0 coverage
samtools depth -a /work/aahowel3/flowsortdata/2931489_Howell/bam/Mac_S2_L001_tomic_sorted_rmdup.bam > Mac_tomic_coverage.txt 
awk '{print >> ($1 "_Mac_tomic_coverage.txt")}' Mac_tomic_coverage.txt

samtools depth -a /work/aahowel3/flowsortdata/2931489_Howell/bam/Mic_S1_L001_tomic_sorted_rmdup.bam > Mic_tomic_coverage.txt 
awk '{print >> ($1 "_Mic_tomic_coverage.txt")}' Mic_tomic_coverage.txt

samtools depth -a /work/aahowel3/flowsortdata/2931489_Howell/retention_scores/wc_alignment/SB210_tomic_sorted_rmdup.bam > SB210_tomic_coverage.txt 
awk '{print >> ($1 "_SB210_tomic_coverage.txt")}' SB210_tomic_coverage.txt



