# Packaging Hastings for offline environments

The build_conda.sh script packages the pipeline, cofigs, reference files and apptainer files for an offline environment. 

When succesfully run the script will generate four compressed tar archives:

* design_and_ref_files.tar.gz
* hastings_rd_wes_${PIPELINE_VERSION}.tar.gz
* apptainer_cache.tar.gz

The requirments listed in requirements.txt are packaged using conda-pack in a .tar.gz in the hastings_rd_wes_${PIPELINE_VERSION}.tar.gz. The snakemake-wrappers github repo and all hydra-genetics modules required by the pipeline are cloned and packaged in hastings_rd_wes_${PIPELINE_VERSION}.tar.gz.

```bash
export TAG_OR_BRANCH="v0.10.0"
export PIPELINE_NAME="hastings_rd_wes"
export PROFILE_NAME="miarka"
export PYTHON_VERSION="3.9"
export PIPELINE_GITHUB_REPO="git@github.com:clinical-genomics-uppsala/hastings_rd_wes.git"
export APPTAINER_CACHE=/path/to/apptainer/cache
```

Download pipeline files (pipeline repo, hydra-modules, snakemake-wrappers and singularity images)
```bash
bash build_conda.sh --pipeline-only 
```


Download only reference and design files (requires running bash build_conda.sh --pipeline-only to be run first)

```bash
bash build_conda.sh --references-only hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/references/design_files.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/references/exomdepth_files.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/config/references/references.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/references/vep_cache.hg38.yaml
```

Download only gene panels and design files (requires running bash build_conda.sh --pipeline-only to be run first)

```bash
bash build_conda.sh --references-only hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/references/design_files.hg38.yaml
```

Download all files

```bash
bash build_conda.sh --all hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/references/gene_panels.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/references/design_files.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/exomdepth_files.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/config/references/references.hg38.yaml hastings_rd_wes_${TAG_OR_BRANCH}/hastings_rd_wes/config/vep_cache.hg38.yamll
```


## Unpacking on the offline server

```bash
tar -xvf hastings_rd_wes_${PIPELINE_VERSION}.tar.gz
tar -xvf design_and_ref_files.tar.gz
tar -xvf apptainer_cache.tar.gz
```

### Unpack the venv

```bash
cd hastings_rd_wes_${PIPELINE_VERSION}/
mkdir venv && tar zxvf env.tar.gz -C venv/
source venv/bin/activate
conda-unpack 
```

### Validate the reference and design files
````bash
bash validate_ref_files.sh
```

