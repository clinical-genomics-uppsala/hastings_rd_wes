#!/usr/bin/env bash
# To run script:
# bash /projects/wp3/nobackup/TWIST/Bin/Hastings/start_TE_marvin.sh fastq/ TE170

set -euo pipefail

module load slurm-drmaa/1.1.3
module load singularity/3.7.1

hastingsFolder=/beegfs-storage/projects/wp3/nobackup/TWIST/Bin/Hastings
python3.9 -m venv ${hastingsFolder}/hydra_env
source ${hastingsFolder}/hydra_env/bin/activate
pip install -r ${hastingsFolder}/requirements.txt

source /beegfs-storage/projects/wp3/nobackup/TWIST/Bin/Hastings/hydra_env/bin/activate;

fastqFolder=$1
sequencerun=$2    #Sequence ID
startDir=$(pwd)

outbox=$(echo $(echo ${hastingsFolder} | rev | cut -d/ -f3- | rev)/OUTBOX)

# Create outbox and scratch folders
echo 'Creating outbox and scratch folders'
if [ ! -d "/scratch/wp3/TWIST/${sequencerun}/" ]
then
  mkdir /scratch/wp3/TWIST/${sequencerun}/
fi

if [ ! -d "/scratch/wp3/TWIST/${sequencerun}/fastq" ]
then
  mkdir /scratch/wp3/TWIST/${sequencerun}/fastq
fi

if [ ! -d "${outbox}/${sequencerun}/" ]
then
  mkdir ${outbox}/${sequencerun}/
fi

# Cp data to scratch
echo 'Copy to scratch' && \
rsync -ru ${fastqFolder%} /scratch/wp3/TWIST/${sequencerun}/fastq/ && \
rsync -ru SampleSheet.csv /scratch/wp3/TWIST/${sequencerun}/  && \
rsync -ru ${hastingsFolder}/config /scratch/wp3/TWIST/${sequencerun}/  && \

cd /scratch/wp3/TWIST/${sequencerun}/  && \

hydra-genetics create-input-files -d /scratch/wp3/TWIST/${sequencerun} -t N --tc 0  -b 'NNNNNNNNN+NNNNNNNNN' -f && \
python ${hastingsFolder}/extract_sample_sheet_info.py SampleSheet.csv && \

# Start pipeline
snakemake --profile ${hastingsFolder}/profiles/slurm/ -s ${hastingsFolder}/workflow/Snakefile \
--configfile config/config.yaml -p --latency-wait 9 --rerun-incomplete --keep-going --notemp \
&& \

# Copy data back and trigger stackstorm in outbox
echo 'Pipeline done, cp back data and trigger stackstorm' && \
cp /scratch/wp3/TWIST/${sequencerun}/results/multiqc_DNA.html /scratch/wp3/TWIST/${sequencerun}/results/${sequencerun}_multiqc.html && \
rsync -ru /scratch/wp3/TWIST/${sequencerun}/results/* ${outbox}/${sequencerun}/ && \
touch ${outbox}/${sequencerun}/Done.txt && \
rsync -ru /scratch/wp3/TWIST/${sequencerun}/.snakemake ${startDir}/ && \
echo 'All done!'
