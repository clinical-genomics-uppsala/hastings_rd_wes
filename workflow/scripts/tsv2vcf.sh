#!/usr/bin/env bash

set -euo pipefail

exec 2> "${snakemake_log[0]}" 

# Input arguments
TSV_FILE="${snakemake_input[tsv]}"
SAMPLE_ID="${snakemake_wildcards[sample]}_${snakemake_wildcards[type]}"
VCF_FILE="cnv_sv/exomedepth_call/${SAMPLE_ID}.unsorted.vcf"
SORTED_VCF_FILE="${snakemake_output[vcf]}"
REF_GENOME="${snakemake_input[ref]}"

echo "Adding header to $VCF_FILE..."
cat <<EOL >$VCF_FILE
##fileformat=VCFv4.2
##source=ExomeDepth
##reference=$REF_GENOME
##ALT=<ID=DEL,Description="Deletion">
##ALT=<ID=DUP,Description="Duplication">
##FILTER=<ID=PASS,Description="All filters passed">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=CN,Number=1,Type=Integer,Description="Copy Number calculated as 2^(READSRATIO), rounded to the nearest integer">
##INFO=<ID=BF,Number=1,Type=Float,Description="Bayes Factor">
##INFO=<ID=END,Number=1,Type=Integer,Description="End position of the variant described in this record">
##INFO=<ID=SVLEN,Number=1,Type=Integer,Description="Difference in length between REF and ALT alleles">
##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">
##INFO=<ID=EXONS,Number=.,Type=Integer,Description="Number of exons affected">
##INFO=<ID=READSEXP,Number=.,Type=Integer,Description="Number of reads expected">
##INFO=<ID=READSOBS,Number=.,Type=Integer,Description="Number of reads observed">
##INFO=<ID=READSRATIO,Number=.,Type=Float,Description="Ratio expected vs. observed">
##contig=<ID=chr1,length=248956422>
##contig=<ID=chr2,length=242193529>
##contig=<ID=chr3,length=198295559>
##contig=<ID=chr4,length=190214555>
##contig=<ID=chr5,length=181538259>
##contig=<ID=chr6,length=170805979>
##contig=<ID=chr7,length=159345973>
##contig=<ID=chr8,length=145138636>
##contig=<ID=chr9,length=138394717>
##contig=<ID=chr10,length=133797422>
##contig=<ID=chr11,length=135086622>
##contig=<ID=chr12,length=133275309>
##contig=<ID=chr13,length=114364328>
##contig=<ID=chr14,length=107043718>
##contig=<ID=chr15,length=101991189>
##contig=<ID=chr16,length=90338345>
##contig=<ID=chr17,length=83257441>
##contig=<ID=chr18,length=80373285>
##contig=<ID=chr19,length=58617616>
##contig=<ID=chr20,length=64444167>
##contig=<ID=chr21,length=46709983>
##contig=<ID=chr22,length=50818468>
##contig=<ID=chrX,length=156040895>
##contig=<ID=chrY,length=57227415>
##contig=<ID=chrM,length=16569>
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	$SAMPLE_ID
EOL

echo "Processing $TSV_FILE into VCF..."
tail -n +2 $TSV_FILE | sed 's/"//g' | awk -F'\t' '
{
    if ($3 ~ /dup/) { svtype = "DUP" }
    else if ($3 ~ /del/) { svtype = "DEL" }
    else { svtype = "UNK" }

    if ($12 > 0.5 && $12 < 1.5) { gt = "0/1" }
    else { gt = "1/1" }

    # Calculate CN = 2*(READSRATIO)
    cn_value = 2*$12

    # Round CN to nearest integer
    rounded_cn = (cn_value >= 0) ? sprintf("%.0f", cn_value) : "."

    info = "END="$6";SVLEN="($6-$5+1)";EXONS="$4";READSEXP="$10";READSOBS="$11";READSRATIO="$12";BF="$9";SVTYPE="svtype
    if ($9 < 0) { $9 = 0 }

    print "chr"$7"\t"$5"\t.\tN\t<"svtype">\t"$9"\tPASS\t"info"\tGT:CN\t"gt":"rounded_cn
}' >>$VCF_FILE

echo "Conversion complete. Data appended to $VCF_FILE"

echo "sorting vcf file"
bcftools sort $VCF_FILE -O v -o $SORTED_VCF_FILE

# clean up
rm $VCF_FILE

