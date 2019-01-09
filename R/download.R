#' TENxhgmmBUS: 10x human and mouse cell mixture datasets in the BUS format
#'
#' This package provides 1:1 Mixture of Fresh Frozen Human (HEK293T) and Mouse
#' (NIH3T3) Cells datasets from 10x Genomics (v2 chemistry) in the
#' \href{https://www.biorxiv.org/content/early/2018/11/21/472571}{BUS format},
#' to be downloaded from within R. The files downloaded from this package are
#' sufficient to generate a sparse matrix with package
#' \href{https://github.com/BUStools/BUSpaRse}{BUSpaRse}
#' to be used for downstream analysis with Seurat. Both datasets provided are
#' of the version of November 8, 2017.
#'
#' @section Datasets:
#' \describe{
#' \item{hgmm100}{The 100 cell dataset. The raw data can be found here:
#' \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/2.1.0/hgmm_100}}
#' \item{hgmm1k}{The 1000 cell dataset. The raw data can be found here:
#' \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/2.1.0/hgmm_1k}}
#' }
#' @docType package
#' @name TENxhgmmBUS
NULL

#' General download function
#'
#' This function will download the 10x 100 1:1 Mixture of Fresh Frozen Human
#' (HEK293T) and Mouse (NIH3T3) Cells dataset, already processed and stored in
#' the BUS format, from \code{ExperimentHub}. This function will decompress the
#' downloaded file and return the directory where the files necessary to
#' construct the sparse matrix with \code{BUSpaRse} are located.
#'
#' @param file_path Character vector of length 1, specifying where to download
#' the data.
#' @param dataset Character, should be either \code{hgmm100} (for the 100 cell
#' dataset) or \code{hgmm1k} (for the 1k cell dataset).
#' @param force Logical, whether to force redownload if the files are already
#' present. Defaults to \code{FALSE}.
#' @return Character, directory to be used in \code{BUSpaRse}.
#' @importFrom ExperimentHub ExperimentHub getExperimentHubOption
#' @importFrom AnnotationHub query
#' @importFrom utils untar
#' @export
#' @examples
#' download_hgmm(".", dataset = "hgmm100")
#'
download_hgmm <- function(file_path, dataset = "hgmm100", force = FALSE) {
  file_path <- normalizePath(file_path, mustWork = TRUE)
  if (!dataset %in% c("hgmm100", "hgmm1k")) {
    stop("The argument dataset should be either 'hgmm100' or 'hgmm1k'\n")
  }
  out <- paste0(file_path, "/out_", dataset)
  files_desired <- c("matrix.ec", "output.sorted.txt", "transcripts.txt")
  files <- list.files(out)
  if (dir.exists(out) && all.equal(files, files_desired) && !force) {
    message(paste("The dataset has already been downloaded. It is located in",
                  out, "\n"))
    return(out)
  }
  cache_path <- getExperimentHubOption("CACHE")
  id <- ifelse(dataset == "hgmm100", "2113", "2114")
  eh <- ExperimentHub()
  ds <- query(eh, "TENxhgmmBUS")
  ds[[paste0("EH", id), force = force]]
  untar(paste(cache_path, id, sep = "/"), exdir = file_path)
  cat("The downloaded files are in", out, "\n")
  return(out)
}
