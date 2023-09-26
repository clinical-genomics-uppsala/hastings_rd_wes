# Overview of the pipeline¶
Here is a brief overview of the entire pipeline. For details see subsections and the [hydra-genetics](https://github.com/hydra-genetics/hydra-genetics) documentation.

1. **Input files**: fastq
2. **Trimming** using fastp
3. **Alignment** using BWA-mem or parabricks fq2bam
4. **SNV and INDEL** using google's deepvariant or parabricks deepvariant
5. **CNV** using exomedepth
6. **QC**  
    6.1 Fastq read quality assessment using FastQC  
    6.2 Mapping related QC from samtools, Picard and Mosdepth  
    6.3 Sample relatedness and sex check using Peddy  
    6.2 MultiQC html report to compile the above QC steps  
