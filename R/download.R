#' TENxBUSData: 10x human and mouse cell mixture datasets in the BUS format
#'
#' This package provides 5 10x datasets in the
#' \href{https://doi.org/10.1093/bioinformatics/btz279}{BUS format},
#' to be downloaded from within R. The files downloaded from this package are
#' sufficient to generate a sparse matrix with package
#' \href{https://github.com/BUStools/BUSpaRse}{BUSpaRse}
#' to be used for downstream analysis with Seurat. Human and mouse transcriptomes
#' from Ensembl version 94 were used to generate the BUS format from FASTQ files.
#' This package server the following purposes: First, to demonstrate the kallisto
#' bus workflow and downstream analyses. Second, for advanced users to experiment
#' with other ways to collapse UMIs mapped to multiple genes and with other ways
#' of barcode correction. The datasets are on \code{ExperimentHub}.
#'
#' @section Datasets:
#' \describe{
#' \item{hgmm100}{100 1:1 Mixture of Fresh Frozen Human (HEK293T) and Mouse
#' (NIH3T3) Cells. The raw data can be found here:
#' \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/2.1.0/hgmm_100}}
#' \item{hgmm1k}{1k 1:1 Mixture of Fresh Frozen Human (HEK293T) and Mouse
#' (NIH3T3) Cells (v3 chemistry). The raw data can be found here:
#' \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.0/hgmm_1k_v3}}
#' \item{pbmc1k}{1k PBMCs from a Healthy Donor (v3 chemistry). The raw data can
#' be found here:
#' \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.0/pbmc_1k_v3}}
#' \item{neuron10k}{10k Brain Cells from an E18 Mouse (v3 chemistry). The raw
#' data can be found here:
#' \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.0/neuron_10k_v3}}
#' \item{retina}{Mouse retina data from publication (SRR8599150).
#' \url{https://www.ncbi.nlm.nih.gov/sra/?term=SRR8599150}}
#' }
#' @docType package
#' @name TENxBUSData
NULL

#' General download function
#'
#' This function will download the 10x datasets, already processed and stored in
#' the BUS format, from \code{ExperimentHub}. This function will decompress the
#' downloaded file and return the directory where the files necessary to
#' construct the sparse matrix with \code{BUSpaRse} are located.
#'
#' The following files will be downloaded:
#'
#' \describe{
#' \item{\code{matrix.ec}}{Text file with 2 columns. The first column is the
#' index of equivalence classes used in BUS files. The second column is the
#' equivalence classes themselves, consisted of sets of transcript indices from
#' the kallisto index.}
#' \item{\code{output.sorted}}{Binary BUS file sorted by barcode, UMI, and
#' equivalence classes. This can be directly parsedd by \code{bustools} to get
#' the gene count matrix.}
#' \item{\code{output.sorted.txt}}{Sorted BUS file in text form. This is to be
#' used with \code{BUSpaRse} to get the gene count matrix.}
#' \item{\code{transcripts.txt}}{Transcripts included in the BUS data, in the
#' same order as in the kallisto index.}}
#'
#' The gzipped file downloaded from `ExperimentHub` will be in a cache directory
#' that can be retrieved by `getExperimentHubOption("CACHE")`. The cache will
#' remain even if the decompressed files in the directory specified when calling
#' this function are deleted. To delete cache, use
#' \code{\link{removeCache}}.
#'
#' @param file_path Character vector of length 1, specifying where to download
#' the data.
#' @param dataset Character, must be one of "hgmm100", "hgmm1k", "pbmc1k",
#' "neuron10k", and "retina".
#' @param force Logical, whether to force redownload if the files are already
#' present. Defaults to \code{FALSE}.
#' @param verbose Whether to display progress of download.
#' @return Character, directory to be used in \code{BUSpaRse}.
#' @importFrom ExperimentHub ExperimentHub getExperimentHubOption
#' @importFrom AnnotationHub query
#' @importFrom BiocGenerics fileName
#' @importFrom utils untar
#' @export
#' @examples
#' TENxBUSData(".", dataset = "hgmm100")
#'
TENxBUSData <- function(file_path, dataset = "hgmm100",
                        force = FALSE, verbose = TRUE) {
  file_path <- normalizePath(file_path, mustWork = TRUE)
  dss <- c("hgmm100", "hgmm1k", "pbmc1k", "neuron10k", "retina")
  if (!dataset %in% dss) {
    stop("The argument dataset should be one of ", paste(dss, collapse = ", "))
  }
  out <- paste0(file_path, "/out_", dataset)
  files_desired <- c("matrix.ec", "output.sorted", "output.sorted.txt",
                     "transcripts.txt")
  files <- list.files(out)
  if (dir.exists(out) && all.equal(files, files_desired) && !force) {
    message(paste("The dataset has already been downloaded. It is located in",
                  out))
    return(out)
  }
  cache_path <- getExperimentHubOption("CACHE")
  ids <- 2648:2652
  names(ids) <- dss
  id <- paste0("EH", ids[dataset])
  eh <- ExperimentHub()
  ds <- query(eh, "TENxBUSData")
  ds[[id, force = force, verbose = verbose]]
  untar(fileName(ds)[id], exdir = file_path)
  cat("The downloaded files are in", out, "\n")
  return(out)
}
