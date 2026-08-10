#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=merge_and_filter
#SBATCH --out=pop_gen/slurm/merge_and_filter_slurm-%j.out
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=1800MB
#SBATCH --time=2:00:00


module load bcftools/1.15--haf5b3da_0

SPECIES=e_rankini
VARIANTS=/home/atims/pop_gen/pop_gen/variant_calling/$SPECIES
FILTER=/home/atims/pop_gen/pop_gen/filtered_variants/$SPECIES

mkdir -p $FILTER

# merge all files
bcftools concat $VARIANTS/*.vcf -O z -o $FILT/unfiltered_data.vcf.gz

# filter
# SNPS
# 100% callrate
# biallelic sites only
# min allele frequency >5%

bcftools view \
	-v snps -m2 -M2 --min-ac 1:minor -i 'QUAL>=30' -g ^miss \
	-O z -o $FILT/filtered_data_1.vcf.gz \
	$FILT/unfiltered.data.vcf.gz
