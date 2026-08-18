#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=post-processing_test
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1
#SBATCH --mem=48G
#SBATCH --time=6:00:00
#SBATCH --array=1-64
#SBATCH --out=pop_gen/slurm/post-processing_slurm%A-%a.out

module load samtools/1.15--h3843a85_0
module load gatk4/4.2.5.0--hdfd78af_0

SPECIES=l_punctulatus
#ALIGNMENTS=/home/atims/pop_gen/pop_gen/alignments
SORTED_ALN=/home/atims/pop_gen/pop_gen/sorted_aln/$SPECIES
MKDUP=/home/atims/pop_gen/pop_gen/mkdup/$SPECIES

mkdir -p $SORTED_ALN
mkdir -p $MKDUP

#for i in $ALIGNMENTS/*.sam
#do

i=$(ls $SORTED_ALN/*.sorted.bam | awk -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $1}')

echo $i
SAMPLE=$(basename --suffix=.sorted.bam $i)
echo $SAMPLE 

# convert to bam file and sort
#samtools view -bS --threads 7 $ALIGNMENTS/$i | samtools sort --threads 7 -T ${SORTED_ALN} -o ${SORTED_ALN}/${SAMPLE}.sorted.bam

# index bam file
samtools index -@7 ${SORTED_ALN}/${SAMPLE}.sorted.bam

echo "indexing complete"

#run stats on bam file
samtools flagstat --threads 7 ${SORTED_ALN}/${SAMPLE}.sorted.bam > ${SORTED_ALN}/${SAMPLE}.flagstat

echo "flagstat complete"

# mark duplicates
gatk MarkDuplicates -I ${SORTED_ALN}/${SAMPLE}.sorted.bam -O ${MKDUP}/${SAMPLE}.marked_duplicates.bam -M ${MKDUP}/${SAMPLE}.marked_dup_metrics.txt --TMP_DIR pop_gen/mkdup/

echo "mkdup complete"

#gatk MarkDuplicates -I "${SORTED_ALN}/${SAMPLE}.sorted.bam" \
#	-O "${MKDUP}/${SAMPLE}_marked_duplicates.bam"\
#	-M "${MKDUP}/${SAMPLE}_marked_dup_metrics.txt"

# index the marked duplicates bam file
samtools index -@7 ${MKDUP}/${SAMPLE}.marked_duplicates.bam

echo "mkdup indexed"
