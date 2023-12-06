#!/bin/sh
echo "This is a test"
echo "Four arguments required: (1) Ref_genome.fasta, (2) fastq.gz_DIR /data/ [file_structure: ./data/strain_name/xx_1.fq.gz xx_2.fq.gz], (3) Tn_sequence file, (4) Ref_genome.gff3 file."
echo "The results listed in ./test_data/output/ANNOVAR_result/"

time ./bin/Bact.IS.Location.Detect.3args.order.sh ./test_data/M228gp.fasta ./test_data/datafile ./test_data/Tn_sequence.fa

wait

./bin/Bact.IS.Anno.with.ANNOVAR.sh ./test_data/M228gp.gff ./test_data/M228gp.fasta ./test_data/output/Anno_input ./test_data/output/ANNOVAR_result/