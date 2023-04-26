__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2023, Arielle R Munters"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule exomedepth_export:
    input:
        exon="cnv_sv/exomedepth_call/{sample}_{type}.RData",
    output:
        aed="cnv_sv/exomedepth_call/{sample}_{type}.aed",
        nexus_sv="cnv_sv/exomedepth_call/{sample}_{type}_SV.txt",
    params:
        extra=config.get("exomedepth_export", {}).get("extra", ""),
    log:
        "cnv_sv/exomedepth_call/{sample}_{type}_SV.txt.log",
    benchmark:
        repeat(
            "cnv_sv/exomedepth_call/{sample}_{type}_SV.txt.benchmark.tsv", 
            config.get("exomedepth_export", {}).get("benchmark_repeats", 1)
        ),
    threads: config.get("exomedepth_export", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("exomedepth_export", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("exomedepth_export", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("exomedepth_export", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("exomedepth_export", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("exomedepth_export", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("exomedepth_export", {}).get("container", config["default_container"])
    message:
        "{rule}: Export exomedepth CNV results from {input.exon} "
    script:
        "../scripts/exomedepth_export.R"
