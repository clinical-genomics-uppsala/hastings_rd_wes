import pathlib
import re


def _wanted_samples(spec_entry):
    """Vilka prov filen ska begaras for.

    `when: complete_trio` begransar till probander som har bade mor och far i
    samples.tsv - samma logik som tidigare lag hardkodad pa
    results/{sample}/{sample}.upd_regions.bed.
    """
    if spec_entry.get("when") != "complete_trio":
        return list(get_samples(samples))

    probands = []
    for sample in samples[samples.trio_member == "proband"].index:
        trio_id = samples.at[sample, "trioid"]
        has_mother = not samples[(samples.trio_member == "mother") & (samples.trioid == trio_id)].empty
        has_father = not samples[(samples.trio_member == "father") & (samples.trioid == trio_id)].empty
        if has_mother and has_father:
            probands.append(sample)
    return probands


def compile_output_file_list(wildcards):
    outdir = pathlib.Path(output_spec.get("directory", "./"))
    output_files = []

    for f in output_spec["files"]:
        wanted_types = set(f.get("types", ["N"]))
        for sample in _wanted_samples(f):
            for unit_type in get_unit_types(units, sample):
                if unit_type not in wanted_types:
                    continue
                units_for_sample = units.loc[(sample, unit_type)].dropna()
                for u in units_for_sample.itertuples():
                    output_files.append(
                        outdir / pathlib.Path(
                            f["output"].format(
                                sample=sample,
                                type=unit_type,
                                flowcell=u.flowcell,
                                lane=u.lane,
                                barcode=u.barcode,
                            )
                        )
                    )

    return sorted(set(output_files))


def generate_copy_rules(output_spec):
    """Bygger en _copy_<name>-regel per post med `input` satt.

    Reglerna maste genereras vid parsning eftersom antalet resultatfiler beror
    pa output_files.yaml. Kopieringen ar oforandrad: `cp` av en fil i taget.
    """
    outdir = pathlib.Path(output_spec.get("directory", "./"))
    rulestrings = []

    for f in output_spec["files"]:
        if f["input"] is None:
            continue

        rule_name = "_copy_{}".format("_".join(re.split(r"\W+", f["name"].strip().lower())))
        input_file = pathlib.Path(f["input"])
        output_file = outdir / pathlib.Path(f["output"])

        mem_mb = config.get("_copy", {}).get("mem_mb", config["default_resources"]["mem_mb"])
        mem_per_cpu = config.get("_copy", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"])
        partition = config.get("_copy", {}).get("partition", config["default_resources"]["partition"])
        threads = config.get("_copy", {}).get("threads", config["default_resources"]["threads"])
        time = config.get("_copy", {}).get("time", config["default_resources"]["time"])
        copy_container = config.get("_copy", {}).get("container", config["default_container"])

        rulestrings.append(
            "\n".join(
                [
                    f'@workflow.rule(name="{rule_name}")',
                    f'@workflow.input("{input_file}")',
                    f'@workflow.output("{output_file}")',
                    f'@workflow.log("logs/{rule_name}_{output_file.name}.log")',
                    f'@workflow.container("{copy_container}")',
                    f'@workflow.resources(time="{time}", threads={threads}, mem_mb={mem_mb}, '
                    f'mem_per_cpu={mem_per_cpu}, partition="{partition}")',
                    '@workflow.shellcmd("cp {input} {output}")',
                    "@workflow.run\n",
                    f"def __rule_{rule_name}(input, output, params, wildcards, threads, resources, "
                    "log, version, rule, conda_env, container_img, singularity_args, use_singularity, "
                    "env_modules, bench_record, jobid, is_shell, bench_iteration, cleanup_scripts, "
                    "shadow_dir, edit_notebook, conda_base_path, basedir, runtime_sourcecache_path, "
                    "__is_snakemake_rule_func=True):",
                    '\tshell("(cp {input[0]} {output[0]}) &> {log}", bench_record=bench_record, '
                    "bench_iteration=bench_iteration)\n\n",
                ]
            )
        )

    exec(compile("\n".join(rulestrings), "copy_result_files", "exec"), workflow.globals)


generate_copy_rules(output_spec)
