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

Project 2: compare coverage levels of IES regions when mic, mac, and wc samples are mapped to the mic reference - mic sample coverage should be 2x in IES and 2x in non IES regions, mac sample coverage should be 0x in IES and 45x in non IES regions, and wc sample coverage should be 2x in IES and 47x non IES regions

Part 1 compares IES v. Mac-destined region coverage per chromosome per sample
Part 2 compares IES v. Mac-destined region coverage all chromosomes per samples

Part 1
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

in rentention_scores/wc_alignment - coverage of wc sample to mic reference - used this alignment instead of wc to mic aligment in previous project because the previous alignment was of a subset of the wc sample 

in retention_scores/coverage coverage.sh creates 3 folders - mac_coverage, mic_coverage, wc_coverage - and creates a coverage file of mic samples, mac samples, and wc samples using Samtools depth, pulling from previously generated alignments 

in retention_scores/coverage/ mac_coverage, mic_coverage, wc_coverage each folder has an analyze_coverage.sh - which is purely a way to loop each file back through to /coverage/analyze_coverage.R 

/coverage/analyze_coverage.R compares the IES_inMic file and the coverage file to calculate mean coverage for IES regions and mean coverage for Mac-destined regions 

Part 2
in retention_scores/coverage/ mac_coverage, mic_coverage, wc_coverage each folder ALSO has an analyze_coverage_allchromo.sh - which is purely a way to loop each file back through to /coverage/analyze_coverage_allchromo.R 

/coverage/analyze_coverage_allchromo.R compares the IES_inMic file and the coverage file to calculate mean coverage for IES regions and mean coverage for Mac-destined regions - but still seperated per chromosome - what is an IES in the coordinates for 1 chromosome will not be an IES at the same coordinates in another 

/coverage/analyze_coverage_allchromo.R produces the textfile wholechromo.__samplename__.text

/coverage/analyze_coverage_allchromo_means.R takes the wholechromo.__samplename__.text and calculates the mean coverage for IES regions and mean coverage for Mac-destined regions across all chromosomes 
easier to run in Rstudio than command line - need to manually edit the wholechromo.__samplename__.text bc the spacing on the output columns is weird 

ignore anything with _nozeros filter on it, zero coverage positions are needed to get an accurate picture of how well each sample aligns to each reference 

Project 3: IRS (IES Retention Score) for the micronuclear and macronuclear FACS samples 

IRS = IES+ / IES+ and IRS- 
IES+ = reads that align to an IES region but do not across the excision boundary (micronuclear) 
IES- = reads that align to the excision boundary of an IES (macronuclear) 
reads are aligned to a concatenated Macronuclear reference + individual IES references combined reference genome 

in retention_scores2/make_bedfile.sh takes retention_scores/chrX_IESs.tsv (tsv of the joined IES_in_supercontig.csv and contig_to_chromosome.csv made through merge_contigs.R) pulls out last 2 columns of chrX_IESs.tsv (IES_in_chr_start and IES_in_chr_end) and creates a bedfile of just those 4 columns - chr, IES_in_chr_start, IES_in_chr_end, and IES name (updated) 

###updated so that the >names in the IES fasta file are now IESname_chrname_IES-inchr-startposition because there are duplicates IESs from supercontigs assembling to multiple places - how we get ~8000 IESs from previously 7551 listed IESs 

retention_scores2/make_IESfasta.sh takes those bedfile positions and using bedtools getfasta and the micronucealr reference genome and pulls out all the basepairs in that bedfile range

#not needed - used all Mac scaffolds in analysis not used high confidence scaffolds
retention_scores2/make_Macsupercontigref.sh pulls out the 181 high confidence Mac scaffolds from the Mac reference using seqtk and the list of high confidence Mac scaffolds provided by the paper (supp. file 2b) and combines those mac scaffolds and IES references generated by make_IESfasta.sh into mac+IES_reference.fasta

in main folder 2931489_Howell the script IRSscore_alignment_2.sh aligns the Mac and Mic flowsorted samples to the mac+IES_reference.fasta reference (alignment script has to be in main folder bc thats where the trimmed flowsort reads are) 
creates a bam_IRS2 folder

