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

Project 2: 

in retention_scores folder 2 critical files are IES_coordinates.csv - locations of IESs in supercontigs and contig_to_chromosome.csv - locations of supercontigs in chromosomes

IES_coordinates.csv list came from paper https://doi.org/10.7554/eLife.19090.001 supplementary file 3A
contig_to_chromosome.csv from same paper supplemtary file 1C

couple steps of messing with the raw IES_coordinates file to get it into an appropriate format
        #manually removed colorful header and notes saved as csv
        #scp'd to hines and converted to tsv with sed -E 's/("([^"]*)")?,/\2\t/g' IES_coordinates.csv > IES_coordinates.tsv
        #created bedfile with columns I needed with cat IES_coordinates.tsv | awk '{print $4,$2,$3}' > IES_coordinates.bed
        #whoops cutting columns made it space deliminated not tab fix that with  sed 's/ /\t/g' IES_coordinates.bed > IES_coordinates.2.bed
        #now remove header of bedfile with sed -i 1d IES_coordinates.2.bed no output argument needed

manually created contig_to_chromosome file, was embedded in a word doc 

R script merge_contigs.R to convert IES coordinates in supercontigs to IES coordinates in mic chromosomes
        #merge_contigs also splits the IESs_inmic_chromosomes into 5 files, by chromosome
        #what is an IES in 1 chromosome location may not be in another
final files are 1-5 chr#_IESs_inmic.tsv


