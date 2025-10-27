#!/usr/bin/env python

import argparse

# here we are initializing the argparse object that we will modify
parser = argparse.ArgumentParser()

# we are asking argparse to require a -i or --input flag on the command line when this
# script is invoked. It will store it in the "filenames" attribute of the object
# we will be passing it via snakemake, a list of all the outputs of verse so we can
# concatenate them into a single matrix using pandas 

parser.add_argument("-i", "--input", help='Input GFF file', dest="input", required=True)
parser.add_argument("-o", "--output", help='Output file name and path', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()

# you can access the values on the command line by using `args.input` or 'args.output`


import csv

ids = []
names = []

with open(args.input, 'rt') as f:
    reader = csv.reader(f, delimiter='\t')
    for row in reader:
        if row[0][0] == '#':
            continue
        else:
            if row[2] == 'gene':
                gene_info = row[8].strip().split('; ')
                splits = [_.split('"') for _ in gene_info]
                for l in splits:
                    if l[0].strip() == 'gene_id':
                        ids.append(l[1])
                    if l[0].strip() == 'gene_name':
                        names.append(l[1])

with open(args.output, 'wt') as w:
    for geneid, genename in zip(ids, names):
        w.write('{}\t{}\n'.format(geneid, genename))