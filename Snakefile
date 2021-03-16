SAMPLES = {
    "SAMPLE1":"tutorial_fastas/sequence_1.fasta",
    "SAMPLE2":"tutorial_fastas/sequence_2.fasta",
    "SAMPLE3":"tutorial_fastas/sequence_3.fasta",
    "SAMPLE4":"tutorial_fastas/sequence_4.fasta",
    "SAMPLE5":"tutorial_fastas/sequence_5.fasta",
}


rule all:
    input:
        'summary.tsv'


rule abricate_AMR:
    input:
        myfasta = lambda wildcards: SAMPLES[wildcards.sample],
    output:
        "results/{sample}/AMR_{sample}.tsv"
    conda:
        "environments/abricate.yaml"
    threads:
        1
    shell:
        "abricate {input.myfasta} --threads {threads} > {output}"

rule summarize:
    input:
        expand("results/{sample}/AMR_{sample}.tsv", sample = SAMPLES)
    output:
        "summary.tsv"
    conda:
        "environments/abricate.yaml"
    shell:
        "abricate --summary {input} > {output}"
