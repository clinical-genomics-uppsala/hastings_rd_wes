__author__ = "Jessika Nordin, Padraic Corcoran"
__copyright__ = "Copyright 2022"
__email__ = "jessika.nordin@scilifelab.uu.se"
__license__ = "GPL-3"


rule vcf_addRef:
    input:
        vcf="snv_indels/bcftools_view/{sample}_{type}.vcf",
        ref=config["reference"]["fasta"],
    output:
        vcf=temp("vcf_final/{sample}_{type}.vcf"),
    log:
        "vcf_final/{sample}_{type}_add_ref.log",
    benchmark:
        repeat(
            "vcf_final/{sample}_{type}.vcf.benchmark.tsv",
            config.get("vcf_addRef", {}).get("benchmark_repeats", 1),
        )
    resources:
        mem_mb=rule_resource("vcf_addRef", "mem_mb"),
        mem_per_cpu=rule_resource("vcf_addRef", "mem_per_cpu"),
        partition=rule_resource("vcf_addRef", "partition"),
        threads=rule_resource("vcf_addRef", "threads"),
        time=rule_resource("vcf_addRef", "time"),
    container:
        rule_container("vcf_addRef")
    message:
        "{rule}: Add reference to the header of the deepvariant vcf: {input.vcf}"
    script:
        "../scripts/ref_vcf.py"
