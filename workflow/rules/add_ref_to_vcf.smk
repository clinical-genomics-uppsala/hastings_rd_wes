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
        mem_mb=config.get("vcf_addRef", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("vcf_addRef", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("vcf_addRef", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("vcf_addRef", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("vcf_addRef", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("vcf_addRef", {}).get("container", config["default_container"])
    message:
        "{rule}: Add reference to the header of the deepvariant vcf: {input.vcf}"
    script:
        "../scripts/ref_vcf.py"
