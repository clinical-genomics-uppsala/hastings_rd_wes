___author__ = "Nina Hollfelder"
__copyright__ = "Copyright 2026"
__email__ = "nina.hollfelder@scilifelab.uu.se"
__license__ = "GPL-3"

rule bcftools_isec:
    input:
        vcfa="snv_indels/bcftools_view/{sample}_{type}.pass.vcf.gz",
        vcfb="snv_indels/bcftools_view/{sample}_{type}.ds.vcf.gz",
    output:
        vcf=temp("snv_indels/bcftools_view/{sample}_{type}.ds.nogermline.vcf.gz"),
    log:
        "snv_indels/bcftools_view/{sample}_{type}.ds.nogermline.vcf.gz.log",
    benchmark:
        repeat(
            "snv_indels/bcftools_view/{sample}_{type}.ds.nogermline.vcf.gz.benchmark.tsv",
            config.get("bcftools_isec", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("bcftools_isec", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("bcftools_isec", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("bcftools_isec", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("bcftools_isec", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("bcftools_isec", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("bcftools_isec", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("bcftools_isec", {}).get("container", config["default_container"])
    message:
        "{rule}: intersect {input.vcfb} with {input.vcfa} to keep only records unique to {input.vcfb} "
    shell:
        "bcftools isec -C -w1 {input.vcfb} {input.vcfa} -Oz -o {output.vcf}"
