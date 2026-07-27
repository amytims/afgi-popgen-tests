#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=multiqc_trim_e_rankini
#SBATCH --out=pop_gen/slurm/multiqc_trim_e_rankini_slurm-%j.out
#SBATCH --cpus-per-task=48
#SBATCH --ntasks=1
#SBATCH --mem=80G
#SBATCH --time=12:00:00

### NOTE: this does one sample per thread at a time
### e.g., 6 threads = 6 processed in one go
### Up the number of threads when you have more files to process

SPECIES=e_rankini

# trimmed input files
TRIM_DIR=/home/atims/pop_gen/pop_gen/trimmomatic_output/${SPECIES}

# output directories
FASTQC_TRIM_DIR=/home/atims/pop_gen/pop_gen/fastqc_trim/${SPECIES}
MULTIQC_TRIM_DIR=/home/atims/pop_gen/pop_gen/multiqc_trim/${SPECIES}

mkdir $FASTQC_TRIM_DIR -p
mkdir $MULTIQC_TRIM_DIR -p

module load singularity/4.1.0-nohost

singularity exec \
	/software/projects/pawsey1132/atims/.singularity/library/fastqc_0.11.9--hdfd78af_1.sif \
	fastqc $TRIM_DIR/*.trim_pe.fastq.gz -o ${FASTQC_TRIM_DIR}/ -t 48

singularity exec \
	/software/projects/pawsey1132/atims/.singularity/library/multiqc_1.27.1--pyhdfd78af_0.sif \
	multiqc $FASTQC_TRIM_DIR -o $MULTIQC_TRIM_DIR
