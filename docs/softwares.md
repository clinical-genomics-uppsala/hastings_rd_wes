# Rules specific to Hastings

## create_cov_excel
Python script that creates a gene coverage summary excel file

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__coverage__create_cov_excel#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__coverage__create_cov_excel#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__create_cov_excel#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__create_cov_excel#

---

## [tsv2vcf]
Convert exomedepth calls in csv format to compressed VCF

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__tsv2vcf__tsv2vcf#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__tsv2vcf__tsv2vcf#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__tsv2vcf#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__tsv2vcf#
