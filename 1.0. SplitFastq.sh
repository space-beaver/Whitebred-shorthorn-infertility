#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N fastqSplit.sh
#$ -cwd
#$ -l h_rt=4:00:00
#$ -l h_vmem=8G
#$ -P roslin_prendergast_cores
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 10 minutes: -l h_rt
#  memory limit of 64 Gbyte: -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh

#load modules 
module load anaconda
source activate py3.7

#first argument to this submission script is path to folder
#second argument is prefix

fastqsplitter -i ${1}${2}001.fastq.gz -o ${2}1.fastq.gz -o ${2}2.fastq.gz -o ${2}3.fastq.gz -o ${2}4.fastq.gz -o ${2}5.fastq.gz -o ${2}6.fastq.gz
