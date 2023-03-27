#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { VIBRANT_VIBRANTRUN } from '../../../../../modules/nf-core/vibrant/vibrantrun/main.nf'

workflow test_vibrant_vibrantrun {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    VIBRANT_VIBRANTRUN ( input )
}
