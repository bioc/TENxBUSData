# TENxBUSData
This package is a thin wrapper to download 5 differrent 10x datasets in the [BUS format](https://doi.org/10.1093/bioinformatics/btz279), from within R. For each dataset, the following files will be downloaded:

1. `output.sorted.txt`: information of transcripts compatible with each UMI for each cell barcode in text format
2. `output.sorted`: binary format of `output.sortedd.txt`
3. `matrix.ec`: transcript equivalence classes in this dataset
4. `transcripts.txt`: transcripts in the transcriptome index, used in [`kallisto`](https://pachterlab.github.io/kallisto/starting) when generating the `bus` format

These files should be sufficient to generate a sparse matrix with the package [BUSpaRse](https://github.com/BUStools/BUSpaRse). See [these notebooks](https://bustools.github.io/BUS_notebooks_R/index.html) for how these files were generated using `kallisto` and `bustools` and how we can generate a sparse matrix from these files. 

The main purpose of this package, and the package `BUSpaRse`, is for advanced users to experiment with different ways to collapse UMIs mapped to multiple genes, to error correct barcode, or to adapt the BUS format for other purposes. The most recent version of `kallisto` and `bustools` should suffice to generate the gene count matrix from FASTQ files. You may also do so with `BUSpaRse`, but it's less efficient than using `bustools`. However, it's easier to tweak code from `BUSpaRse` than that from `bustools` for experimentation because R and Rcpp are easier to work with than pure C++.
