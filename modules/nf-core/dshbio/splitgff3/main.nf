process DSHBIO_SPLITGFF3 {
    tag "${meta.id}"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::dsh-bio=2.1" : null)
    container { workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/dsh-bio:2.1--hdfd78af_0' :
        "${params.docker_url ?: 'quay.io/biocontainers'}/dsh-bio:2.1--hdfd78af_0" }

    input:
    tuple val(meta), path(gff3)

    output:
    tuple val(meta), path("*.gff3.gz"), emit: gff3
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    dsh-bio \\
        split-gff3 \\
        $args \\
        -p $prefix \\
        -s '.gff3.gz' \\
        -i $gff3

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dshbio: \$(dsh-bio --version 2>&1 | grep -o 'dsh-bio-tools .*' | cut -f2 -d ' ')
    END_VERSIONS
    """
}
