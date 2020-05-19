# FlowSortProject
sequencing data from flow sorted Mic/Mac in Tetrahymena 

all scripts run in hines work/aahowel3/flowsortdata/2931489_Howell in tmux window flowsort in conda env flowsortdata with trimmomatic and fastqc installed

Project 1: comparing the number of preferenetially mapped reads from each sample (mic,mac,wc) to the mic and mac references

flowsort_curation.sh runs trimmomatic on Mic and Mac pairs of fastq files and then fastqc on trimmmed files, fastqc reported of raw data came with results

flowsort_curation_2.sh runs alignment on Mic fastqs to Mic/Mac refs and Mac fastqs to Mic/Mac, sorts, index bams (sam folder is intermediate) 

in bam folder flowsort_curation_3.sh extracts MQ of each of 4 bam files Mac_toMacref, Mac_toMicref, Mic_toMicref, Mic_toMacref to text files, sorted by first in pair or second in pair, secondary alignments removed

in bam/MQtxtfiles2 folder Rscript compares reads from each sample if more aligned preferentailly to the same reference as the sample or the opposite reference using a Fisher's exact test

in work/aahowel3/flowsortdata/2931489_Howell/wholecell_subset subset.sh creates a subset of reads from NOT GE ancestors with the same number of reads as the original Mic and Mac flowsorted sequencing samples

flowsort_curation_wc.sh runs trimmomatic on whole cell subset fastq files and then fastqc on trimmmed files, fastqc reported of raw data came with results

flowsort_curation_2_wc.sh runs alignment on wc fastqs to Mic/Mac refs, sorts, index bams (sam folder is intermediate) 

in bam folder flowsort_curation_3_wc.sh extracts MQ of 2 bam files wc_toMacref, wc_toMicref to text files, sorted by first in pair or second in pair, secondary alignments removed

in bam/MQtxtfiles_wc folder Rscript compares number of reads from mac flowsort sample and wc sample preferentailly mapped to mac/mic ref and number of reads from mic flowsort sample and wc sample preferentailly mapped to mac/mic ref using a Fisher's exact test - creates 2 2x2 tables where the line WC to Mic and WC to Mac overlaps between the 2 tables - can use either line - this gets you your Mac 60/40, Mic 23/77, and WC 70/30 table 



