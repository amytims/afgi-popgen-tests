#!/bin/bash

module load samtools/1.15--h3843a85_0
module load python/3.11.6

SPECIES=e_rankini

REF_DIR=/home/atims/pop_gen/pop_gen/reference_genome/$SPECIES
REFERENCE=e_rankini_OG9_v240206.hic1.3.curated.hap1.chr_level.fa
VENV=/scratch/pawsey1132/atims/pop_gen/$SPECIES/venv

# index reference fasta
samtools faidx ${REF_DIR}/${REFERENCE}

# run python script
python3 -m venv $VENV
ln -s ${VENV} venv
source venv/bin/activate
python3 -m pip install pandas
python3 -m pip install binpacking
python3 -m pip install argparse
python3 -m pip install pathlib

python3 get_regions.py ${REF_DIR}/${REFERENCE}.fai > ${SPECIES}_regions.txt
