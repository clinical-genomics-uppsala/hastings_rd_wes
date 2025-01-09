# Welcome to Hastings 
is a pipeline run at [Clinical Genomics Uppsala](https://www.uu.se/en/research/clinical-genomics-uppsala) and is used to call variants from short-read illumina WES data ([TWIST whole exome v.2](https://www.twistbioscience.com/blog/science/WES-Exome-2.0)) from rare disease patients. 
<br />
<br />
You can find the github repository at <a href="https://github.com/clinical-genomics-uppsala/hastings_rd_wes/">https://github.com/clinical-genomics-uppsala/poirot_rd_wgs/</a>
<br />
<br />
This [snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline is built using module system from [Hydra Genetics](https://github.com/hydra-genetics/) to process paired-end `.fastq.gz` files from Illumina whole exome sequencing. 

It is called Hastings, named after Agatha Christie's creation Arthur Hastings who is the side-kick of the famous detective Poirot, which felt appropriate with the pipeline being the side-kick to the whole genome pipeline named [Poirot](https://poirot-rd-wgs.readthedocs.io/en/latest/).



### Hastings uses the following hydra genetics modules:

- [alignment](https://github.com/hydra-genetics/alignment/tree/v0.6.0)
- [annotation](https://github.com/hydra-genetics/annotation/tree/v0.3.0)
- [compression](https://github.com/hydra-genetics/compression/tree/v2.0.0)
- [cnv_sv](https://github.com/hydra-genetics/cnv_sv/tree/v0.5.0)
- [filtering](https://github.com/hydra-genetics/filtering/tree/v0.2.0)
- [misc](https://github.com/hydra-genetics/misc/tree/v0.2.0)
- [parabricks](https://github.com/hydra-genetics/parabricks/tree/v1.1.0)
- [prealignment](https://github.com/hydra-genetics/prealignment/tree/v1.2.0)
- [qc](https://github.com/hydra-genetics/qc/tree/v0.4.1)
- [references](https://github.com/hydra-genetics/references/commit/e71ee62)
- [snv_indels](https://github.com/hydra-genetics/snv_indels/tree/v1.0.0)


## Hydra-genetics

We are an organization/community with the goal of making [snakemake](https://snakemake.readthedocs.io/en/stable/index.html) pipeline development easier, faster, a bit more structured and of higher quality.

We do this by providing [snakemake modules](https://snakemake.readthedocs.io/en/stable/snakefiles/modularization.html#modules) that can be combined to create a complete analysis or included in already existing pipelines. All modules are subjected to extensive testing to make sure that new releases doesn't unexpectedly break existing pipeline or deviate from guidelines and best practices on how to write code.

## Snakemake

Hastings and Hydra-genetics are snakemake bases pipeline/tools. The [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow management system is a tool to create reproducible and scalable data analyses. Workflows are described via a human readable, Python based language. They can be seamlessly scaled to server, cluster, grid and cloud environments, without the need to modify the workflow definition. Finally, Snakemake workflows can entail a description of required software, which will be automatically deployed to any execution environment. 

If Snakemake is new to you a good place to start is doing the [snakemake tutorial](https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html) since this will help you setting Hastings up.
