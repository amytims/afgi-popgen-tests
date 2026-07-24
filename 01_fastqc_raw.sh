#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=fastqc_e_rankini
#SBATCH --cpus-per-task=48
#SBATCH --ntasks=1
#SBATCH --mem=80G
#SBATCH --time=12:00:00

### NOTE: this does one sample per thread at a time
### e.g., 6 threads = 6 processed in one go
### Up the number of threads when you have more files to process

SPECIES=e_rankini

# raw reads for the species should already be in this directory
INPUT_DIR=/home/atims/pop_gen/pop_gen/raw_reads/${SPECIES}

OUTPUT_DIR=/home/atims/pop_gen/pop_gen/fastqc_raw/${SPECIES}
MULTIQC_DIR=/home/atims/pop_gen/pop_gen/multiqc_raw/${SPECIES}

module load singularity/4.1.0-nohost

mkdir $OUTPUT_DIR -p
mkdir $MULTIQC_DIR -p

singularity exec \
	/software/projects/pawsey1132/atims/.singularity/library/fastqc_0.11.9--hdfd78af_1.sif \
	fastqc ${INPUT_DIR}/*.fastq.gz -o ${OUTPUT_DIR}/ -t 48

singularity exec \
	/software/projects/pawsey1132/atims/.singularity/library/multiqc_1.27.1--pyhdfd78af_0.sif \
	multiqc $OUTPUT_DIR -o $MULTIQC_DIR
