#!/usr/bin/env python

import argparse
import pandas as pd
import os

parser = argparse.ArgumentParser(description="Concatenate VERSE exon count files into a counts matrix.")
parser.add_argument(
    '-i', '--input', nargs='+', required=True,
    help='List of VERSE exon count files'
)
parser.add_argument(
    '-o', '--output', required=True,
    help='Output CSV filename for combined counts matrix'
)
args = parser.parse_args()

dfs = []
for file in args.input:
    sample = os.path.basename(file).replace('.exon.txt', '')
    df = pd.read_csv(file, sep='\t', header=0)
    df = df.rename(columns={df.columns[1]: sample})
    df.set_index('gene', inplace=True)
    dfs.append(df)

counts_matrix = pd.concat(dfs, axis=1).fillna(0).astype(int)
counts_matrix.to_csv(args.output)