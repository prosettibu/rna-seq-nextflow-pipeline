#!/usr/bin/env nextflow
process ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'

    input:
    tuple val(sample), path(reads)
    path(index)

    output:
    tuple val(sample), path("${sample}.Aligned.out.bam"), emit: bam
    tuple val(sample), path("${sample}.Log.final.out"), emit: log

    shell:
    """
   
    STAR --runThreadN $task.cpus --genomeDir $index --readFilesIn ${reads[0]} ${reads[1]} --readFilesCommand zcat --outFileNamePrefix ${sample}. --outSAMtype BAM Unsorted

    """

    stub:
    """
    touch ${sample}.Aligned.out.bam
    touch ${sample}.Log.final.out
    """

}