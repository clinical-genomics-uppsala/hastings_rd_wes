# Changelog

### [0.5.1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.5.0...v0.5.1) (2024-10-14)


### Bug Fixes

* fix paths to exomedepth refs ([096845d](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/096845db4cde3c7d0baf350ba5463197a5fc055b))

## [0.5.0](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.4.0...v0.5.0) (2024-10-02)


### Features

* add config for the old twist panel ([5d01cef](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/5d01cef7f79c08ad0f70de98bbc8852940744bd1))
* re-instate male and female exomdepth references ([cef44ae](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/cef44ae9a4024747ec93c5c64ad464f74d9ac4b8))
* remove extra symbols from figures in general stats table ([51ade63](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/51ade63a8c42afd5b6c86869df265b34165d98e0))

## [0.4.0](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.3.1...v0.4.0) (2024-09-19)


### Features

* update HS metrics in multiqc report ([3a12cf8](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/3a12cf865c8e1dbd9f10fa10f9c3ea3057f0c51c))
* update multiqc and add software versions ([2d3f36e](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/2d3f36e06f697b1fe49ccf55b1b458a514b21979))

### [0.3.1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.3.0...v0.3.1) (2024-09-18)


### Bug Fixes

* handle incomplete trios in samples.tsv ([05df9cd](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/05df9cd6f0cf3e51090d0069bc511efbf41a229a))
* point to vep container ([63b8917](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/63b89172f09c5c52124c7fc0b3c24896bf998a8e))

## [0.3.0](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.2.1...v0.3.0) (2024-05-24)


### Features

* add peddy results to results folder ([4ad2ee1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/4ad2ee1c83ec133d98c8b31a0d3e5d84a20da197))
* handles cases with more than one trio with the same parents ([c3888d0](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/c3888d0cec0c7b3cebaaa2f0f2d7f2bed7684a52))
* remove crumble rule import ([042ab47](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/042ab47a6b267829ae2eab89b5cb7f63bbaf287d))
* update cnv_sv and prealigment modules ([fe41960](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/fe419601459c82cc048e226b10d775c430ba1a1c))
* update common container ([6a62955](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/6a62955f8c00fd56483b9a2b9f66fee690840abd))
* update hydra version ([9c1a7a5](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/9c1a7a51cf3bdf15dad9a0d33d76bdcfe8c53a84))
* update module versions and remove deeptrio ([5417b07](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/5417b072299661b3b3a4fa45767a2dd73e926550))
* update spring version ([6d4d6d5](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/6d4d6d5904b2699b20a8274e2663692ed3e4ecee))


### Bug Fixes

* correctly creat the sample order file from the fastq path ([ade24a1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/ade24a1d0adf8e0187bdf90b2123d6d629a9df6d))
* don't use the same column names ([a1a184b](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/a1a184bc23e316a8b5962692222544151ef1b58d))
* report depth from design bed file in multiqc ([218fc91](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/218fc915d48caa6d4a06f95f4fa6924b9d9bd2e2))

### [0.2.1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.2.0...v0.2.1) (2023-09-25)


### Bug Fixes

* add all the peddy files needed for full pedddy multiqc report ([edfc961](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/edfc961f9a7430c49e33b6952c4beb123146fdda))
* remove extra source to hydra-env ([95013f1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/95013f10d4ef4deabc92118667026f0fd7c7a4e1))
* skip upd analysis for trios that don't have all three members ([398bf00](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/398bf0093a3b73ca335a91cbeb2627b4f865acc9))

## [0.2.0](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/compare/v0.1.0...v0.2.0) (2023-09-13)


### Features

* add logging to coverage script ([f95c778](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/f95c778c8df9a30da9501fb0042232b70381637e))
* handle cases in the sample sheet where the sex is unknown ([190d0e6](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/190d0e637ce2cda48d4d84377829572c77c039ac))
* remove records with read.ratio = 1 for alissa compatability ([8835595](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/8835595c1ca7513146bb546a1d7a7d78ea25c946))
* Update coverage bed in config.yaml ([3d081d3](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/3d081d3b23ff2c5ef2d8d2e543e46305dd9f41c1))


### Bug Fixes

