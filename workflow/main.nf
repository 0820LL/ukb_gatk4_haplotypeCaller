// Declare syntax version
nextflow.enable.dsl=2

process GATK4_HAPLOTYPECALLER {

    container = "${projectDir}/../singularity-images/depot.galaxyproject.org-singularity-gatk4-4.3.0.0--py36hdfd78af_0.img"

    input:
    path cram
    path crai
    path fasta
    path fai
    path dict

    output:
    path "*.vcf.gz"
    path "*.vcf.gz.tbi"

    script:
    """
    gatk --java-options "-Xmx36g" HaplotypeCaller \\
        --input $cram \\
        --output ${params.prefix}.vcf.gz \\
        --reference $fasta \\
        --tmp-dir .
    cp ${params.prefix}.vcf.gz ${launchDir}/${params.outdir}/
    cp ${params.prefix}.vcf.gz.tbi ${launchDir}/${params.outdir}/
    """
}

workflow{
    cram       = Channel.of(params.cram)
    cram_crai  = Channel.of(params.cram_index)
    fasta      = Channel.of(params.fasta)
    fasta_dict = Channel.of(params.fasta_dict)
    fasta_fai  = Channel.of(params.fasta_fai)
    GATK4_HAPLOTYPECALLER(cram, cram_crai, fasta, fasta_fai, fasta_dict)
}

