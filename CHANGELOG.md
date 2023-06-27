# Changelog

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
