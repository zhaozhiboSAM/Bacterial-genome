#!/bin/sh
echo "Summary IS_detection results, and need 2 Arguments: the final_results_folder directory, the output dir."

if [ $# -eq 2 ]; then
	for ISMut in $1/*; do
		if [ -s "$ISMut" ]; then
#			echo "The file is not empty."
			cat $ISMut |
			if awk 'NR==1{if($7<=130) print $2, $10-1, $10, 0, "-", $1; else if($7>140) print $2, $9, $9+1, 0, "-", $1}' >> $2/Anno_input66; then
				echo "File $file processed successfully."
			else
				echo "Error processing file $file."
			fi	
		else
			echo $ISMut >> $2/strains_can_not_be_detected.txt
		fi
	done
	
else
	echo "Be carefull!!!  Two arguments required."
fi