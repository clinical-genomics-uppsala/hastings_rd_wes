__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2025, Pádraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule tsv2vcf:
    input:
        tsv="cnv_sv/exomedepth_call/{sample}_{type}.txt",
        ref=config["reference"]["fasta"],
    output:
        vcf="cnv_sv/exomedepth_call/{sample}_{type}.vcf",
    params:
        extra=config.get("tsv2vcf", {}).get("extra", ""),
    log:
        "cnv_sv/exomedepth_call/{sample}_{type}.vcf.gz.log",
    benchmark:
        repeat(
            "cnv_sv/exomedepth_call/{sample}_{type}.vcf.gz.benchmark.tsv", config.get("tsv2vcf", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("tsv2vcf", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("tsv2vcf", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("tsv2vcf", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("tsv2vcf", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("tsv2vcf", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("tsv2vcf", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("tsv2vcf", {}).get("container", config["default_container"])
    message:
        "{rule}: convert {input.tsv} to VCF"
    script:
        "../scripts/tsv2vcf.sh"
