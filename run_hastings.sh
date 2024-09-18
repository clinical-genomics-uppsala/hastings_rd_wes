#!/bin/bash

set -e
set -u
set -o pipefail

pipeline_path="/home/padco251/padraic_testing/hastings_rd_wes"
# source virtual env with requirements.txt installed
source ${pipeline_path}/venv/bin/activate 

module load slurm-drmaa
module load singularity/3.11.0

inbox_path=/projects/inbox/wp3_te/TE261-2/
cp $inbox_path/samples_and_settings.json .

hydra-genetics create-input-files -f -p Illumina -d ${inbox_path}/ -t N  -b 'NNNNNNNNN+NNNNNNNNN' --data-json samples_and_settings.json --data-columns /projects/bin/data/wp3_wgs_columns.json 

if [ ! -d config ]; then
    mkdir config
fi

cp ${pipeline_path}/config/*.yaml config
cp ${pipeline_path}/config/*.json config

# format the columns in samples.tsv to those required by hastings, produces the samples_with_info.tsv used by the pipeline
python ${pipeline_path}/scripts/extract_samples_info.py -s samples.tsv -u units.tsv -o config/sample_order.tsv -r config/sample_replacement.tsv

mv samples_with_info.tsv config/samples.tsv
cp units.tsv config/units.tsv

snakemake  --profile ${pipeline_path}/profiles/slurm/ -s ${pipeline_path}/workflow/Snakefile --prioritize prealignment_fastp_pe \
 -p  --configfile config/config.yaml --config aligner=bwa_cpu snp_caller=deepvariant_cpu --notemp

