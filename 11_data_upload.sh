#!/bin/bash
#SBATCH --job-name=data_upload
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --time=2:00:00
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --array=24-60
#SBATCH --out=pop_gen/slurm/data_upload_slurm-%A-%a.out

SPECIES=e_rankini

module load rclone/1.68.1
MKDUP=/scratch/pawsey1132/atims/pop_gen/mkdup/${SPECIES}

i=$(ls $MKDUP/*.bam | awk -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $1}')

rclone copy $i pawsey1228:afgi.spayet/${SPECIES}/ --multi-thread-streams 12

