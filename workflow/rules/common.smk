___author__ = "Jessika Nordin, Padraic Corcoran"
__copyright__ = "Copyright 2022"
__email__ = "jessika.nordin@scilifelab.uu.se"
__license__ = "GPL-3"

import pandas
import yaml
import json
from datetime import datetime

from hydra_genetics.utils.misc import get_module_snakefile
from hydra_genetics.utils.resources import load_resources
from hydra_genetics.utils.misc import replace_dict_variables
from hydra_genetics.utils.samples import *
from hydra_genetics.utils.units import *
from hydra_genetics.utils.misc import extract_chr
from snakemake.utils import min_version
from snakemake.utils import validate

from hydra_genetics import min_version as hydra_min_version

from hydra_genetics.utils.misc import export_config_as_file
from hydra_genetics.utils.software_versions import add_version_files_to_multiqc
from hydra_genetics.utils.software_versions import add_software_version_to_config
from hydra_genetics.utils.software_versions import export_pipeline_version_as_file
from hydra_genetics.utils.software_versions import export_software_version_as_file
from hydra_genetics.utils.software_versions import get_pipeline_version
from hydra_genetics.utils.software_versions import touch_pipeline_version_file_name
from hydra_genetics.utils.software_versions import touch_software_version_file
from hydra_genetics.utils.software_versions import use_container

min_version("7.8.0")

hydra_min_version("3.0.0")

config = replace_dict_variables(config)
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

## read the output json
with open(config["output"]) as output:
    output_json = json.load(output)

## get version information on pipeline, containers and software

pipeline_name = "Hastings"
pipeline_version = get_pipeline_version(workflow, pipeline_name=pipeline_name)
version_files = touch_pipeline_version_file_name(
    pipeline_version, date_string=pipeline_name, directory="results/versions/software"
)
if use_container(workflow):
    version_files.append(touch_software_version_file(config, date_string=pipeline_name, directory="results/versions/software"))
add_version_files_to_multiqc(config, version_files)


onstart:
    export_pipeline_version_as_file(pipeline_version, date_string=pipeline_name, directory="results/versions/software")
    if use_container(workflow):
        update_config, software_info = add_software_version_to_config(config, workflow, False)
        export_software_version_as_file(software_info, date_string=pipeline_name, directory="results/versions/software")
    date_string = datetime.now().strftime("%Y%m%d")
    export_config_as_file(update_config, date_string=date_string, directory="results/versions")


### Set wildcard constraints
wildcard_constraints:
    barcode="[A-Z+]+",
    chr="[^_]+",
    flowcell="[A-Z0-9]+",
    lane="L[0-9]+",
    read="fastq[1|2]",
    sample="|".join(get_samples(samples)),
    type="N|T|R",
    vcf="vcf|g.vcf|unfiltered.vcf",
    final="^vcf_final/.+",


### Functions
def get_flowcell(units, wildcards):
    flowcells = set([u.flowcell for u in get_units(units, wildcards)])
    if len(flowcells) > 1:
        raise ValueError("Sample type combination from different sequence flowcells")
    return flowcells.pop()


def get_gvcf_output(wildcards, name):
    if config.get(name, {}).get("output_gvcf", False):
        return f" --output_gvcf snv_indels/deepvariant/{wildcards.sample}_{wildcards.type}_{wildcards.chr}.g.vcf.gz "
    else:
        return ""


def get_gvcf_list(wildcards):
    caller = config.get("snp_caller", None)
    if caller is None:
        sys.exit("snp_caller missing from config, valid options: deepvariant_gpu or deepvariant_cpu")
    elif caller == "deepvariant_gpu":
        gvcf_path = "parabricks/pbrun_deepvariant"
        gvcf_list = [
            "{}/{}_{}.g.vcf".format(gvcf_path, sample, t)
            for sample in get_samples(samples)
            for t in get_unit_types(units, sample)
        ]
    elif caller == "deepvariant_cpu":
        gvcf_path = "snv_indels/deepvariant"
        gvcf_list = [
            "{}/{}_{}.merged.g.vcf".format(gvcf_path, sample, t)
            for sample in get_samples(samples)
            for t in get_unit_types(units, sample)
        ]
    else:
        sys.exit("Invalid options for snp_caller, valid options are: deepvariant_gpu or deepvariant_cpu")

    return gvcf_list


