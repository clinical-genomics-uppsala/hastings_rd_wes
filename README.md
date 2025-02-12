# Hastings RD WGS
Clinical Genomics Uppsala rare disease pipeline for Twist2.0 whole exome sequence data.

<p align="center">
<a href="https://hastings-rd-wes.readthedocs.io/en/latest/">https://hastings-rd-wes.readthedocs.io/en/latest/</a>
</p>

This ReadMe is only a brief introduction, please refer to ReadTheDocs for the latest documentation and a more detailed description of the pipeline. 

![Lint](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/lint.yaml/badge.svg?branch=develop)
![Snakefmt](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/snakefmt.yaml/badge.svg?branch=develop)
![snakemake dry run](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/snakemake-dry-run.yaml/badge.svg?branch=develop)

![pycodestyle](https://github.com/clinical-genomics-uppsala/hastings_rd_wes/actions/workflows/pycodestyl.yaml/badge.svg?branch=develop)
[![Documentation Status](https://readthedocs.org/projects/hastings-rd-wes/badge/?version=latest)](https://hastings-rd-wes.readthedocs.io/en/latest/?badge=latest)


[![License: GPL-3](https://img.shields.io/badge/License-GPL3-yellow.svg)](https://opensource.org/licenses/gpl-3.0.html)


## :heavy_exclamation_mark: Dependencies

In order to use this module, the following dependencies are required:

[![hydra-genetics](https://img.shields.io/badge/hydragenetics-v0.9.1-blue)](https://github.com/hydra-genetics/)
[![pandas](https://img.shields.io/badge/pandas-1.3.1-blue)](https://pandas.pydata.org/)
[![python](https://img.shields.io/badge/python-3.8-blue)
[![snakemake](https://img.shields.io/badge/snakemake-6.8.0-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.0.0-blue)](https://sylabs.io/docs/)

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
### Exomedepth reference creation
To create a reference for exomedepth based on the samples in the samples_ref.tsv and units_ref.tsv a config_reference.yaml must be specified in the command:

```bash

snakemake  --profile ${pipeline_path}/profiles/slurm/ -s ${pipeline_path}/workflow/Snakefile --prioritize prealignment_fastp_pe \
 -p  --configfiles config/config.yaml config/config_reference.yaml --config aligner=bwa_cpu snp_caller=deepvariant_cpu --notemp -n
```


## :white_check_mark: Testing

The workflow repository contains a dry run test of the pipeline in  `.tests/integration` which can be run like so:

```bash
$ cd .tests/integration
$ snakemake -n -s ../../workflow/Snakefile --configfile config/config.yaml 
```




