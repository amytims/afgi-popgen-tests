#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=bwa_index_test
#SBATCH --out=pop_gen/slurm/bwa_index_slurm-%j.out
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=1800MB
#SBATCH --time=2:00:00

#module load bwa-mem2/2.2.1--hd03093a_2
module load bwa/0.7.17--h7132678_9 rclone/1.68.1

SPECIES=e_rankini

RCLONE_FILE_PATH='pawsey1228:afgi.atims/reference_genomes/e_rankini/e_rankini_OG9_v240206.hic1.3.curated.hap1.chr_level.fa.gz'

#REF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/041/903/045/GCA_041903045.1_ASM4190304v1/GCA_041903045.1_ASM4190304v1_genomic.fna.gz
REF_DIR=/home/atims/pop_gen/pop_gen/reference_genome/$SPECIES

mkdir $REF_DIR -p

rclone copy ${RCLONE_FILE_PATH} ${REF_DIR}
#wget $REF_URL -O ${REF_DIR}/${REFERENCE}

gunzip ${REF_DIR}/$(basename ${RCLONE_FILE_PATH})

bwa index ${REF_DIR}/$(basename --suffix=.gz ${RCLONE_FILE_PATH})
