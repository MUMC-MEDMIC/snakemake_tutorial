my_samples = {
    "sample1":"tutorial_fastas/sequence_1.fasta",
    "sample2":"tutorial_fastas/sequence_2.fasta",
    "sample3":"tutorial_fastas/sequence_3.fasta",
    "sample4":"tutorial_fastas/sequence_4.fasta"
}

rule all:
    input:
        expand("results/{sample}/amr_{sample}.tsv", sample = my_samples),
        expand("results/{sample}/plasmids_{sample}.tsv", sample = my_samples),
        "summary.tsv"




rule abricate_AMR:
    input:
        sample = lambda wildcards: my_samples[wildcards.sample]
    output:
        "results/{sample}/amr_{sample}.tsv"
    conda:
        "environments/abricate.yaml"
    shell:
        "abricate {input.sample} > {output}"


rule abricate_plasmids:
    input:
        sample = lambda wildcards: my_samples[wildcards.sample]
    output:
        "results/{sample}/plasmids_{sample}.tsv"
    conda:
        "environments/abricate.yaml"
    shell:
        "abricate --db plasmidfinder {input.sample} > {output}"


rule summarize:
    input:
        expand("results/{sample}/amr_{sample}.tsv", sample = my_samples),
        expand("results/{sample}/plasmids_{sample}.tsv", sample = my_samples)
    output:
        "summary.tsv"
    conda:
        "environments/abricate.yaml"
    shell:
        "abricate --summary {input} > {output}"

rule make_image:
    input:
        "summary.tsv"
    
