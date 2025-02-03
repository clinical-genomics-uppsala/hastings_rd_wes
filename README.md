# :snake: hydra-genetics/hastings_rd_wes

#### Whole exomes sequencing hg38 hydra pipeline for rare diseases

![Lint](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/lint.yaml/badge.svg?branch=develop)
![Snakefmt](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/snakefmt.yaml/badge.svg?branch=develop)
![snakemake dry run](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/snakemake-dry-run.yaml/badge.svg?branch=develop)
![integration test](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/integration1.yaml/badge.svg?branch=develop)

![pycodestyle](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/pycodestyl.yaml/badge.svg?branch=develop)
![pytest](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/pytest.yaml/badge.svg?branch=develop)

[![License: GPL-3](https://img.shields.io/badge/License-GPL3-yellow.svg)](https://opensource.org/licenses/gpl-3.0.html)


## :speech_balloon: Introduction



## :heavy_exclamation_mark: Dependencies

In order to use this module, the following dependencies are required:

[![hydra-genetics](https://img.shields.io/badge/hydragenetics-v0.9.1-blue)](https://github.com/hydra-genetics/)
[![pandas](https://img.shields.io/badge/pandas-1.3.1-blue)](https://pandas.pydata.org/)
[![python](https://img.shields.io/badge/python-3.8-blue)
[![snakemake](https://img.shields.io/badge/snakemake-6.8.0-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.0.0-blue)](https://sylabs.io/docs/)

## :school_satchel: Preparations

### Sample data

Input data should be added to [`samples.tsv`](https://github.com/hydra-genetics/hastings_rd_wes/blob/develop/config/samples.tsv)
and [`units.tsv`](https://github.com/hydra-genetics/hastings_rd_wes/blob/develop/config/units.tsv).
The following information need to be added to these files:

| Column Id | Description |
| --- | --- |
| **`samples.tsv`** |
| sample | unique sample/patient id, one per row |
| **`units.tsv`** |
| sample | same sample/patient id as in `samples.tsv` |
| type | data type identifier (one letter), can be one of **T**umor, **N**ormal, **R**NA |
| platform | type of sequencing platform, e.g. `NovaSeq` |
| machine | specific machine id, e.g. NovaSeq instruments have `@Axxxxx` |
| flowcell | identifer of flowcell used |
| lane | flowcell lane number |
| barcode | sequence library barcode/index, connect forward and reverse indices by `+`, e.g. `ATGC+ATGC` |
| fastq1/2 | absolute path to forward and reverse reads |
| adapter | adapter sequences to be trimmed, separated by comma |

## :white_check_mark: Testing

The workflow repository contains a small test dataset `.tests/integration` which can be run like so:

```bash
$ cd .tests/integration
$ snakemake -s ../../Snakefile -j1 --use-singularity
```

## :rocket: Usage

To use this run this pipeline the requirements in `requirements.txt` must be installed. It is most straightforward to install the requirements inside a python virtual environment created with the python [venv module](https://docs.python.org/3/library/venv.html). The `sample.tsv`, `units.tsv`, `resources.yaml`, and `config.yaml` files need to be available in the config directory (or otherwise specified in `config.yaml`). You always need to specify the `config`-file either in the profile yaml file or in the snakemake command. To run the pipeline:

Running the pipeline on CPU:

```bash

module load slurm-drmaa
module load singularity/3.11.0

python3.9 -m venv venv
source venv/bin/acfivate
pip install -r requirements.txt

pipeline_path=/path/to/pipeline

snakemake  --profile ${pipeline_path}/profiles/slurm/ -s ${pipeline_path}/workflow/Snakefile --prioritize prealignment_fastp_pe \
 -p  --configfiles config/config.yaml config/config_exomedepth_nextseq.yaml --config aligner=bwa_cpu snp_caller=deepvariant_cpu

```

To create a reference for exomedepth based on the samples in the samples_ref.tsv and units_ref.tsv a config_reference.yaml must be specified in the command:

```bash

snakemake  --profile ${pipeline_path}/profiles/slurm/ -s ${pipeline_path}/workflow/Snakefile --prioritize prealignment_fastp_pe \
 -p  --configfiles config/config.yaml config/config_reference.yaml --config aligner=bwa_cpu snp_caller=deepvariant_cpu --notemp -n
```

## :speech_balloon: Introduction
This pipeline is created to run on Illumina whole genome sequence data to call germline variants.

## :white_check_mark: Testing

The workflow repository contains a dry run test of the pipeline in  `.tests/integration` which can be run like so:

```bash
$ cd .tests/integration
$ snakemake -n -s ../../workflow/Snakefile --configfile config/config.yaml 
```




