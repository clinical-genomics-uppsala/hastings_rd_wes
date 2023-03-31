___author__ = "Jessika Nordin, Padraic Corcoran"
__copyright__ = "Copyright 2022"
__email__ = "jessika.nordin@scilifelab.uu.se"
__license__ = "GPL-3"

import pandas
import yaml

from hydra_genetics.utils.resources import load_resources
from hydra_genetics.utils.samples import *
from hydra_genetics.utils.units import *
from snakemake.utils import min_version
from snakemake.utils import validate

min_version("6.10")
    
### Set and validate config file
configfile: "config/config.yaml"

validate(config, schema="../schemas/config.schema.yaml")

config = load_resources(config, config["resources"])
validate(config, schema="../schemas/resources.schema.yaml")


### Read and validate samples file
samples = pandas.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file
units = (
    pandas.read_table(config["units"], dtype=str)
    .set_index(["sample", "type", "flowcell", "lane", "barcode"], drop=False)
    .sort_index()
)

validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints
wildcard_constraints:
    barcode="[A-Z+]+",
    chr="[^_]+",
    flowcell="[A-Z0-9]+",
    lane="L[0-9]+",
    read="fastq[1|2]",
    sample="|".join(get_samples(samples)),
    type="N|T|R",
    #trioid='|'.join(samples.trioid.dropna().unique().tolist())


### Functions
def get_flowcell(units, wildcards):
    flowcells = set([u.flowcell for u in get_units(units, wildcards)])
    if len(flowcells) > 1:
        raise ValueError("Sample type combination from different sequence flowcells")
    return flowcells.pop()


def get_gvcf_list(wildcards):

    caller = config.get("snp_caller", None)
    if caller is None:
        sys.exit("snp_caller missing from config, valid options: deepvariant_gpu or deepvariant_cpu")
    elif caller == "deepvariant_gpu":
        gvcf_path = "parabricks/pbrun_deepvariant"
    elif caller == "deepvariant_cpu":
        gvcf_path = "snv_indels/deepvariant"
    else:
        sys.exit("Invalid options for snp_caller, valid options are: deepvariant_gpu or deepvariant_cpu")

    gvcf_list = [
        "{}/{}_{}.g.vcf".format(gvcf_path, sample, t)
        for sample in get_samples(samples)
        for t in get_unit_types(units, sample)
    ]
    

    return gvcf_list


def get_in_gvcf(wildcards):
    gvcf_list = get_gvcf_list(wildcards)
    return " -i ".join(gvcf_list)


def get_spring_extra(wildcards: snakemake.io.Wildcards):
    extra = config.get("spring", {}).get("extra", "")
    if get_fastq_file(units, wildcards, "fastq1").endswith(".gz"):
        extra = "%s %s" % (extra, "-g")
    return extra


def get_bam_input(wildcards, use_sample_wildcard=True, use_type_wildcard=True, by_chr=False):

    if use_sample_wildcard and use_type_wildcard is True:
        sample_str = "{}_{}".format(wildcards.sample, wildcards.type)
    elif use_sample_wildcard and use_type_wildcard is not True:
        sample_str = "{}_{}".format(wildcards.sample, "N")
    else:
        sample_str = wildcards.file

    aligner = config.get("aligner", None)
    if aligner is None:
        sys.exit("aligner missing from config, valid options: bwa_gpu or bwa_cpu")
    elif aligner == "bwa_gpu":
        bam_input = "parabricks/pbrun_fq2bam/{}.bam".format(sample_str)
    elif aligner == "bwa_cpu":
        if by_chr:  # if a bam for single chromosome is needed
            bam_input = "alignment/picard_mark_duplicates/{}_{}.bam".format(sample_str, wildcards.chr)
        else:
            bam_input = "alignment/samtools_merge_bam/{}.bam".format(sample_str)
    else:
        sys.exit("valid options for aligner are: bwa_gpu or bwa_cpu")

    bai_input = "{}.bai".format(bam_input)

    return (bam_input, bai_input)


