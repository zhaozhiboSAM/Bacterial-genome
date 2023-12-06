#!/bin/sh
echo "Four arguments required: (1) Ref_genome.gff3 file, (2) Ref_genome.fasta file, (3) Anno_input file, (4) Anno_output folder"
time ./bin/Bact.IS.Anno.with.ANNOVAR.sh $1 $2 $3 $4