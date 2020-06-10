#USAGE: command line input should look like $bash create_mac_excisions.sh *chain.tsv*

#use input argument @ for unspecified number of arguments
for arg in "$@"
do
        file=$(basename "$arg" _chain.tsv)
        Rscript /work/aahowel3/flowsortdata/2931489_Howell/bam_IRS2/create_mac_excisionsites.R "${file}_chain.tsv" \
/work/aahowel3/flowsortdata/2931489_Howell/retention_scores/"${file}_IESs_inmic.tsv" 
done


