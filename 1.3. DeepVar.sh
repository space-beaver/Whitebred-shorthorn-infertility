#!/bin/bash
#$ -cwd
#$ -N runDV.sh
#$ -l h_vmem=16G
#$ -l h_rt=36:00:00
#$ -P roslin_prendergast_cores
#$ -pe sharedmem 12

# initialise module env 
. /etc/profile.d/modules.sh

#load modules 
module load path/to/singularity/3.5.3

# inputs
reference=$2
bam=$1.final.bam
sampleid=$1
outdir=deepvar

# Create output directories
if [ ! -e deepvar ]; then mkdir deepvar; fi
if [ ! -e deepvar/$sampleid ]; then mkdir deepvar/$sampleid; fi

# Set singularity caches
if [ ! -e ${PWD}/.singularity ]; then mkdir ${PWD}/.singularity; fi
export SINGULARITY_TMPDIR=$PWD/.singularity
export SINGULARITY_CACHEDIR=$PWD/.singularity

# Download the image
if [ ! -e deepvariant.sif ]; then singularity build deepvariant.sif docker://google/deepvariant:latest; fi

# Run Deepvariant
singularity exec -p -B ${PWD} -B ${TMP} deepvariant.sif /opt/deepvariant/bin/run_deepvariant \
            --model_type=WGS \
            --ref=${reference} \
            --reads=${bam} \
            --output_vcf=deepvar/${sampleid}/${sampleid}.vcf.gz \
            --output_gvcf=deepvar/${sampleid}/${sampleid}.g.vcf.gz \
            --num_shards=${NSLOTS}
