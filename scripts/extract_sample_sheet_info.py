#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import sys


def translate_sex(sex_code):

    if sex_code == "M":
        sex = "male"
    elif sex_code == "K":
        sex = "female"
    elif sex_code == "O":
        sex = "unknown"
    else:
        print('Sex is not specified correctly in the Sample Sheet')
        sys.exit(1)
    return sex


def extract_trio_info(samples, trio_col):
    trio_member_list = []
    trio_id_list = []
    sex_list = []
    for i in trio_col:
        col_list = i.split('_')
        sex = translate_sex(col_list[1])
        sex_list.append(sex)
        trio_info = col_list[2]
        if trio_info == "NA":
            trio_member_list.append("NA")
            trio_id_list.append("NA")
        else:
            trioid = trio_info.split("-")[0]
            trio_id_list.append(trioid)
            trio_member = trio_info.split("-")[1]
            if trio_member == "Foralder" and sex == "female":
                trio_member = "mother"
            elif trio_member == "Foralder" and sex == "male":
                trio_member = "father"
            else:
                trio_member = "proband"
            trio_member_list.append(trio_member)

    trio_df = pd.DataFrame(data={"sample": samples, "sex": sex_list,
                                 "trioid": trio_id_list,
                                 "trio_member": trio_member_list})

    return trio_df


def main():

    # Read in SampleSheet.csv (illumina sample sheet file)
    # sys.argv[1] is path to SampleSheet.csv file
    line_count = 0
    infile = sys.argv[1]
    # find where the Sample info row header is
    with open(infile, 'r') as input: 
        for line in input:
            if line.startswith('Sample_ID'):
                break
            else:
                if line != '\n':
                    line_count += 1

    sample_sheet_df = pd.read_csv(infile, header=line_count, dtype=str).set_index("Sample_ID", drop=False)
    

    # read in files create by hydra-genetics create-input-files
    samples = pd.read_table("samples.tsv", dtype=str)
    units_df = pd.read_table("units.tsv", dtype=str)

    # Add barcode information from SampleSheet.csv to units.tsv

    barcode_list = []
    for row in units_df.itertuples():
        sample = row.sample
        sample_sheet_row = sample_sheet_df[sample_sheet_df['Sample_Name'] == sample]
        barcode = '+'.join([sample_sheet_row.iat[0, 3], sample_sheet_row.iat[0, 5]])
        barcode_list.append(barcode)

    units_df.barcode = barcode_list
    units_df.to_csv('config/units.tsv', sep='\t', index=False)

    # create sample order and replacement files for multiqc
    sample_sheet_df["Sample Order"] = [
        f"sample_{i:03}" for i in range(1, sample_sheet_df.shape[0]+1)]

    sample_replacemen_df = sample_sheet_df[["Sample_ID","Sample Order"]]
    sample_replacemen_df.to_csv(path_or_buf="config/sample_replacement.tsv",
                                sep="\t", index=False, header=False)

    sample_order_df = sample_sheet_df[
        ["Sample Order", "Sample_ID"]].rename(
        columns={"Sample_ID": "Sample Name"})

    sample_order_df.to_csv(
        path_or_buf="config/sample_order.tsv", sep="\t", index=False)

    # add trio info and sex to samples.tsv
    trio_df = extract_trio_info(sample_sheet_df.Sample_ID,
                                sample_sheet_df.Description)

    merged_df = samples.merge(trio_df, on="sample", validate="one_to_one")

    merged_df.to_csv(path_or_buf="config/samples.tsv", sep='\t', index=False)


if __name__ == '__main__':
    main()
