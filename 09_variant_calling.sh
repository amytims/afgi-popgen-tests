#!/bin/bash
#SBATCH --job-name=bcftools_mpileup
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=72g
#SBATCH --time=24:00:00
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --array=1-24
#SBATCH --out=pop_gen/slurm/bcftools_mpileup_slurm%A-%a.out

SPECIES=l_punctulatus

# Specify the path to the config file
config=${SPECIES}_regions.txt

#echo $config
#for SLURM_ARRAY_TASK_ID in {1..10}; do

echo $SLURM_ARRAY_TASK_ID

REGIONS=$(awk -F"\t" -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $0}' $config)

echo $REGIONS

# path to reference
REF_DIR=/home/atims/pop_gen/pop_gen/reference_genome/$SPECIES
#REFERENCE=e_rankini_OG9_v240206.hic1.3.curated.hap1.chr_level.fa
REFERENCE=l_punctulatus_OG2146_v260414.hic1.3.curated.hap1.chr_level.fa
MKDUP=/home/atims/pop_gen/pop_gen/mkdup/$SPECIES
VARIANTS=/home/atims/pop_gen/pop_gen/variant_calling/${SPECIES}

mkdir $VARIANTS -p

# load required modules
module load samtools/1.15--h3843a85_0
module load bcftools/1.15--haf5b3da_0

# run variant calling on all mkdup bam files in path
bcftools mpileup -Ou -Q 30 -q 30 -a AD,DP,SP -f ${REF_DIR}/${REFERENCE} -r "${REGIONS}" ${MKDUP}/*.marked_duplicates.bam | \
	bcftools call --threads 12 -m -f GQ,GP > ${VARIANTS}/markdup_$(printf "%02d" ${SLURM_ARRAY_TASK_ID}).vcf

## option meanings
#-Ou output type uncompressed bcf - leave uncompressed when piping to other commands
#-f fasta-ref - faidx-index reference file
#-r Comma-separated list of regions/-R regions file - three column tab-delimited format NAME|BEG|END
#-v - output variant sites only
#-m - multiallelic calling model
