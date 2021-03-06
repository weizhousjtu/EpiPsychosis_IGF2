#!/bin/bash
# get BS non-conversion rate in all samples
# All C's in lambda phage DNA must be converted to Ts, as these should all be
#' unmethylated.
# Therefore non-conversion rate is (C/CT) and conversion rate is 1-(C/CT).

alignDir=/home/shraddhapai/Epigenetics/NARSAD/output_files/SeqCap2/methylation
outFile=${alignDir}/BS.nonconversion.rates.txt

cd $alignDir
cat /dev/null > $outFile
echo -e "Sample\tnum C\tnum CT\t% non-conversion\t%conversion" >> $outFile

declare -a SAMPLE=(33pos 80neg);

for i in {0..1}; do 
	inFile=${alignDir}/${SAMPLE[$i]}.methylation_results.txt.gz
	baseF=`basename $inFile .methylation_results.txt.gz`
	echo $baseF
	zcat $inFile | grep "Lambda" | awk -v file=$baseF '
		BEGIN {c_count=0; ct_count=0;} { 
		c_count+=$7;ct_count+=$8;
		} END{ 
			ncrate=c_count/ct_count;
			crate=1-ncrate;
			print file"\t"c_count"\t"ct_count"\t"ncrate"\t"crate
		} ' >> $outFile
done

