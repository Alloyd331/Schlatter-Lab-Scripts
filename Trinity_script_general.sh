#!/bin/bash -l        
#SBATCH --time=7:00:00
#SBATCH --ntasks=9
#SBATCH --mem=150g
#SBATCH --tmp=150g
#SBATCH --mail-type=BEGIN,END,FAIL  
#SBATCH --mail-user=lloyd331@umn.edu 
cd Buckthorn
module load samtools/1.14
module load trinityrnaseq/2.5.1
module load python/3.6.3
Trinity --seqType fq --max_memory 150G --trimmomatic \
--left left_reads.fastq  --right right_reads.fastq --CPU 9 \
--no_version_check --no_normalize_reads --no_bowtie




