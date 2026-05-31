__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2023, Arielle R Munters"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule exomedepth_export:
    input:
        exon="cnv_sv/exomedepth_call/{sample}_{type}.RData",
    output:
        aed=temp("cnv_sv/exomedepth_call/{sample}_{type}.aed"),
        nexus_sv=temp("cnv_sv/exomedepth_call/{sample}_{type}_SV.txt"),
    params:
        extra=config.get("exomedepth_export", {}).get("extra", ""),
    log:
        "cnv_sv/exomedepth_call/{sample}_{type}_SV.txt.log",
    benchmark:
        repeat(
            "cnv_sv/exomedepth_call/{sample}_{type}_SV.txt.benchmark.tsv",
            config.get("exomedepth_export", {}).get("benchmark_repeats", 1),
        )
    threads: rule_resource("exomedepth_export", "threads")
    resources:
        mem_mb=rule_resource("exomedepth_export", "mem_mb"),
        mem_per_cpu=rule_resource("exomedepth_export", "mem_per_cpu"),
        partition=rule_resource("exomedepth_export", "partition"),
        threads=rule_resource("exomedepth_export", "threads"),
        time=rule_resource("exomedepth_export", "time"),
    container:
        rule_container("exomedepth_export")
    message:
        "{rule}: Export exomedepth CNV results from {input.exon} "
    script:
        "../scripts/exomedepth_export.R"
