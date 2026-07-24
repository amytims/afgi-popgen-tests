#!/bin/bash
#SBATCH --account=pawsey1132
#SBATCH --partition=work
#SBATCH --job-name=trimmomatic
#SBATCH --cpus-per-task=6
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=12:00:00
#SBATCH --array=1-240:2
#SBATCH --out=pop_gen/slurm/trimmomatic_slurm-%A_%a.out

### --array should be 1-[num files]:2 to only start with each _R1 file

module load trimmomatic/0.39--hdfd78af_2

SPECIES=e_rankini

# where do the input and output files go?
RAW_READS_DIR=/home/atims/pop_gen/pop_gen/raw_reads/${SPECIES}

TRIM_DIR=/home/atims/pop_gen/pop_gen/trimmomatic_output/${SPECIES}

# filenames file for array job
config=${RAW_READS_DIR}/${SPECIES}_filenames.txt

# create directories for output data
mkdir -p $TRIM_DIR

FILE1=${RAW_READS_DIR}/$(basename $(awk -F"\t" -v id="${SLURM_ARRAY_TASK_ID}" 'NR==id {print $1}' $config))

echo $FILE1

file1=$FILE1
file2=$(echo ${FILE1}| sed -r 's/_R1/_R2/g')

out1="$(basename --suffix=.fastq.gz $file1)"
out1se=$out1
out1=${TRIM_DIR}/${out1}.trim_pe.fastq
out2="$(basename --suffix=.fastq.gz $file2)"
out2se=$out2
out2=${TRIM_DIR}/${out2}.trim_pe.fastq

out1se=${TRIM_DIR}/${out1se}.trim_se.fastq
out2se=${TRIM_DIR}/${out2se}.trim_se.fastq

trimmomatic PE $file1 $file2 $out1 $out1se $out2 $out2se \
	ILLUMINACLIP:NexteraPE-PE-GGGGG.fa:7:25:8:1:true HEADCROP:12 \
	LEADING:6 TRAILING:6 SLIDINGWINDOW:20:28 MINLEN:80 \
	-threads 6

pigz -p 6 $out1
pigz -p 6 $out1se
pigz -p 6 $out2
pigz -p 6 $out2se

