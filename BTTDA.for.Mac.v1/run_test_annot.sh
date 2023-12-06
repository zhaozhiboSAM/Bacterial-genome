#!/bin/sh
echo "This is a test"
echo "Four arguments required: (1) Ref_genome.gff3 file, (2) Ref_genome.fasta file, (3) Anno_input file, (4) Anno_output folder"
time ./bin/Bact.IS.Anno.with.ANNOVAR.sh ./test_data/M228gp.gff ./test_data/M228gp.fasta ./test_data/output/Anno_input ./test_data/output/ANNOVAR_result/