#!/bin/bash

set -e
set -u
set -o pipefail

pipeline_path="/home/padco251/padraic_testing/hastings_rd_wes"
# source virtual env with requirements.txt installed
source ${pipeline_path}/venv/bin/activate 

module load slurm-drmaa
module load singularity/3.11.0

inbox_path=/projects/inbox/wp3_te/230226-reanalysis/
cp $inbox_path/samples_and_settings.json .

hydra-genetics create-input-files -f -p Illumina -d ${inbox_path}/ -t N  -b 'NNNNNNNNN+NNNNNNNNN' --data-json samples_and_settings.json --data-columns /projects/bin/data/wp3_te_columns.json 

if [ ! -d config ]; then
    mkdir config
fi

cp ${pipeline_path}/config/*.yaml config
cp ${pipeline_path}/config/*.json config

# format the columns in samples.tsv to those required by hastings, produces the samples_with_info.tsv used by the pipeline

# Process Twist 2.0 samples (non-comprehensive)
grep -v comprehensive samples.tsv > samples_twist2.0.tsv
if [ $(wc -l < samples_twist2.0.tsv) -gt 1 ]; then
    echo "Processing Twist 2.0 samples..."
    head -n 1 units.tsv > units_twist2.0.tsv
    grep -v sample samples_twist2.0.tsv | cut -f1 | while read i; do grep -w $i units.tsv >> units_twist2.0.tsv; done
    
    # Copy files to config for this run
    cp samples_twist2.0.tsv config/samples.tsv
    cp units_twist2.0.tsv config/units.tsv
    
    python ${pipeline_path}/scripts/extract_samples_info.py -s samples_twist2.0.tsv -u units_twist2.0.tsv -o config/sample_order.tsv -r config/sample_replacement.tsv

    mv units_twist2.0.tsv units.tsv

    echo "Running Twist 2.0 pipeline..."
    snakemake  --profile ${pipeline_path}/profiles/slurm/ -s ${pipeline_path}/workflow/Snakefile \
        --prioritize prealignment_fastp_pe -p --configfile config/config.yaml \
        --config aligner=bwa_cpu snp_caller=deepvariant_cpu 

    rm config/sample_order.tsv config/sample_replacement.tsv
fi

# Process any Twist Comprehensive samples
head -n 1 samples.tsv > samples_comprehensive.tsv
grep comprehensive samples.tsv >> samples_comprehensive.tsv
if [ $(wc -l < samples_comprehensive.tsv) -gt 1 ]; then
    echo "Processing Comprehensive samples..."
    head -n 1 units.tsv > units_comprehensive.tsv
    grep -v sample samples_comprehensive.tsv | cut -f1 | while read i; do grep -w $i units.tsv >> units_comprehensive.tsv; done
    
    # Copy files to config for this run  
    cp samples_comprehensive.tsv config/samples.tsv
    cp units_comprehensive.tsv config/units.tsv
    
    python ${pipeline_path}/scripts/extract_samples_info.py -s samples_comprehensive.tsv -u units_comprehensive.tsv -o config/sample_order.tsv -r config/sample_replacement.tsv

    mv units_comprehensive.tsv units.tsv

    echo "Running Comprehensive pipeline..."
    snakemake --profile ${pipeline_path}/profiles/slurm/ -s ${pipeline_path}/workflow/Snakefile \
        --prioritize prealignment_fastp_pe -p --configfiles config/config.yaml config/config_twist_comp.yaml \
        --config aligner=bwa_cpu snp_caller=deepvariant_cpu 
    
    rm config/sample_order.tsv config/sample_replacement.tsv
fi






