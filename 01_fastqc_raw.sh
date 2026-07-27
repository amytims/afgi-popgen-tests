#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=fastqc_e_rankini
#SBATCH --out=pop_gen/slurm/raw_fastq_slurm-%j.out
#SBATCH --cpus-per-task=48
#SBATCH --ntasks=1
#SBATCH --mem=80G
#SBATCH --time=12:00:00

### NOTE: this does one sample per thread at a time
### e.g., 6 threads = 6 processed in one go
### Up the number of threads when you have more files to process

SPECIES=e_rankini

# raw reads for the species should already be in this directory
RAW_READS_DIR=/home/atims/pop_gen/pop_gen/raw_reads/${SPECIES}

FASTQC_RAW_DIR=/home/atims/pop_gen/pop_gen/fastqc_raw/${SPECIES}
MULTIQC_RAW_DIR=/home/atims/pop_gen/pop_gen/multiqc_raw/${SPECIES}

module load singularity/4.1.0-nohost

mkdir $FASTQC_RAW_DIR -p
mkdir $MULTIQC_RAW_DIR -p

# run fastQC on each file
singularity exec \
	/software/projects/pawsey1132/atims/.singularity/library/fastqc_0.11.9--hdfd78af_1.sif \
	fastqc ${RAW_READS_DIR}/*.fastq.gz -o ${FASTQC_RAW_DIR}/ -t 48

# aggregate reports with multiQC
singularity exec \
	/software/projects/pawsey1132/atims/.singularity/library/multiqc_1.27.1--pyhdfd78af_0.sif \
	multiqc $FASTQC_RAW_DIR -o $MULTIQC_RAW_DIR

# create file of read names
# for running trimmomatic as an array job instead of for-looping
ls $RAW_READS_DIR/*R1.fastq.gz > ${RAW_READS_DIR}/${SPECIES}_filenames.txt
