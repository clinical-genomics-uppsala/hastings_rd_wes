# Steps in Hastings
To go into details of the pipeline we dived the pipeline into modules similar to Hydra-Genetics module system.

---
## Prealignment
See the [prealignment hydra-genetics module](https://prealignment.readthedocs.io/en/latest/) documentation for more details on the softwares. Default hydra-genetics settings/resources are used if no configuration is specified.

![dag plot](includes/images/prealignment.png){: style="height:30%;width:30%"}

### Pipeline output files
Only temporary intermediate files are created.

### Trimming
Trimming of fastq files is performed by **[fastp](https://github.com/OpenGene/fastp)** v0.20.1.  

---
## Alignment
We use deepvariant for alignment on CPU or with parabricks on GPU. For more information and documentation on the softwares used in the alignment steps see [Parabricks hydra-genetics module]()/[github](https://github.com/hydra-genetics/parabricks/tree/v1.1.0) for GPU 
or [Alignment hydra-genetics module](https://alignment.readthedocs.io/en/latest/)/[github](https://github.com/hydra-genetics/alignment/tree/v0.4.0) for CPU.

![dag plot](includes/images/alignment.png){: style="height:100%;width:100%"}

### Pipeline output files:

* `results/{sample}/{sample}_{type}.bam`
* `results/{sample}/{sample}_{type}.bam.bai`

### Alignment with BWA-mem
Alignment of fastq files into bam files is performed by **[bwa-mem](https://github.com/lh3/bwa)** v0.7.17 using the trimmed fastq files. This make it possible to speed up alignent by utlizing parallization and also make it possible to analyze qc for lanes separately. Bamfile are then directly sorted by **[samtools sort](http://www.htslib.org/doc/samtools-sort.html)** v1.15.

#### Read groups
Bam file read groups are set according to sequencing information in the `units.tsv` file.
The @RG read tag is set using the following options defined in the hydra-genetics bwa rule:
```
-R '@RG\tID:{ID}\tSM:{SM}\tPL:{PL}\tPU:{PU}\tLB:{LB}' -v 1
```
where the individual read groups are defined below:

| **RG tag** | **Value** |
|-------------|-|
| ID | sample_type.lane.barcode |
| SM | sample_type |
| PL | platform |
| PU | flowcell.lane.barcode |
| LB | sample_type |

### Bam splitting
The bam files are split into chromosome files for faster performance in downstream analysis. Split files are used by markduplicates and SNV/INDEL calling. Splitting is performed by **[samtools view](http://www.htslib.org/doc/samtools-view.html)** v1.15.

### Mark duplicates
Flagging duplicated reads are performed on individual chromosome bam files by **[picard MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates)** v2.25.4.

### Merging
Merging of deduplicated bam files belonging to the same sample are performed by **[samtools merge](http://www.htslib.org/doc/samtools-merge.html)** v1.15.

### Sorting
Merged bamfile are sorted by **[samtools sort](http://www.htslib.org/doc/samtools-sort.html)** v1.15.

### Bam indexing
Bamfile indexing is performed by **[samtools index](http://www.htslib.org/doc/samtools-index.html)** v1.15.

---
## SNV indels
SNV and indels are called using the [SNV_indels module](https://github.com/hydra-genetics/snv_indels/tree/v0.3.0) and is annotated using the [Annotation module](https://github.com/hydra-genetics/annotation/tree/v0.3.0).

![dag plot](includes/images/snv_indels.png){: style="height:100%;width:100%"}

### Pipeline output files

* `Results/{sample}_{sequenceid}/{sample}_{sequenceid}.vcf.gz`
* `Results/{sample}_{sequenceid}/{sample}_{sequenceid}.merged.genome.vcf.gz`

### SNV calling
Variants are called using [**GATKs Haplotypecaller** v4.2.2.0](https://gatk.broadinstitute.org/hc/en-us/articles/360037225632-HaplotypeCaller) per chromosome to speed up the analysis. Haplotypecaller runs twice, once for standard `vcf` and once for `genome.vcf` with the extra parameter `-ERC GVCF`. Both files are then merged using **[bcftools concat](https://samtools.github.io/bcftools/bcftools.html#concat)** v1.15, the AF field is also added to the `INFO` column in the vcf:s using the `fix_af.py` from the snv_indel module.

### Normalizing
The standard vcf files is then decomposed with **[vt decompose**](https://genome.sph.umich.edu/wiki/Vt#Decompose) followed by [**vt decompose_blocksub**](https://genome.sph.umich.edu/wiki/Vt#Decompose_biallelic_block_substitutions) v2015.11.10. The vcf files are then normalized by [**vt normalize**](https://genome.sph.umich.edu/wiki/Vt#Normalization) v2015.11.10.

### Annotation
Both the normalized standard VCF files and the genome vcf files are then annotated using **[VEP](https://www.ensembl.org/info/docs/tools/vep/index.html)** v109. Vep is run with the extra parameters `--assembly GRCh38 --check_existing --pick --variant_class --everything`.

See the [annotation hydra-genetics module](https://annotation.readthedocs.io/en/latest/) for additional information.

---
## CNV
CNVs are called using the [Hydra-Genetics CNV_SV module](https://github.com/hydra-genetics/cnv_sv/tree/78f270c).
<br />

![dag plot](includes/images/cnv_sv.png){: style="height:60%;width:60%"}

### Pipeline output files

* `Results/{sample}_{sequenceid}/{sample}_{sequenceid}_exomedepth_SV.txt`
* `Results/{sample}_{sequenceid}/{sample}_{sequenceid}_exomedepth.aed`

### Exomedepth
To call larger structural variants **[Exomedepth](https://cran.r-project.org/web/packages/ExomeDepth/index.html)** v1.1.15 is used. Exomedepth does **not** use a window approach but evaluates each row in the bedfile as a segment, therefor the bedfile need to be split into appropriate large windows (e.g. using `bedtools makewindows`). Exomedepth also need a `RData` file containing the normal pool, this can be created using the [Marple - references workflow](/running_ref).

---
## QC
For quality control several the [QC-module](https://github.com/hydra-genetics/qc/tree/ca947b1) is used and the results are then summarized/aggregated into a MultiQC-report.

<br />

![dag plot](includes/images/qc.png){: style="height:70%;width:70%"}

### Pipeline output files
* `Results/{sequenceid}_MultiQC.html`

### MultiQC
A MultiQC html report is generated using **[MultiQC](https://github.com/ewels/MultiQC)** v1.11. The report starts with a general statistics table showing the most important QC-values followed by additional QC data and diagrams. The qc data is collected and generated using Fastp, FastQC, samtools, picard and Mosdepth.

The samples in the MultiQC report is renamed and ordered based on the order of the `SampleSheet.csv` to enable easier integration with the wet lab follow-up.


The report is configured based on a MultiQC config file. 

/// details | Expand to view current MultiQC config.yaml
```yaml
{% include "includes/multiqc_config.yaml" %}
```
///


### FastQC
**[FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)** v0.11.9 is run on the raw fastq-files.

### Mosdepth
**[Mosdepth](https://github.com/brentp/mosdepth)** v0.3.2 is used together with a bedfile covering all coding exons (`config[reference][exon_bed]`) and thresholds (`10,20,50`) to calculate coverage.

### Samtools
**[Samtools stats](http://www.htslib.org/doc/samtools-stats.html)** v1.15 is run on BWA-mem aligned and merged bam files over the full bedfile (`config[reference][design_bed]`).

### Picard
**[Picard](https://broadinstitute.github.io/picard/)** v2.25.4 is run on BWA-mem aligned and merged bam files collecting a number of metrics. The metrics calculated are listed below:

* **picard CollectAlignmentSummaryMetrics** - using a [fasta reference genome](references.md#reference_fasta) file
* **picard CollectDuplicationMetrics**
* **picard CollectGCBiasMetrics**
* **picard CollectHsMetrics** - using a fasta fasta reference genome file, the coding exon bedfile (`config[reference][exon_bed]`), and with the option COVERAGE_CAP=5000
* **picard CollectInsertSizeMetrics**
* **picard CollectMultipleMetrics** - using a fasta fasta reference genome file, the full bedfile (`config[reference][design_bed]`)
---