mic/mac chain file located in /storage/datasets/Tetrahymena_thermophila/2017-04-17/bam/liftover 

in bam_IRS2: 
Rscript mic.mac.chain_perchromosome creates a chain file for each chromosome 
chain files 1-5 and mic_inIES files 1-5 (from retention_scores/coverage) are fed into create_mac_excisionsites.sh (which uses create_mac_excisionsites.R) in pairs to create chrX_mac_excisionsites.tsvs for each chromosome

The script calculate_IRS.sh calcualtes the IRS+ and IRS- scores using samtools view startcoor:endcoor on bamfiles produced by IRSscore_alignment_2.sh while looping through the coordinates in the Chr_IESs_mac_excisionsites.tsvs to create the text files chrXIRSscores_mic.txt and chrX IRSscores_mac.txt 
#have to sed -i '1d' .tsv first or it thinks the headers are arguments
#usage 
bash calculate_IRS_mac.sh chrX_IESs_mac_excisionsites.tsv > chrX_IESscores_macsample.txt 
bash calculate_IRS_mic.sh chrX_IESs_mac_excisionsites.tsv > chrX_IESscores_micsample.txt 

calculateIRSscores.R then takes the chrXIRSscores_micsample.txt and chrX IRSscores_macsample.txt files to calculate the mean IRS scores for each sample and create a barplot of the IRS distribution 

calculateIRSscores_all.R consolidates scores over all 5 chromosomes and graphs them in a histogram

##Project 4 - investigating low coverage (table 2) of FACS samples compared to WC samples
in work/aahowel3/flowsortdata/2931489_Howell/human_contamination 

starting number of reads:
Mic FACS trimmed 434228 x 2 R1/R2  = 868,456
Mac FACS trimmed 503983 x 2 R1/R2 = 1,0007,966

(don’t use bamfile to count starting number of reads because there could be more than the start number due to secondary and supplemental alignments or less than because of removed duplicates) 

Samtools view -c -f 4 mic2mic (raw bam, number is the same for the rmdup bam) = 620,861
620,861/868,456 = 71% of reads unaligned 
Samtools view -c -f 4 mac2mac (raw bam, number is the same for the rmdup bam) = 345,639 
345,639/1,0007,966 = 34% of reads unaligned 

##ignore contamination_check.sh and associated bam/sam folders 
contamination_check.sh aligns MIC and MAC samples to human reference 
human_contamination/bam has this output and an MQtextfile folder looking at unaligned reads to the MIC/MAC references and aligned reads to the human ref
however this doesnt tell us much besides there are reads mapping to the human genome 

in human_contamination/blast_check there is a mac_contamination and mic_contamination folder
each mic/mac folder has a blast_check.sh that has the commands that convert unmapped reads in the bam to fastqs, assembles them with spades, and blasts them 
https://biomedicalhub.github.io/genomics/03-part3-unmapped-assembly.html 

#Project 5 - revisiting Fisher's exact tests 
Fisher's metric that suggests poor mac enrichment which conflicts with metrics 2/3 that suggest pretty decent MAC enrichment, could be an arbitrary assignment of preferential reads. This round of fisher's will align reads to a MAC+MIC concat reference rather than aligning samples to each reference individually

in flowsortdata/fishers_rerun the script fishers_rerun.sh is basically a copy of the original flowsort_curation2.sh that generates alignments but only to the combined MIC/MAC reference now 

for this fishers test instead of using an R script to compare preferentially mapped reads the number of reads that map exclusively to one reference or another are what makes up the Fisher's count data. All unmapped reads are removed (anything not aligning to one or the other is likely contamination). In each alignment (MAC FACS to MICMAC ref and MIC FACS to MICMAC ref) the following commands are run: 
#count reads exclusively aligned to mac (scf) 
samtools view FACSsample_toconcatref_mapped.bam | grep -v "XA:" | grep -v "SA:" | awk '$3 ~ /scf/' | wc -l
#count reads exclusively aligned to mic (chr) 
samtools view FACSsample_toconcatref_mapped.bam | grep -v "XA:" | grep -v "SA:" | awk '$3 ~ /scf/' | wc -l
#can also run this command on mito (AF39) 

