#!/bin/sh
#echo "Three arguments required: Ref_genome_fasta, fastq.gz_DIR \$myDIR/data/ [file_structure: ./data/strain_name/xx_1.fq.gz xx_2.fq.gz], Tn_sequence file"
#echo "The 1st argument is Ref_Genome_fasta: $1"
#echo "The 2ed argument is fastq.gz folder: $2"
#echo "The 3rd argument is the Tn_sequence: $3"
if [ $# -eq 3 ]; then
	{
	./bin/makeblastdb -dbtype nucl -in $1 -out ./test_data/Ref_genome/RefGenome
	mkdir ./test_data/output/final_results1
	for name in $(ls $2)
	do
		{
		./bin/velveth $2/${name}/${name} 99 -fastq.gz $2/${name}/*.fq.gz
		./bin/velvetg $2/${name}/${name} -min_contig_lgth 300 # -max_branch_length 200 -max_divergence 0.33 -max_gap_count 5 
		mkdir $2/${name}/temp
		cat $2/${name}/${name}/contigs.fa | sed "s/NODE/${name}/"  >$2/${name}/temp/${name}.fasta
		mv $2/${name}/${name}/Log $2/${name}/temp/${name}.log
		rm -r $2/${name}/${name}/
		./bin/makeblastdb -dbtype nucl -in $2/${name}/temp/${name}.fasta -out $2/${name}/temp/${name}
		./bin/blastn -db $2/${name}/temp/${name} -query $3 -out $2/${name}/temp/${name}blastn.out -outfmt 6 -evalue 1e-50
		cat $2/${name}/temp/${name}blastn.out | awk '{print $2}' >$2/${name}/temp/${name}withIS_contigID.txt
		./bin/seqkit grep -f $2/${name}/temp/${name}withIS_contigID.txt $2/${name}/temp/${name}.fasta -o $2/${name}/temp/${name}contigWithIS.fa
		
		
		# Read the document
		line=$(cat $2/${name}/temp/${name}blastn.out | head -n 1)
		
		# Extract the values of the 9th and 10th columns
		col9=$(echo "$line" | awk '{print $9}')
		col10=$(echo "$line" | awk '{print $10}')
		
		# Compare the values of the 9th and 10th columns
		if (( $col9 < $col10 )); then
		    # If the 9th column is less than the 10th column, print the specified output
		    if (( $col9 - 1000 <= 0 )); then
		        echo "$line" | awk '{print 1":"$10+1000}' > $2/${name}/temp/${name}withIS_contigID_1kb.txt
		    else
		        echo "$line" | awk '{print $9-1000":"$10+1000}' > $2/${name}/temp/${name}withIS_contigID_1kb.txt
		    fi
		else
		    # If the 9th column is greater than the 10th column, print the specified output
		    if (( $col10 - 1000 >= 0 )); then
		        echo "$line" | awk '{print $10-1000":"$9+1000}' > $2/${name}/temp/${name}withIS_contigID_1kb.txt
		    else
		        echo "$line" | awk '{print 1":"$9+1000}' > $2/${name}/temp/${name}withIS_contigID_1kb.txt
		    fi
		fi
		range2=$(cat $2/${name}/temp/${name}withIS_contigID_1kb.txt)
		cat $2/${name}/temp/${name}contigWithIS.fa | ./bin/seqkit subseq -r $range2 >$2/${name}/temp/${name}withIS_contigID_1kb.fa
		

		./bin/blastn -db ./test_data/Ref_genome/RefGenome -query $2/${name}/temp/${name}withIS_contigID_1kb.fa -out $2/${name}/temp/${name}_ref_blastn.txt -outfmt 6 -evalue 1e-100
		#./bin/blastn -db ./test_data//Ref_genome/RefGenome -query $2/${name}/temp/${name}contigWithIS.fa -out $2/${name}/temp/${name}_ref_blastn.txt -outfmt 6 -evalue 1e-100
		
		cp -f $2/${name}/temp/${name}_ref_blastn.txt ./test_data/output/final_results1/${name}_ref_blastn.txt
		}
	done

	wait
	#merge final_txt
	cat ./test_data/output/final_results1/*.txt >./test_data/output/merge_final_location.txt
	#make input file for ANNOVAR
	for ISMut in ./test_data/output/final_results1/*
	do
		{
		if [ -s "$ISMut" ]; then
			echo "The file is not empty."
			cat $ISMut |
			if awk 'NR==1{if($7<=130) print $2, $10-1, $10, 0, "-", $1; else if($7>140) print $2, $9, $9+1, 0, "-", $1}' >> ./test_data/output/Anno_input; then
				echo "File $ISMut processed successfully."
			else
				echo "Error processing file $ISMut."
			fi	
		else
			echo $ISMut >> ./test_data/output/strains_can_not_be_detected.txt
		fi
	    }
	done
	}
else
	echo "Be careful!!! Arguments required."
fi





