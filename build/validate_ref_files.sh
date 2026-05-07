PIPELINE_VERSION="v0.10.0"
PIPELINE_SHORT_NAME="wp3_te"

source hastings_rd_wes_${PIPELINE_VERSION}/venv/bin/activate

REF_FILES=/proj/ngi2024001/nobackup/bin/${PIPELINE_SHORT_NAME}/design_and_ref_files

hydra-genetics --debug references validate -c hastings_rd_wes_${PIPELINE_VERSION}/hastings_rd_wes/config/config.miarka.yaml -v hastings_rd_wes_${PIPELINE_VERSION}/hastings_rd_wes/config/references/design_files.hg38.yaml \
        -v hastings_rd_wes_${PIPELINE_VERSION}/hastings_rd_wes/config/references/references.hg38.yaml -v hastings_rd_wes_${PIPELINE_VERSION}/hastings_rd_wes/config/references/exomdepth_files.hg38.yaml \
        -p $REF_FILES

## inlcude vep if the vep cache was changed, omnitted here to speed things up

#-v poirot_config_${CONFIG_VERSION}/config/references/vep.hg38.yaml