def get_gvcf_trio(wildcards):
    caller = config.get("snp_caller", None)

    proband_sample = samples[samples.index == wildcards.sample]
    trio_id = proband_sample.at[wildcards.sample, "trioid"]
    mother_sample = samples[(samples.trio_member == "mother") & (samples.trioid == trio_id)].index[0]
    father_sample = samples[(samples.trio_member == "father") & (samples.trioid == trio_id)].index[0]

    if caller is None:
        sys.exit("snp_caller missing from config, valid options: deepvariant_gpu or deepvariant_cpu")
    elif caller == "deepvariant_gpu":
        child_gvcf = "parabricks/pbrun_deepvariant/{}_{}.g.vcf".format(wildcards.sample, wildcards.type)
        mother_gvcf = "parabricks/pbrun_deepvariant/{}_{}.g.vcf".format(mother_sample, wildcards.type)
        father_gvcf = "parabricks/pbrun_deepvariant/{}_{}.g.vcf".format(father_sample, wildcards.type)
    elif caller == "deepvariant_cpu":
        child_gvcf = "snv_indels/deepvariant/{}_{}.merged.g.vcf".format(wildcards.sample, wildcards.type)
        mother_gvcf = "snv_indels/deepvariant/{}_{}.merged.g.vcf".format(mother_sample, wildcards.type)
        father_gvcf = "snv_indels/deepvariant/{}_{}.merged.g.vcf".format(father_sample, wildcards.type)
    else:
        sys.exit("Invalid options for snp_caller, valid options are: deepvariant_gpu or deepvariant_cpu")

    gvcf_list = [child_gvcf, mother_gvcf, father_gvcf]

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


def get_bam_list(wildcards, sex=None, bai=False):

    bam_list = []
    aligner = config.get("aligner", None)
    for sample in get_samples(samples):
        if samples.loc[sample].sex == sex or sex is None:
            for unit_type in get_unit_types(units, sample):
                if aligner is None:
                    sys.exit("aligner missing from config, valid options: bwa_gpu or bwa_cpu")
                elif aligner == "bwa_gpu":
                    bam_list.append("parabricks/pbrun_fq2bam/{}_{}.bam".format(sample, unit_type))
                else:
                    bam_list.append("alignment/samtools_merge_bam/{}_{}.bam".format(sample, unit_type))

    if bai:
        bai_list = [f"{bam}.bai" for bam in bam_list]
        bam_list += bai_list

    return bam_list


def get_vcf_input(wildcards):
    caller = config.get("snp_caller", None)
    if caller is None:
        sys.exit("snp_caller missing from config, valid options: deepvariant_gpu or deepvariant_cpu")
    elif caller == "deepvariant_gpu":
        vcf_input = f"parabricks/pbrun_deepvariant/{wildcards.sample}_{wildcards.type}.vcf"
    elif caller == "deepvariant_cpu":
        vcf_input = f"snv_indels/deepvariant/{wildcards.sample}_{wildcards.type}.merged.vcf"
    else:
        sys.exit("Invalid options for snp_caller, valid options are: deepvariant_gpu or deepvariant_cpu")

    return vcf_input


def get_glnexus_input(wildcards, input):
    gvcf_input = "-i {}".format(" -i ".join(input.gvcfs))

    return gvcf_input


def get_parent_bams(wildcards):
    aligner = config.get("aligner", None)

    if aligner is None:
        sys.exit("aligner missing from config, valid options: bwa_gpu or bwa_cpu")
    elif aligner == "bwa_gpu":
        bam_path = "parabricks/pbrun_fq2bam"
    elif aligner == "bwa_cpu":
        bam_path = "alignment/samtools_merge_bam"

    proband_sample = samples[samples.index == wildcards.sample]
    trio_id = proband_sample.at[wildcards.sample, "trioid"]

    mother_sample = samples[(samples.trio_member == "mother") & (samples.trioid == trio_id)].index[0]
    mother_bam = "{}/{}_{}.bam".format(bam_path, mother_sample, list(get_unit_types(units, mother_sample))[0])

    father_sample = samples[(samples.trio_member == "father") & (samples.trioid == trio_id)].index[0]
    father_bam = "{}/{}_{}.bam".format(bam_path, father_sample, list(get_unit_types(units, father_sample))[0])

    bam_list = [mother_bam, father_bam]

    bam_list += [f"{bam}.bai" for bam in bam_list]

    return bam_list


