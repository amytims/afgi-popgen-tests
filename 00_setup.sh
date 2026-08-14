#!/bin/bash

# create scratch dir and symlink to work dir on /home
mkdir /scratch/pawsey1132/atims/pop_gen/
ln -s /scratch/pawsey1132/atims/pop_gen/ pop_gen

# create directory for slurm logs to go to
mkdir pop_gen/slurm/
