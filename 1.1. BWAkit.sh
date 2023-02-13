#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N runBWA.sh
#$ -hold_jid fastqSplit.sh
#$ -cwd
#$ -l h_rt=12:00:00
#$ -l h_vmem=8G
#$ -P roslin_prendergast_cores
#$ -t 1:6
#$ -pe sharedmem 4
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 10 minutes: -l h_rt
#  memory limit of 64 Gbyte: -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh

#load modules
module load roslin/samtools/1.10

#run BWA-kit
path/to/bwa.kit/run-bwamem -d -t 4 -o ${1}_$SGE_TASK_ID -HR"@RG\tID:${1}\tSM:${1}" $2 ${1}_R1_$SGE_TASK_ID.fastq.gz ${1}_R2_$SGE_TASK_ID.fastq.gz | sh

#sort with samtools (can be done within BWA-kit)
samtools sort ${1}_$SGE_TASK_ID.aln.bam -o ${1}_$SGE_TASK_ID.sorted.bam
