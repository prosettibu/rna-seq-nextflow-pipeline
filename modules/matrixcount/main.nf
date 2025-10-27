#!/usr/bin/env nextflow

process MATRIXCOUNT {
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(verses)

    output:
    path "counts_matrix.csv"

    script:
    """ 
    countsmatrix.py -i ${verses.join(' ')} -o counts_matrix.csv
    """
}