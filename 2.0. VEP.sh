#!/bin/sh
# Grid Engine options
#$ -N vep
#$ -cwd
#$ -l h_rt=72:00:00
#$ -l h_vmem=64G
#$ -pe sharedmem 12
#$ -P roslin_prendergast_cores
#$ -e e_vep
#$ -o o_vep

#runs vep on a dataset split by chromosome

# Initialise the environment modules
. /etc/profile.d/modules.sh

#load modules
module load igmm/apps/vep/102 
module load roslin/bcftools/1.10
module load igmm/apps/tabix/0.2.6   

#specify directories 
TARGET_DIR=/path/to/input/files
OUTPUT_DIR=/path/to/outputdir

#get a list of .vcfs
sampleid=$(ls -1 ${TARGET_DIR}/*allsamples.vcf.gz)

# Get file to be processed by *this* task
# Extract the Nth file in the list of files, $sampleid, where N == $SGE_TASK_ID

this_file=$(echo "${sampleid}")
echo Processing file: ${this_file} on $HOSTNAME

base=$(echo "$this_file" | cut -f 11 -d '/' | cut -f 1 -d '_')

#execute programs - decompress vcf.gz, run vep, compress vep vcf, index vep vcf.gz, rm vcf. 

for i in  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 27 28 29;
do
bcftools view -O v -o $OUTPUT_DIR/chr${i}_allsamples.vcf $TARGET_DIR/chr${i}_allsamples.vcf.gz;

vep -i $OUTPUT_DIR/chr${i}_allsamples.vcf --cache --dir_cache /home/mmarr3/.vep \
--format vcf --merged --species bos_taurus --force_overwrite --vcf  --sift b --symbol --regulatory --pick \
-o $OUTPUT_DIR/chr${i}_noFilt_vep102.vcf;

bgzip -f $OUTPUT_DIR/chr${i}_noFilt_vep102.vcf > $OUTPUT_DIR/chr${i}_noFilt_vep102.vcf.gz;

tabix -p vcf $OUTPUT_DIR/chr${i}_noFilt_vep102.vcf.gz;

rm $OUTPUT_DIR/chr${i}_allsamples.vcf;

done;
