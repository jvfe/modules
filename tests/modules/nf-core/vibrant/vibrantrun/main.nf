#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { VIBRANT_VIBRANTRUN } from '../../../../../modules/nf-core/vibrant/vibrantrun/main.nf'

workflow test_vibrant_vibrantrun {

    input = [
        [ id:'test' ], // meta map
        file(params.test_data['candidatus_portiera_aleyrodidarum']['genome']['genome_fasta'], checkIfExists: true)
    ]

    VIBRANT_VIBRANTRUN ( input, [] )
}
