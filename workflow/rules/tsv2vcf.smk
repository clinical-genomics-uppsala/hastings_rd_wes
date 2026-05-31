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
    threads: rule_resource("tsv2vcf", "threads")
    resources:
        mem_mb=rule_resource("tsv2vcf", "mem_mb"),
        mem_per_cpu=rule_resource("tsv2vcf", "mem_per_cpu"),
        partition=rule_resource("tsv2vcf", "partition"),
        threads=rule_resource("tsv2vcf", "threads"),
        time=rule_resource("tsv2vcf", "time"),
    container:
        rule_container("tsv2vcf")
    message:
        "{rule}: convert {input.tsv} to VCF"
    script:
        "../scripts/tsv2vcf.sh"
