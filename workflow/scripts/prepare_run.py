#!/usr/bin/env python3
"""
Hastings' hook for the common CGU launcher (pipeline_start_scripts/tools/launch.py).

The launcher does everything that is the same for every pipeline. This file
holds only what is specific to Hastings, and is versioned with the pipeline.

A Hastings run folder can hold two designs, told apart by the `twist` sample
column: Twist Comprehensive Exome and Twist Exome 2.0. Each is analysed as a
separate Snakemake run in the same run directory:

    prepare_run.py plan --run-dir D --pipeline-home H
        print {"runs": [...]} for the designs present in samples.tsv
    prepare_run.py prepare <run> --run-dir D --pipeline-home H
        write config/samples.tsv, config/units.tsv, config/sample_order.tsv and
        config/sample_replacement.tsv for that run

`prepare` runs immediately before its own run, because both runs use the same
config/samples.tsv. The comprehensive run's MultiQC and Peddy reports are
renamed afterwards so that the Twist 2.0 run does not overwrite them.

Selection rules, same as the former start script:

  * comprehensive: rows of samples.tsv containing "comprehensive"
  * twist2.0: all other rows
  * units: rows of units.tsv whose `sample` is in the selection
    (the script used `grep -w`, which also matched an ID occurring inside
    another field; exact matching on the sample column is the intent)
  * ExomeDepth panel of normals: NovaSeq X if the first unit's machine is
    @LH00338, otherwise NextSeq
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

NOVASEQ_X_MACHINE = "@LH00338"

RUNS = {
    "twist_comprehensive": {
        "stem": "comprehensive",       # samples_comprehensive.tsv, as before
        "select": lambda line: "comprehensive" in line,
        "configfiles": ["config/config_twist_comp.yaml"],
        "after": [
            ["results/multiqc_DNA.html", "results/multiqc_report_comprehensive.html"],
            ["results/peddy.html", "results/peddy_comprehensive.html"],
        ],
    },
    "twist2.0": {
        "stem": "twist2.0",
        "select": lambda line: "comprehensive" not in line,
        "configfiles": None,           # decided from the sequencer, see plan()
        "after": [],
    },
}


def read_table(path: Path) -> tuple[str, list[str]]:
    lines = [line for line in path.read_text().splitlines() if line]
    return lines[0], lines[1:]


def selection(run_dir: Path, run: str) -> tuple[str, list[str], str, list[str]]:
    """Samples and units rows for one run, headers included."""
    s_header, s_rows = read_table(run_dir / "samples.tsv")
    u_header, u_rows = read_table(run_dir / "units.tsv")
    chosen = [row for row in s_rows if RUNS[run]["select"](row)]
    ids = {row.split("\t")[0] for row in chosen}
    sample_col = u_header.split("\t").index("sample")
    units = [row for row in u_rows if row.split("\t")[sample_col] in ids]
    return s_header, chosen, u_header, units


def exomedepth_config(u_header: str, units: list[str]) -> str:
    machine = units[0].split("\t")[u_header.split("\t").index("machine")] if units else ""
    if machine == NOVASEQ_X_MACHINE:
        return "config/config_exomedepth_novaseqX.yaml"
    return "config/config_exomedepth_nextseq.yaml"


def plan(run_dir: Path) -> dict:
    runs = []
    for name, spec in RUNS.items():
        _, samples, u_header, units = selection(run_dir, name)
        if not samples:
            continue
        configfiles = spec["configfiles"] or [exomedepth_config(u_header, units)]
        runs.append({"name": name, "prepare": True, "configfiles": configfiles,
                     "after": spec["after"]})
    return {"runs": runs}


def prepare(run_dir: Path, pipeline_home: Path, run: str) -> None:
    s_header, samples, u_header, units = selection(run_dir, run)
    stem = RUNS[run]["stem"]
    samples_file = run_dir / f"samples_{stem}.tsv"
    units_file = run_dir / f"units_{stem}.tsv"
    samples_file.write_text("\n".join([s_header, *samples]) + "\n")
    units_file.write_text("\n".join([u_header, *units]) + "\n")

    subprocess.run(
        [sys.executable, str(pipeline_home / "scripts" / "extract_samples_info.py"),
         "-s", samples_file.name, "-u", units_file.name,
         "-o", "config/sample_order.tsv", "-r", "config/sample_replacement.tsv"],
        cwd=run_dir, check=True,
    )
    (run_dir / "samples_with_info.tsv").replace(run_dir / "config" / "samples.tsv")
    units_file.replace(run_dir / "config" / "units.tsv")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("command", choices=["plan", "prepare"])
    parser.add_argument("run", nargs="?", choices=list(RUNS))
    parser.add_argument("--run-dir", type=Path, required=True)
    parser.add_argument("--pipeline-home", type=Path, required=True)
    args = parser.parse_args(argv)

    if args.command == "plan":
        print(json.dumps(plan(args.run_dir)))
    else:
        if not args.run:
            parser.error("prepare needs a run name")
        prepare(args.run_dir, args.pipeline_home, args.run)
    return 0


if __name__ == "__main__":
    sys.exit(main())
