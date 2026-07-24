#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=merge_lanes_e_rankini
#SBATCH --out=pop_gen/slurm/merge_lanes_e_rankini_slurm-%j.out
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --mem=7G
#SBATCH --time=12:00:00


SPECIES=e_rankini
READS_DIR=/home/atims/pop_gen/pop_gen/trimmomatic_output/${SPECIES}
MERGED_DIR=/home/atims/pop_gen/pop_gen/merged_reads/${SPECIES}

mkdir -p $MERGED_DIR


for file in $(ls ${READS_DIR}/*.trim_pe.fastq.gz | xargs -n 1 basename --suffix=.trim_pe.fastq.gz | sed -E 's/_L..._R.$//g' | uniq)
do
	echo $file

	cat $READS_DIR/${file}_L???_R1.trim_pe.fastq.gz > $MERGED_DIR/${file}_merged_R1.trim_pe.fastq.gz &
	cat $READS_DIR/${file}_L???_R2.trim_pe.fastq.gz > $MERGED_DIR/${file}_merged_R2.trim_pe.fastq.gz &

	cat $READS_DIR/${file}_L???_R1.trim_se.fastq.gz > $MERGED_DIR/${file}_merged_R1.trim_se.fastq.gz &
	cat $READS_DIR/${file}_L???_R2.trim_se.fastq.gz > $MERGED_DIR/${file}_merged_R2.trim_se.fastq.gz &

wait

echo "finished running file: $file"
done
