#!/usr/bin/env nextflow
process GTFPARSE {
    label 'process_single'
    container 'ghcr.io/bf528/biopython:latest'
    publishDir params.outdir

    input:
    path gtf
    
    output:
    path('idgenename.txt'), emit: idgenename

    shell:
    """
    gtfparse.py -i $gtf -o idgenename.txt
    """

    stub:
    """
    touch idgenename.txt
    """

}