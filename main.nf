#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'
include {INDEX} from './modules/star_index'
include {GTFPARSE} from './modules/gtfparse'
include {ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {MATRIXCOUNT} from './modules/matrixcount'


workflow {
    
    Channel.fromFilePairs(params.reads).transpose().set{ fastqc_ch }

    Channel.fromFilePairs(params.reads).set{align_ch}

    GTFPARSE(params.gtf)

    FASTQC(fastqc_ch)

    INDEX(params.genome, params.gtf)
    ALIGN(align_ch, INDEX.out)
    

    multiqc_ch = FASTQC.out.zip.map{it[1]}
    .mix(ALIGN.out.log.map{it[1]}).flatten().collect()

    MULTIQC(multiqc_ch)

    verse_ch = VERSE(ALIGN.out.bam, params.gtf).map{it[1]}.collect()

    MATRIXCOUNT(verse_ch)

    
}


