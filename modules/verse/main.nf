#!/usr/bin/env nextflow

process VERSE {
    label 'process_low'
    container 'ghcr.io/bf528/verse:latest'

    input:
    tuple val(sample), path(bam)
    path gtf

    output:
    tuple val(sample), path("${sample}.exon.txt*")

    script:
    """
    verse -S -a $gtf -o $sample $bam
    """
}
