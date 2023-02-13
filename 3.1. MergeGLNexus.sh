#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N runMergeGLNex.sh
#$ -cwd
#$ -l h_rt=48:00:00
#$ -l h_vmem=128G
#$ -P roslin_prendergast_cores
#$ -e e_GLnex
#$ -o o_GLNex 

# Initialise the environment modules
. /etc/profile.d/modules.sh

'load modules 
module load igmm/apps/tabix/0.2.6
module load roslin/bcftools/1.9
module load singularity

#only needs to be run the first time
#singularity pull glnexus.sif docker://ghcr.io/dnanexus-rnd/glnexus:v1.4.1

#run GLNex merge - creates bcf per chrom inc all samples. 

for {i} in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
  do 
singularity run --bind ${PWD}:/io /exports/cmvm/eddie/eb/groups/prendergast_roslin/mmarr/WHD/glnexus.sif glnexus_cli \
--config DeepVariantWGS Bi-83-A_{i}.g.vcf.gz Bi-83-H_{i}.g.vcf.gz BOAEC-D1_{i}.g.vcf.gz BOAEC-D2_{i}.g.vcf.gz \
WHD01-LS-Co_{i}.g.vcf.gz WHD03-BS-Co_{i}.g.vcf.gz WHD04-Vo-Ca_{i}.g.vcf.gz WHD05-BG-Ca_{i}.g.vcf.gz \
WHD06-SP-Ca_{i}.g.vcf.gz WHD07-Pw-Ca_{i}.g.vcf.gz WHD08-SC-Co_{i}.g.vcf.gz WHD10-WM-Ca_{i}.g.vcf.gz \
WHD11-HC-Ca_{i}.g.vcf.gz > cattle_all_merged_{i}.bcf
  done
  
#index 
bcftools index -f cattle_all_merged_{i}.bcf
