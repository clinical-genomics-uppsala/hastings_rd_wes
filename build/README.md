# Packaging Hastings for offline environments

The build_conda.sh script packages the pipeline, cofigs, reference files and apptainer files for an offline environment. 

When succesfully run the script will generate four compressed tar archives:

* design_and_ref_files.tar.gz
* hastings_rd_wes_${PIPELINE_VERSION}.tar.gz
* apptainer_cache.tar.gz

The requirments listed in requirements.txt are packaged using conda-pack in a .tar.gz in the hastings_rd_wes_${PIPELINE_VERSION}.tar.gz. The snakemake-wrappers github repo and all hydra-genetics modules required by the pipeline are cloned and packaged in hastings_rd_wes_${PIPELINE_VERSION}.tar.gz.

```bash
export TAG_OR_BRANCH="v0.8.0"
export PIPELINE_NAME="hastings_rd_wes"
export PROFILE_NAME="miarka"
export PYTHON_VERSION="3.9"
export PIPELINE_GITHUB_REPO="https://github.com/clinical-genomics-uppsala/hastings_rd_wgs.git"

```

Download only pipeline files
```bash
bash build_conda.sh --pipeline-only 
```

Download only config files
```bash
bash build_conda.sh --config-only
```

Download only singularity files
```bash
bash build_conda.sh --containers-only
```

Download only reference and design files

```bash
bash build_conda.sh --references-only hastings_rd_wes_${TAG_OR_BRANCH}/config/references/gene_panels.hg38.yaml  hastings_rd_wes_${TAG_OR_BRANCH}/config/exomdepth_files.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/config/config/references/references.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/config/vep_cache.hg38.yaml
```

Download only gene panels

```bash
bash build_conda.sh --references-only hastings_rd_wes_${TAG_OR_BRANCH}/config/references/gene_panels.hg38.yaml  
```

Download all files

```bash
bash build_conda.sh --all hastings_rd_wes_${TAG_OR_BRANCH}/config/references/gene_panels.hg38.yaml  hastings_rd_wes_${TAG_OR_BRANCH}/config/exomdepth_files.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/config/config/references/references.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/config/vep_cache.hg38.yaml
```