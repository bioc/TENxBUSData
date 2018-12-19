# TENxhgmmBUS
This package is a thin wrapper to download 1:1 Mixture of Fresh Frozen Human (HEK293T) and Mouse (NIH3T3) Cells datasets from 10x Genomics in the [BUS format](https://www.biorxiv.org/content/early/2018/11/21/472571), from within R. For each dataset, the following files will be downloaded:

1. `output.sorted.txt`: information of transcripts compatible with each UMI for each cell barcode
2. `matrix.ec`: transcript equivalence classes in this dataset
3. `transcripts.txt`: transcripts in the transcriptome index, used in [`kallisto`](https://pachterlab.github.io/kallisto/starting) when generating the `bus` format

These files shoule be sufficient to generate a sparse matrix with the package [BUSpaRse](https://github.com/BUStools/BUSpaRse). See [these notebooks](https://bustools.github.io/BUS_notebooks_R/index.html) for how these files were generated using `kallisto` and `bustools` and how we can generate a sparse matrix from these files. 
