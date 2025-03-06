__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2025, Pádraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule csv2vcf:
    input:
        csv="cnv_sv/exomedepth_call/{sample}_{type}.txt",
        ref=config["reference"]["fasta"],
    output:
        vcf="cnv_sv/exomedepth_call/{sample}_{type}.vcf.gz",
    params:
        extra=config.get("csv2vcf", {}).get("extra", ""),
    log:
        "cnv_sv/exomedepth_call/{sample}_{type}.vcf.gz.log",
    benchmark:
        repeat(
            "cnv_sv/exomedepth_call/{sample}_{type}.vcf.gz.benchmark.tsv",
            config.get("csv2vcf", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("csv2vcf", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("csv2vcf", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("csv2vcf", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("csv2vcf", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("csv2vcf", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("csv2vcf", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("csv2vcf", {}).get("container", config["default_container"])
    message:
        "{rule}: convert {input.csv} to VCF"
    script:
        "../scripts/csv2vcf.sh"
