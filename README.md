# FlowSortProject
sequencing data from flow sorted Mic/Mac in Tetrahymena 
all scripts run in hines work/aahowel3/flowsortdata/2931489_Howell in tmux window flowsort in conda env flowsortdata with trimmomatic and fastqc installed
flowsort_curation.sh runs trimmomatic on Mic and Mac pairs of fastq files and then fastqc on trimmmed files, fastqc reported of raw data came with results
flowsort_curation_2.sh runs alignment on Mic fastqs to Mic/Mac refs and Mac fastqs to Mic/Mac, sorts, index bams
in bam folder flowsort_curation_3.sh extracts MQ of each of 4 bam files Mac_toMacref, Mac_toMicref, Mic_toMicref, Mic_toMacref to text files
in bam/MQtxtfiles folder flowsort_MQcounts.R creates a histogram of MQ for each alignment 
