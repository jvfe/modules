process SAMTOOLS_DICT {
    tag "$fasta"
    label 'process_single'

    conda (params.enable_conda ? "bioconda::samtools=1.15.1" : null)
    container { workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.15.1--h1170115_0' :
        "${params.docker_url ?: 'quay.io/biocontainers'}/samtools:1.15.1--h1170115_0" }

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path ("*.dict"), emit: dict
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    samtools \\
        dict \\
        $args \\
        $fasta \\
        > ${fasta}.dict

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """

    stub:
    """
    touch ${fasta}.dict
    cat <<-END_VERSIONS > versions.yml

    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
