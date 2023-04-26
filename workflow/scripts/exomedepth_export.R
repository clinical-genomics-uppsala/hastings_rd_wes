

load(snakemake@input[["exon"]])
message(paste('Loaded data from', snakemake@input[["exon"]], sep = " "))
# load("../../cnv_sv/exomedepth_call/D21-05858_N.RData")

cnv_call_df <- data.frame(
  all.exons@CNV.calls[order(all.exons@CNV.calls$BF, decreasing = TRUE), ]
  )

if (length(all.exons@CNV.calls) > 0) {

  # Create Nexus SV format text file
  nexus <- c("id", "reads.ratio")
  nexus_df <- cnv_call_df[nexus]

  nexus_df$type[nexus_df$reads.ratio > 1] <- "CN Gain"
  nexus_df$type[nexus_df$reads.ratio < 1] <- "CN Loss"
  nexus_df$type[nexus_df$reads.ratio < 0.05] <- "Homozygous Copy Loss"
  nexus_df$reads.ratio <- log2(nexus_df$reads.ratio)

  # Add empty columns
  nexus_df <- cbind(nexus_df, empty_column1 = NA,
                    empty_column2 = NA, empty_column2 = NA)
  new_names <- c("Chromosome Region", "Probe Median",
                 "Event", "Cytoband", "Min Region")
  names(nexus_df) <- new_names

  #reorder columns
  nexus_df <- nexus_df[,
      c("Chromosome Region", "Min Region",	"Event", "Cytoband", "Probe Median")
      ]

  # write.table(nexus_df, file = 'test.txt',
  #             row.names = FALSE, quote = FALSE, sep = "\t", na = "")
  write.table(nexus_df, file = snakemake@output[["nexus_sv"]],
              row.names = FALSE, quote = FALSE, sep = "\t", na = "")

  # AED file
  keep <- c("chromosome", "start", "end", "gene", "nexons", "reads.ratio",
            "type")
  aed_df <- cnv_call_df[keep]
  aed_df$chromosome <- sub("^", "chr", aed_df$chromosome)
  aed_df$colour <- aed_df$type
  aed_df$colour[aed_df$colour == "duplication"] <- "rgb(0,0,255)"
  aed_df$colour[aed_df$colour == "deletion"] <- "rgb(255,0,0)"
  aed_df$type[aed_df$type == "duplication"] <- "copynumber/gain"
  aed_df$type[aed_df$type == "deletion"] <- "copynumber/loss"


  aed_df$new <- NA  # blank column
  new_aed_names <- c("bio:sequence(aed:String)", "bio:start(aed:Integer)",
                "bio:end(aed:Integer)", "aed:name(aed:String)",
                "bio:markerCount(aed:Integer)", "bio:state(aed:Rational)",
                "aed:category(aed:String)", "style:color(aed:Color)",
                "aed:value(aed:String)")
  names(aed_df) <- new_aed_names
  aed_df <- aed_df[, c("bio:sequence(aed:String)", "bio:start(aed:Integer)",
                        "bio:end(aed:Integer)", "aed:name(aed:String)",
                        "aed:value(aed:String)", "bio:markerCount(aed:Integer)",
                        "bio:state(aed:Rational)", "aed:category(aed:String)",
                        "style:color(aed:Color)")]

  header2 <- data.frame("", "", "", "affx:ucscGenomeVersion(aed:String)",
                        "hg38", "", "", "", "",
                        stringsAsFactors = FALSE)

  names(header2) <- c("bio:sequence(aed:String)", "bio:start(aed:Integer)",
                      "bio:end(aed:Integer)", "aed:name(aed:String)",
                      "aed:value(aed:String)", "bio:markerCount(aed:Integer)",
                      "bio:state(aed:Rational)", "aed:category(aed:String)",
                      "style:color(aed:Color)")

  aed_df <- rbind(header2, aed_df)
  header1 <- data.frame("", "", "", "namespace:affx(aed:URI)",
                        "http://affymetrix.com/ontology/", "", "", "", "",
                        stringsAsFactors = FALSE)
  names(header1) <- c("bio:sequence(aed:String)", "bio:start(aed:Integer)",
                      "bio:end(aed:Integer)", "aed:name(aed:String)",
                      "aed:value(aed:String)", "bio:markerCount(aed:Integer)",
                      "bio:state(aed:Rational)", "aed:category(aed:String)",
                      "style:color(aed:Color)")
  aed_df <- rbind(header1, aed_df)

  # write.table(aed_df, file = 'test.aed', row.names = FALSE,
  #             quote = FALSE, sep = "\t")
  write.table(aed_df, file = snakemake@output[["aed"]], row.names = FALSE,
              quote = FALSE, sep = "\t")
} else {
  message("No result found")
  writeLines("Chromosome Region\tMin Region\tEvent\tCytoband\tProbe Median",
             snakemake@output[["nexus_sv"]])
  writeLines("", snakemake@output[["aed"]])
}
