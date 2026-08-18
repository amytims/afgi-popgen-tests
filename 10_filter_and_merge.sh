#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=merge_and_filter
#SBATCH --out=pop_gen/slurm/merge_and_filter_slurm-%j.out
#SBATCH --cpus-per-task=10
#SBATCH --ntasks=1
#SBATCH --mem=18G
#SBATCH --time=24:00:00


module load bcftools/1.15--haf5b3da_0

SPECIES=l_punctulatus
VARIANTS=/home/atims/pop_gen/pop_gen/variant_calling/${SPECIES}
FILT=/home/atims/pop_gen/pop_gen/filtered_variants/${SPECIES}

mkdir -p $FILT

# filter files to contain only snp sites; makes everything else quicker because the full files are huge
#for i in {01..24}; do
#	bcftools view -v snps,indels --threads 10 -o ${VARIANTS}/markdup_${i}_snps_only.vcf \
#	${VARIANTS}/markdup_${i}.vcf
#done



# merge all files and sort
#bcftools concat --threads 10 $VARIANTS/*_snps_only.vcf | bcftools sort --threads 10 --temp-dir $FILT -O z -o $FILT/unfiltered_data_snps_only.vcf.gz

bcftools stats --threads 10 $FILT/unfiltered_data_snps_only.vcf.gz > $FILT/unfiltered_data_snps_only.stats

# filter
# SNPS
# 100% callrate
# biallelic sites only
# min allele frequency >5%

#remove anything within 5bp of an indel
#keep only biallelic SNPs with no missing samples
##      -v snps -m2 -M2 -g ^miss \
bcftools filter --threads 10 -g 5:indel,other $FILT/unfiltered_data_snps_only.vcf.gz |
bcftools view \
       -v snps -m2 -M2 -g ^miss \
	--threads 10 \
	-O z -o $FILT/filtered_data_1.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_1.vcf.gz > $FILT/filtered_data_1.stats

# remove sites with maf < 0.05
bcftools view \
        -q 0.05:minor \
	--threads 10 \
        -O z -o $FILT/filtered_data_2.vcf.gz \
        $FILT/filtered_data_1.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_2.vcf.gz > $FILT/filtered_data_2.stats


# filter any sites with >2.5x the average read depth
bcftools filter \
	-e 'INFO/DP>2.5*AVG(INFO/DP)' \
	--threads 10 \
        -O z -o $FILT/filtered_data_3.vcf.gz \
        $FILT/filtered_data_2.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_3.vcf.gz > $FILT/filtered_data_3.stats

# filter any low-coverage sites - mean read depth < 10
bcftools filter \
	-e 'INFO/DP<600' \
        --threads 10 \
	-O z -o $FILT/filtered_data_4.vcf.gz \
        $FILT/filtered_data_3.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_4.vcf.gz > $FILT/filtered_data_4.stats


# map quality
bcftools filter \
	-e 'MQ<30' \
        --threads 10 \
	-O z -o $FILT/filtered_data_5.vcf.gz \
        $FILT/filtered_data_4.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_5.vcf.gz > $FILT/filtered_data_5.stats


# genotype quality
bcftools filter \
	-e 'QUAL<30' \
        --threads 10 \
	-O z -o $FILT/filtered_data_6.vcf.gz \
        $FILT/filtered_data_5.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_6.vcf.gz > $FILT/filtered_data_6.stats


# strand bias
bcftools filter \
	-e 'SP<3' \
        --threads 10 \
	-O z -o $FILT/filtered_data_7.vcf.gz \
        $FILT/filtered_data_6.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_7.vcf.gz > $FILT/filtered_data_7.stats


bcftools filter \
	-Oz -S . -e 'FMT/GQ<20 | FMT/DP<5' \
	--threads 10 \
	-o $FILT/filtered_data_8.vcf.gz \
	$FILT/filtered_data_7.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_8.vcf.gz > $FILT/filtered_data_8.stats

bcftools filter \
	-Oz -e 'F_MISSING>0.1' \
	--threads 10 \
        -o $FILT/filtered_data_9.vcf.gz \
        $FILT/filtered_data_8.vcf.gz

bcftools stats --threads 10 $FILT/filtered_data_9.vcf.gz > $FILT/filtered_data_9.stats