def get_peddy_sex(wildcards, peddy_sex_check):
    sample = "{}_{}".format(wildcards.sample, wildcards.type)
    sex_df = pandas.read_table(peddy_sex_check, sep=",").set_index("sample_id", drop=False)

    sample_sex = sex_df.at[sample, "predicted_sex"]

    return sample_sex


def get_exomedepth_ref(wildcards):
    sex = get_peddy_sex(wildcards, checkpoints.cnv_sv_exomedepth_sex.get().output[0])

    if sex == "male":
        ref = config.get("exomedepth_call", {}).get("male_reference", "")
    else:  # use female ref in the case of female or NA
        ref = config.get("exomedepth_call", {}).get("female_reference", "")

    return ref


def compile_output_list(wildcards):
    output_files = []
    types = set([unit.type for unit in units.itertuples()])
    for output in output_json:
        if output == "results/{sample}/{sample}.upd_regions.bed":
            for sample in samples[samples.trio_member == "proband"].index:
                proband_sample = samples[samples.index == sample]
                trio_id = proband_sample.at[sample, "trioid"]
                try:  # check for mother and father in samples df
                    mother_sample = samples[(samples.trio_member == "mother") & (samples.trioid == trio_id)].index[0]
                    father_sample = samples[(samples.trio_member == "father") & (samples.trioid == trio_id)].index[0]
                    output_files.append(output.format(sample=sample))
                except IndexError:
                    continue

        else:
            output_files += set(
                [
                    output.format(sample=sample, flowcell=flowcell, lane=lane, barcode=barcode, type=unit_type)
                    for sample in get_samples(samples)
                    for unit_type in get_unit_types(units, sample)
                    if unit_type in set(output_json[output]["types"])
                    for flowcell in set([u.flowcell for u in units.loc[(sample, unit_type)].dropna().itertuples()])
                    for barcode in set([u.barcode for u in units.loc[(sample, unit_type)].dropna().itertuples()])
                    for lane in set([u.lane for u in units.loc[(sample, unit_type)].dropna().itertuples()])
                ]
            )

    return list(set(output_files))


def generate_copy_code(workflow, output_json):
    code = ""
    for result, values in output_json.items():
        if values["file"] is not None:
            input_file = values["file"]
            output_file = result
            rule_name = values["name"]
            mem_mb = config.get("_copy", {}).get("mem_mb", config["default_resources"]["mem_mb"])
            mem_per_cpu = config.get("_copy", {}).get("mem_mb", config["default_resources"]["mem_mb"])
            partition = config.get("_copy", {}).get("partition", config["default_resources"]["partition"])
            threads = config.get("_copy", {}).get("threads", config["default_resources"]["threads"])
            time = config.get("_copy", {}).get("time", config["default_resources"]["time"])
            copy_container = config.get("_copy", {}).get("container", config["default_container"])
            result_file = os.path.basename(output_file)
            code += f'@workflow.rule(name="{rule_name}")\n'
            code += f'@workflow.input("{input_file}")\n'
            code += f'@workflow.output("{output_file}")\n'
            code += f'@workflow.log("logs/{rule_name}_{result_file}.log")\n'
            code += f'@workflow.container("{copy_container}")\n'
            code += f'@workflow.resources(time = "{time}", threads = {threads}, mem_mb = {mem_mb}, mem_per_cpu = {mem_per_cpu}, partition = "{partition}")\n'
            code += '@workflow.shellcmd("cp {input} {output}")\n\n'
            code += "@workflow.run\n"
            code += (
                f"def __rule_{rule_name}(input, output, params, wildcards, threads, resources, log, version, rule, "
                "conda_env, container_img, singularity_args, use_singularity, env_modules, bench_record, jobid, is_shell, "
                "bench_iteration, cleanup_scripts, shadow_dir, edit_notebook, conda_base_path, basedir, runtime_sourcecache_path, "
                "__is_snakemake_rule_func=True):\n"
                '\tshell ( "(cp {input[0]} {output[0]}) &> {log}" , bench_record=bench_record, bench_iteration=bench_iteration)\n\n'
            )

    exec(compile(code, "result_to_copy", "exec"), workflow.globals)


generate_copy_code(workflow, output_json)
