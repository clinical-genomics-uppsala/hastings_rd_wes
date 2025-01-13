# Pipeline overview

## Mapping reads and BAM file processing
When GPUs are available Hastings can be configured to use [Nvidia's Parabricks](https://www.nvidia.com/en-gb/clara/parabricks/) for read mapping using [fq2bam](https://docs.nvidia.com/clara/parabricks/latest/documentation/tooldocs/man_fq2bam.html#man-fq2bam) tool. This tool performs read mapping with a GPU-accelerated version of BWA-mem, sorting and marking of duplicates. See the [alignment hydra-genetics module](https://hydra-genetics-alignment.readthedocs.io/en/latest/) or [parabricks hydra-genetics module](https://github.com/hydra-genetics/parabricks) documentation for more details on the softwares. Default hydra-genetics settings/resources are used if no configuration is specified.

When only CPUs are available Hastings can be configured perform the read mapping, sorting and duplicate marking on CPU.

- read mapping [BWA-MEM](https://github.com/lh3/bwa)
- read sorting [Samtools sort](https://www.htslib.org/doc/samtools-sort.html)
- marking duplicates with [Picard MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates)

## Variant Calling
See the [snv_indels hydra-genetics module](https://hydra-genetics-snv-indels.readthedocs.io/en/latest/) or [parabricks hydra-genetics module](https://github.com/hydra-genetics/parabricks) documentation for more details on the softwares for variant calling, [annotation hydra-genetics module](https://hydra-genetics-annotation.readthedocs.io/en/latest/) for annotation, [filtering hydra-genetics module](https://hydra-genetics-filtering.readthedocs.io/en/latest/) for filtering and  [cnv hydra-genetics module](https://hydra-genetics-snv-indels.readthedocs.io/en/latest/) for more details on the softwares for cnv calling. Default hydra-genetics settings/resources are used if no configuration is specified.

### SNV and INDELs
- [Parabricks DeepVariant](https://docs.nvidia.com/clara/parabricks/latest/documentation/tooldocs/man_deepvariant.html#man-deepvariant) when run on GPU or [Google's DeepVariant](https://github.com/google/deepvariant) when run on CPU
- [Glnexus](https://github.com/dnanexus-rnd/GLnexus)
    - Used to create a multisample VCF file analysed with Peddy.
    - Used for the creation of trio VCF files used for UPD analysis

### CNVs
- CNV callers
    - [Exome depth](https://github.com/vplagnol/ExomeDepth) and hydra genetics documentation [ExomeDepth](https://hydra-genetics-cnv-sv.readthedocs.io/en/latest/softwares/#exomedepth)

### Regions Of Homozygosity
- [AutoMap](https://github.com/mquinodo/AutoMap) and hydra genetics documentation [AutoMap](https://hydra-genetics-cnv-sv.readthedocs.io/en/latest/softwares/#automap)

### UniParental Disomy 
- [upd](https://github.com/bjhall/upd) and hydra genetics documentation [upd](https://hydra-genetics-cnv-sv.readthedocs.io/en/latest/softwares/#upd)

## QC
See the [qc hydra-genetics module](https://hydra-genetics-qc.readthedocs.io/en/latest/) documentation for more details on the softwares for the quality control. Default hydra-genetics settings/resources are used if no configuration is specified.

Hastings produces a MultiQC-report for the entire sequencing run to enable easier QC tracking. The report starts with a general statistics table showing the most important QC-values followed by additional QC data and diagrams. The entire MultiQC html-file is interactive and you can filter, highlight, hide or export data using the ToolBox at the right edge of the report.

- The MultiQC-report contains QC data from the following programs:
    - [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
    - [mosdepth](https://github.com/brentp/mosdepth)
    - [peddy](https://github.com/brentp/peddy)
    - [Picard CollectAlignmentSummaryMetrics](https://broadinstitute.github.io/picard/command-line-overview.html#CollectAlignmentSummaryMetrics)
    - [Picard CollectDuplicateMetrics](https://gatk.broadinstitute.org/hc/en-us/articles/360042915371-CollectDuplicateMetrics-Picard)
    - [Picard CollectHsMetrics](https://broadinstitute.github.io/picard/command-line-overview.html#CollectHsMetrics)
    - [Picard CollectGcBiasMetrics](https://broadinstitute.github.io/picard/command-line-overview.html#CollectGcBiasMetrics)
    - [Picard CollectInsertSizeMetrics](https://broadinstitute.github.io/picard/command-line-overview.html#CollectInsertSizeMetrics)
    - [samtools stats](https://www.htslib.org/doc/samtools-stats.html)
    - [samtools idxstats](https://www.htslib.org/doc/samtools-idxstats.html)
    - [verifybamid2](https://github.com/Griffan/VerifyBamID)

## Coverage for genes and gene panels.
Results written to an excel spreadsheet with a tab for each gene panel.

<br />
