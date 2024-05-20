#!/bin/bash

# Function to display usage information
usage() {
    echo "Script fixes the output of fibertools-rs extract by removing duplicated methylation blocks at the ends of reads."
    echo "Usage: $0 -i <input_bed> -o <fixed_bed>"
    echo "Options:"
    echo "  -i <input_bed>: Path to input bed file."
    echo "  -o <fixed_bed>: Output path of fixed bed file."
    exit 1
}

# display usage if no arguments given
if [[ $# -eq 0 ]] ; then
    usage
fi

# Parse command-line arguments
while getopts ":i:o:" opt; do
    case $opt in
        i) input_bed="$OPTARG";;
        o) fixed_bed="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2
            usage;;
        :) echo "Option -$OPTARG requires an argument." >&2
            usage;;
    esac
done

# Check if all required arguments are provided
if [[ -z $input_bed || -z $fixed_bed ]]; then
    echo "Error: Missing required arguments." >&2
    usage
fi

awk '
BEGIN { FS=OFS="\t" }
{
    # Split BlockSizes and BlockStarts into arrays
    n = split($11, blockSizes, ",")
    m = split($12, blockStarts, ",")

    # Convert second and third columns to integers
    start = $2
    end = $3

    # Check if there are at least two blocks
    if (n > 1 && m > 1) {
        # Get the second-to-last elements
        second_last_block_size = blockSizes[n-1]
        second_last_block_start = blockStarts[m-1]

        # Calculate the sum
        calculated_end = start + second_last_block_size + second_last_block_start

        # If the calculated end matches the end column, remove the last elements
        if (calculated_end == end) {
            # Decrease BlockCount in the 10th column
            $10 -= 1

            # Remove the last element
            $9 -= 1  # Decrease BlockCount
            $11 = ""; $12 = ""
            for (i = 1; i < n; i++) {
                $11 = $11 (i > 1 ? "," : "") blockSizes[i]
                $12 = $12 (i > 1 ? "," : "") blockStarts[i]
            }
        }
    }
    
    # Print the (possibly modified) line
    print
}' ${input_bed} > ${fixed_bed}