* add bai, get right column for trio, multiqc order ([49f0b07](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/49f0b0753371e3a2f15d013d9ed90a8917488436))
* don't print index in the units.tsv file ([d38006e](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/d38006e28046b2d7642fb9f4d3b9f7c7c665b282))
* handle overlapping genes in create_excel.py ([9d34581](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/9d34581b7b7b68d238ed4f7ed08e5408e0c6b46f))
* **multiqc:** add all mosdepth files to allow running with --notemp ([a6a6f0c](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/a6a6f0cde314e4d4025396920bd914dfc589d8d7))
* **multiqc:** specify all peddy files as input for notemp runs ([eb23a63](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/eb23a6333f683bee896dae1eecd9690d6c3ec051))
* revert coverage script to e81aa1d ([770cbd4](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/770cbd4fe0e97bddbeb0dcd1f60bf495afb121d5))
* Update multiqc_config_DNA.yaml ([20ad40e](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/20ad40e2db8ca7b45b216b09abebec490fe1a96e))


### Documentation

* Create requirements.txt ([641c5b8](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/641c5b828c69484ef18af5196a163bda3e720fb6))

## 0.1.0 (2023-06-27)


### Features

* add automap ([92e414a](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/92e414aa14728ea41b0b54eaf836e8551cfbdf37))
* add fix_af ([e948efb](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/e948efb6d15081496730d058c15fc643b9416cc9))
* add rule and script to export exomedepth results for alissa ([f3d28ad](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/f3d28adaab01d86eab36f3ba0a3803036dbd9369))
* add rule graph ([2a350c1](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/2a350c101f37c5c333dea3b7a5172fe2fca65807))
* add scripts for sample info extraction and running the pipeline ([3df7497](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/3df7497dd00e0a1042be74bc2147d84e963c2046))
* add set -euo pipefail to run_hastings.sh ([cef3245](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/cef3245234e6de00a12525114a48e4bc43a0a781))
* add slurm drmaa profile ([b26156a](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/b26156a1184220e65cd187a7116f194884af1416))
* change to samtools cram file for the results ([32c3192](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/32c31920d79e0dd501e7c176f21f4535206d2490))
* extract trio, sex and barcode info from SampleSheet.csv ([0c9b87c](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/0c9b87c8f315e0c369d400eee78ed282a7a5ea77))
* update config ([73f6f07](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/73f6f070b755c663bb7ec8dd0e1c5d4fdd99bc71))
* update config ([a499cb0](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/a499cb0ff708a814b542cc487a5f220db655aa2c))
* update gres resources ([bcf380f](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/bcf380f3a08393c428419b8e54e1734552fd7272))
* update modules ([db728ed](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/db728ed5d38d8d5051a9a8f4d7fd2f0156952c71))
* update parabricks ans snv_indels modules ([c6f552f](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/c6f552fad5de0882f8874b58cac3c9f117836a54))
* update snakefile and common for latest exomdepth_call rule ([d60dd90](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/d60dd9007facf4cacd0a3d29da9ff14f95e82b44))
* update the reference genome path ([510da6d](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/510da6dbeb7a36cf79992191ca8ee1bb9d433a1e))
* update to latest parabricks module release ([ecdb27f](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/ecdb27f2542342cca1a59f0ddee6c538aa550ec6))
* update to latest release of compression module ([55fb84d](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/55fb84da9d0bb13630b2d91915136bacba1605f9))
* use bed file with bcftools view on SNV/Indels vcf ([9b9619f](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/9b9619f8167c814f83f62e33617f6a01af4c68cd))


### Bug Fixes

* add bam index files to deeptrio mk input ([9ef1d07](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/9ef1d0707dbe2679632814bd94c283084e5cac30))
* **create_cov_excel:** list all inputs to script in rule ([8fb9ae6](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/8fb9ae6951b6776018f39e54cbdad7c4516508f3))
* handle overlapping genes by sorting by gene name ([c849fe3](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/c849fe3b304adf38559ce072b2bfd165d669c0dd))
* import json and remove unused function ([06d7f04](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/06d7f04747f4c5eff1f974a7fc9fe8872cee5c89))
* set familyid to sample id for  non-trio samples ([3b27f8a](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/3b27f8a4c19c84e0761f17a5ed44b3c0800f79fa))
* set familyid to sample id for  non-trio samples ([a5ba81b](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/a5ba81bfad686cf39367ce620161f4f96eed3b20))
* **Snakefile:** add gvcf_records as output ([cee3730](https://www.github.com/clinical-genomics-uppsala/hastings_rd_wes/commit/cee3730c173ac168870e37b5d67cd8becb429953))
