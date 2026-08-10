#!/usr/bin/env python3

from pathlib import Path

import argparse
import binpacking
import pandas as pd


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "index_file", type=Path, help="Path to index file created with samtools faidx"
    )
    return parser.parse_args()


args = parse_arguments()

fai = pd.read_csv(args.index_file, sep="\t", header=None)

df = pd.DataFrame(fai)
keys = df[0]
values = df[1]

dict = dict(zip(keys, values))

chr1_size = df.iloc[0, 1]

bins = binpacking.to_constant_bin_number(dict, 24)
for d in bins:
    bin_size = sum(d.values())
    result = ",".join(f"{k}:1-{str(v)}" for k, v in d.items())
    print(result)
