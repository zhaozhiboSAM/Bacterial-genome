#!/bin/sh
echo "Three arguments required: (1) Ref_genome_fasta, (2) fastq.gz_DIR $myDIR/data/ [file_structure: ./data/strain_name/xx_1.fq.gz xx_2.fq.gz], (3)Tn_sequence file"
##echo "./Bact.IS.Location.Detect.3args.sh ./test_data/M228gp.fasta /test_data/datafile/ test_data/Tn_sequence.fa"
time ./bin/Bact.IS.Location.Detect.3args.order.sh $1 $2 $3