def get_vcf_input(wildcards):

    caller = config.get("snp_caller", None)
    if caller is None:
        sys.exit("snp_caller missing from config, valid options: deepvariant_gpu or deepvariant_cpu")
    elif caller == "deepvariant_gpu":
        vcf_input = "parabricks/pbrun_deepvariant/{}_{}.vcf".format(wildcards.sample, wildcards.type)
    elif caller == "deepvariant_cpu":
        vcf_input = "snv_indels/deepvariant/{}_{}.vcf".format(wildcards.sample, wildcards.type)
    else:
        sys.exit("Invalid options for snp_caller, valid options are: deepvariant_gpu or deepvariant_cpu")

    return vcf_input


def get_glnexus_input(wildcards, input):

   
    gvcf_input =  "-i {}".format(" -i ".join(input.gvcfs))
   
    return gvcf_input


def compile_output_list(wildcards: snakemake.io.Wildcards):

    files = {
        "compression/crumble": ["crumble.cram"],
        "cnv_sv/exomedepth_call": ["RData"],
        "qc/create_cov_excel": ["coverage.xlsx"],
        "vcf_final" : ["vcf.gz.tbi"],
    }
    output_files = [
        "%s/%s_%s.%s" % (prefix, sample, unit_type, suffix)
        for prefix in files.keys()
        for sample in get_samples(samples)
        for unit_type in get_unit_types(units, sample)
        for suffix in files[prefix]
    ]
    output_files += ["qc/multiqc/multiqc_DNA.html"]
    output_files += [
        "qc/peddy/peddy.peddy.ped",
        "qc/peddy/peddy.ped_check.csv",
        "qc/peddy/peddy.sex_check.csv",
        "qc/peddy/peddy.het_check.csv",
        "qc/peddy/peddy.html",
        "qc/peddy/peddy.vs.html",
        "qc/peddy/peddy.background_pca.json",
    ]

    output_files += [
        "cnv_sv/automap/%s_%s/%s_%s.HomRegions.tsv" % (sample, unit_type, sample, unit_type)
        for sample in get_samples(samples)
        for unit_type in get_unit_types(units, sample)
    ]

 

    files = {
        "snv_indels/deeptrio": ["g.vcf", "vcf"],
    }
    output_files += [
        "%s/%s_%s/%s.%s" % (prefix, sample, unit_type,trio_member,suffix)
        for prefix in files.keys()
        for sample in samples[samples.trio_member == 'proband'].index
        for unit_type in get_unit_types(units, sample)
        for trio_member in ['child', 'parent1', 'parent2']
        for suffix in files[prefix]
    ]

    files = {
        "snv_indels/glnexus": ["vcf.gz"],
        "cnv_sv/upd": ["upd_regions.bed"],
    }
    output_files += [
        "%s/%s_%s.%s" % (prefix, sample, unit_type,suffix)
        for prefix in files.keys()
        for sample in samples[samples.trio_member == 'proband'].index
        for unit_type in get_unit_types(units, sample)
        for suffix in files[prefix]
    ]

    output_files += [
        "compression/spring/%s_%s_%s_%s_%s.spring" % (sample, flowcell, lane, barcode, t)
        for sample in get_samples(samples)
        for t in get_unit_types(units, sample)
        for flowcell in set(
            [
                u.flowcell
                for u in units.loc[
                    (
                        sample,
                        t,
                    )
                ]
                .dropna()
                .itertuples()
            ]
        )
        for barcode in set(
            [
                u.barcode
                for u in units.loc[
                    (
                        sample,
                        t,
                    )
                ]
                .dropna()
                .itertuples()
            ]
        )
        for lane in set(
            [
                u.lane
                for u in units.loc[
                    (
                        sample,
                        t,
                    )
                ]
                .dropna()
                .itertuples()
            ]
        )
    ]

    
    return output_files
    