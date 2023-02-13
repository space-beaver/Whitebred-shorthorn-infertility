#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N runMerge.sh
#$ -cwd
#$ -l h_rt=8:00:00
#$ -l h_vmem=16G
#$ -P roslin_prendergast_cores
#$ -e e_merge
#$ -o o_merge

# Initialise the environment modules
. /etc/profile.d/modules.sh

#load modules. #note get error with newer bedtools https://github.com/arq5x/bedtools2/issues/911
module load roslin/samtools/1.10
module load igmm/apps/BEDTools/2.27.1

#merge bams and get stats
samtools merge -cp $1.final.bam ${1}*.sorted.bam
samtools index $1.final.bam
samtools flagstat $1.final.bam > $1.flagstat.txt
bedtools genomecov -ibam $1.final.bam > $1.cov.txt
