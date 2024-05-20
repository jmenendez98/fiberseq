The goal of this repository is to facilitate the readability and accessibility of read-level methylation data in a UCSC Genome Browser hub. This functionality supports any data that includes methylation information encoded as MM/ML tags. `bam` files are converted into `bed12` format using [fibertools-rs](https://github.com/fiberseq/fibertools-rs). This repository provides a solution to convert these `bed12` files into `bigBed` format for hosting in a browser hub. The primary issue addressed is the placement of blocks at the ends of reads by fibertools, which is mandatory. However, an occasional read block entry at the end of the reads results in overlap, causing an error.

### Inputs:

Inputs are generated using [fibertools-rs](https://github.com/fiberseq/fibertools-rs). Specifically `ft extract` ([documentation](https://github.com/fiberseq/fibertools-rs/blob/main/docs/extract.md). The environment for fibertools can be made through conda:   
  &nbsp; `conda install -c conda-forge -c bioconda fibertools-rs`   

### fix_ftextract.sh
Usage: fix_ftextract.sh -i <input_bed> -o <fixed_bed>   

Options:   
 &nbsp; -i <input_bed>: Path to input bed file.   
 &nbsp; -o <fixed_bed>: Output path of fixed bed file.