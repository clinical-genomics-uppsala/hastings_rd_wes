#!/usr/bin/env bash
set -e

eval "$(conda shell.bash hook)"

TAG_OR_BRANCH="${TAG_OR_BRANCH:-develop}"

conda create --name hastings_${TAG_OR_BRANCH} python=3.9 -y

conda activate hastings_${TAG_OR_BRANCH}

conda install -c conda-forge pip -y

if [ -d hastings_rd_wes_${TAG_OR_BRANCH} ];
then
    rm -fr hastings_rd_wes_${TAG_OR_BRANCH}
fi

mkdir hastings_rd_wes_${TAG_OR_BRANCH}

git clone --branch ${TAG_OR_BRANCH} https://github.com/genomic-medicine-sweden/hastings_rd_wes.git hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes

pip install -r hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/requirements.txt 

conda deactivate

conda pack -n hastings_rd_wes_${TAG_OR_BRANCH} -o hastings_rd_wes_${TAG_OR_BRANCH}/env.tar.gz

mkdir -p hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics

git clone https://github.com/snakemake/snakemake-wrappers.git hastings_rd_wes_${TAG_OR_BRANCH}/snakemake-wrappers

git clone https://github.com/hydra-genetics/prealignment.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/prealignment
git clone https://github.com/hydra-genetics/alignment.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/alignment
git clone https://github.com/hydra-genetics/snv_indels.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/snv_indels
git clone https://github.com/hydra-genetics/annotation.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/annotation
git clone https://github.com/hydra-genetics/filtering.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/filtering
git clone https://github.com/hydra-genetics/qc.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/qc
git clone https://github.com/hydra-genetics/biomarker.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/biomarker
git clone https://github.com/hydra-genetics/fusions.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/fusions
git clone https://github.com/hydra-genetics/cnv_sv.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/cnv_sv
git clone https://github.com/hydra-genetics/compression.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/compression
git clone https://github.com/hydra-genetics/misc.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/misc
git clone https://github.com/hydra-genetics/reports.git hastings_rd_wes_${TAG_OR_BRANCH}/hydra-genetics/reports

tar -zcvf hastings_rd_wes_${TAG_OR_BRANCH}.tar.gz hastings_rd_wes_${TAG_OR_BRANCH}

if [ -d hastings_rd_wes_${TAG_OR_BRANCH} ];
then
    rm -fr hastings_rd_wes_${TAG_OR_BRANCH}
fi
