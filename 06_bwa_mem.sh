#!/bin/bash
#SBATCH --account=pawsey1228
#SBATCH --partition=work
#SBATCH --job-name=bwa-mem_test
#SBATCH --cpus-per-task=12
#SBATCH --ntasks=1
#SBATCH --mem=21GB
#SBATCH --time=12:00:00
#SBATCH --array=1-1

# get config file with
# ls ${READS_DIR}/*trim_pe.fastq > merged_filenames.txt

SPECIES=e_rankini

MERGED_DIR=/home/atims/pop_gen/pop_gen/merged_reads/${SPECIES}
REFERENCE=/scratch/pawsey1132/atims/pop_gen/reference_genome/e_rankini/e_rankini_OG9_v240206.hic1.3.curated.hap1.chr_level.fa
OUTDIR=/home/atims/pop_gen/pop_gen/alignments/$SPECIES

#config=$MERGED_DIR/${SPECIES}_merged_filenames.txt

mkdir -p $OUTDIR

module load bwa/0.7.17--h7132678_9

echo $SLURM_ARRAY_TASK_ID

FILE1=$(ls $MERGED_DIR/*_merged_R1.trim_pe.fastq.gz | awk -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $1}')

#basename $(awk -F"\t" -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $1}' $config)

#FILE1=${READS_DIR}/$(basename $(awk -F"\t" -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $1}' $config))

echo $FILE1

#file1=$FILE1
FILE2=$(echo ${FILE1}| sed -r 's/_R1/_R2/g')

echo $FILE2

bwa mem -t 12 $REFERENCE $FILE1 $FILE2 > "${OUTDIR}/$(basename --suffix=_R1.trim_pe.fastq.gz $FILE1).aln_pe.BWA.sam"
