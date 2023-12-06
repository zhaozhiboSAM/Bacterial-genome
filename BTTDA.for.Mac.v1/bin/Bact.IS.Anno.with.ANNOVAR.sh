#!/bin/sh
#echo "Annovate IS_detection results, and 4 arguments required: ref_genome gff3 file, ref_genome fasta file, Anno_input file, Anno_output folder"
#####Use ANNOVAR to annotate the Tn-IS event 
##Built ref genome
if [ $# -eq 4 ]; then
	mkdir ./test_data/Ref_genome/ref_for_Annotation
	
	./bin/gffread $1 -g $2 -T -o ./test_data/Ref_genome/ref_for_Annotation/refAnno.gtf #gff3转gtf \#1_gff3 file of Ref genome
	
	./bin/gtfToGenePred -genePredExt ./test_data/Ref_genome/ref_for_Annotation/refAnno.gtf ./test_data/Ref_genome/ref_for_Annotation/refAnno_refGene.txt #conda install ucsc-gtftogenepred
	
	perl ./bin/retrieve_seq_from_fasta.pl --format refGene --seqfile $2 ./test_data/Ref_genome/ref_for_Annotation/refAnno_refGene.txt --outfile ./test_data/Ref_genome/ref_for_Annotation/refAnno_refGeneMrna.fa  #\$2 fasta file of Ref genome
	
	##annotate_variation
	perl ./bin/annotate_variation.pl -geneanno -dbtype refGene -out TnAnno -buildver refAnno $3 ./test_data/Ref_genome/ref_for_Annotation/
	
	mkdir ./test_data/output/ANNOVAR_result
	
	mv TnAnno.* $4/
	
	#perl ./bin/annotate_variation.pl -geneanno -dbtype refGene -out TnAnno -buildver refAnno ./test_data/output/Anno_input ./test_data/Ref_genome/ref_for_Annotation/
else
	echo "Be carefull!!!  Arguments required."
fi