Basic process has been to remove all reads that have an XA or an SA tag indicating a secondary or chimeric alignment (I am only inferring that this means they are reads from shared regions, I did not check each read to see if the location of the supplemental makes sense for it being shared or if the supplemental is even from a different reference) and then look at reads that align purely to one reference or the other (didn’t check where their mate aligned). I also didn’t distinguish from first in the pair v. second in the pair this time since were only looking at each read once in the alignment not across two alignments as with the previous Fisher’s exact test. 

/wholecellsubset/fishers_rerun_wc.sh does this process for the whole cell subset as well 

##Project 6 - simulating MIC/MAC reads 
In the fishers rerun (and the original fishers now that I think about it) the WC baseline does not make sense. It is around 70/30 MAC/MIC and at first glance this looks correct - 1/3 of MIC lost during mac formation thats around 30% - but thats NOT what is being tested. Both fishers tests are asking "of reads that map preferentially/uniquely to one reference or the other - 30% of those unique reads are going to the MIC and 70% are going to the MAC". The MAC should not have enough unique sequences (just excision sites) to account for that many uniquely mapped reads. Almost everything that is in the MAC is in the MIC and the MIC should have the most unique sequences due to the IESs. 

As a baseline comparision this metric tells us our flow sorting is good, the proportions for MIC/MAC are up in MIC FACS compared to WC and down in MIC/MAC in the MAC FACS but the proporitions of the WC themselves dont make sense. Even with the 45X ploidy of the MAC does that really increase the unique excision sites to 70% of unique reads? 

To investigate this simulated a "whole cell" set of reads mimicking the MAC and MIC polidies using ART illumina. 

in flowsortdata/simulations/ the script wc_simulations.sh uses bamPEFragmentsize to estimate parameters for ART Illumina and then 2 seperate lines of ART Illumina commands sample reads from the MAC reference (45x) and MIC reference (2x). Mac and Mic R1 and Mac and Mic R2 are then concateneted togehter to create whole cell R1 simulation and whole cell R2 simulation - which is aligned to the MIC+MAC reference using the duplicatied script flowsortcuration_2_wc.sh also in flowsortdata/simulations/

###FIXING THINGS
#####rerunning with added rDNA minichromosome reference 
###for thoroughness' sake we should really rerun everything (FACS, simulations, 1x simulations) against a reference with the rDNA minichromosome 
in fishers_rerun with the original mic_mac_combinedreference I concat'd on the X54512.1 rDNA reference from /check_rDNA to make mic_mac_combinedreferce_rDNA.fasta
https://www.ebi.ac.uk/ena/browser/view/X54512 

fishers_rerun_2.sh runs the MIC and MAC FACS against the combined refernece plus rDNA reference into bam2 and sam2 
in fishers_rerun/wholecellsubset fishers_refun_wc_2.sh reruns WC against the combined refernece plus rDNA reference into bam2 and sam2
#make sure to remove unmapped reads first 
samtools view -b -h -F 4 file.bam > mapped.bam


####rerunning simulations with mitochondria removed from MAC reference 
ALSO need to re-do the MAC sampling from a MAC reference that has had the mito reference removed from it 
#to remove mito sequence from mac.genome.fasta
awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' /storage/reference_genomes/tetrahymena_thermophila/mac/mac.genome.fasta | grep -v -Ff remove.txt - | tr "\t" "\n" > mac.genome_nomito.fasta

altered wc_simulations.sh to pull sequences from mac_nomito in the same folder instead of /storage and reran completely rather than copy into new folder
same with simulations 1x

#########Simulated MAC FACS and simulated MIC FACS 
in /simulations ran the mac_simulated 1/2 against the combined MIC/MAC reference using flowsortcuration_2_mic_mac.sh - results in bam_mac
and ran the mic_simulated 1/2 against the combined MIC/MAC reference using flowsortcuration_2_mic_mac.sh - results in bam_mic
#this metric checks how much MIC/MAC contamination we had in each sample 
#the fqs used were at the original 2:45 polidy because they were generated using the ART illumina command in wc_simulations.sh

