#!/bin/bash
#SBATCH -N 1                      
#SBATCH -n 16                      
################### 

module load python3 
module load igblast

awk 'NR%4==1' $1 | grep -o "[ATCGN]*"| awk 'NR%4==3' > BCread.txt
awk 'NR%4==2' $1 > TCRread.txt
awk 'NR%4==0' $1 > TCRread_Q.txt
sed 's~[ATGCN]~@~g' BCread.txt > BCread_Q.txt
awk 'NR%4==1' $1 | grep -o "^.* 1:N:0"  > header.txt
awk 'NR%4==3' $1 > header_Q.txt

paste -d '' BCread.txt TCRread.txt > Read1.txt
paste -d '' BCread_Q.txt TCRread_Q.txt > Read1_Q.txt
paste -d '\n' header.txt Read1.txt header_Q.txt Read1_Q.txt > sample.fastq


MaskPrimers.py extract -s sample.fastq --start 0 --len 20 --pf BARCODE --mode cut --failed --log MP.log
FilterSeq.py quality -q 25 -s sample_primers-pass.fastq --failed --log FS.log
BuildConsensus.py -s sample_primers-pass_quality-pass.fastq  --bf BARCODE -n 3 --maxerror 0.50 --maxgap 0.5 --outname consensus --log BC.log --failed

paste - - - - < consensus_consensus-pass.fastq | cut -f 1,2 | sed 's/^@/>/' | tr "\t" "\n" > file.fa
AssignGenes.py igblast -s file.fa --organism mouse --loci tr --format blast -b ~/share/igblast
MakeDb.py igblast -i file_igblast.fmt7 -s file.fa     -r ~/share/germlines/imgt/mouse/vdj/ --log MDB.log --extended --failed --partial
ParseLog.py -l BC.log -o stats.log -f -f BARCODE SEQCOUNT CONSCOUNT ERROR


python3 posthoc_umicorrection.py