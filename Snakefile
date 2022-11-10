import glob
import os
"""
SAMPLES = {
    "SAMPLE1":"tutorial_fastas/sequence_1.fasta",
    "SAMPLE2":"tutorial_fastas/sequence_2.fasta",
    "SAMPLE3":"tutorial_fastas/sequence_3.fasta",
    "SAMPLE4":"tutorial_fastas/sequence_4.fasta",
    "SAMPLE5":"tutorial_fastas/sequence_5.fasta",
}
"""

def process_input(inputdirectory):
    list_of_files = glob.glob(inputdirectory)
    sample_dict = {}
    for sample in list_of_files:
        samplename = os.path.basename(sample)
        sample_dict[samplename] = sample

    return sample_dict

SAMPLES = process_input("tutorial_fastas/*")
print(SAMPLES)


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
