#!/bin/bash

# source virtual env with requirements.txt installed
source ~/hydra-env/bin/activate 

module load singularity/3.7.1
module load slurm-drmaa/1.1.3 

sample_sheet=/beegfs-storage/projects/wp3/nobackup/TWIST/INBOX/TE150-2_230228/230228_NDX550925_RUO_0094_AHKYLHBGXN/SampleSheet.csv 
fastq_dir=/beegfs-storage/projects/wp3/nobackup/TWIST/INBOX/TE150-2_230228/230228_NDX550925_RUO_0094_AHKYLHBGXN/Alignment_1/dummy/Fastq/

## barcodes not currently in the Nextseq fastq headers, so use Ns 
hydra-genetics create-input-files -d ${fastq_dir} -t N --tc 0  -b 'NNNNNNNNN+NNNNNNNNN' -f

python extract_sample_sheet_info.py ${sample_sheet} # adds barcodes from SampleSheet to units.tsv, and trio info to samples.sv

snakemake  --profile profiles/slurm/ --configfile config/config.yaml -p -n