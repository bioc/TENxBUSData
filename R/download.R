#' TENxhgmmBUS: 10x human and mouse cell mixture datasets in the BUS format
#'
#' This package provides 1:1 Mixture of Fresh Frozen Human (HEK293T) and Mouse
#' (NIH3T3) Cells datasets from 10x Genomics in the
#' \href{https://www.biorxiv.org/content/early/2018/11/21/472571}{BUS format},
#' to be downloaded from within R. The files downloaded from this package are
#' sufficient to generate a sparse matrix with package
#' \href{https://github.com/BUStools/BUSpaRse}{BUSpaRse}
#' to be used for downstream analysis with Seurat.
#'
#' @docType package
#' @name TENxhgmmBUS
NULL

#' Download the 100 cell dataset to directory
#'
#' This function will download the 10x 100 1:1 Mixture of Fresh Frozen Human
#' (HEK293T) and Mouse (NIH3T3) Cells dataset, already processed and stored in
#' the BUS format, from \code{ExperimentHub}. This function will decompress the
#' downloaded file and return the directory where the files necessary to
#' construct the sparse matrix with \code{BUSpaRse} are located.
#'
#' @param file_path Character vector of length 1, specifying where to download
#' the data.
#' @return Character, directory to be used in \code{BUSpaRse}.
#' @importFrom ExperimentHub ExperimentHub query
#' @importFrom R.utils gunzip
#' @export
download_hgmm100 <- function(file_path) {
  file_path <- normalizePath(file_path, mustWork = TRUE)
  old_path <- getExperimentHubOption("CACHE")
  setExperimentHubOption("CACHE", file_path)
  on.exit(setExperimentHubOption("CACHE", old_path))
  eh <- ExperimentHub()
  ds <- query(eh, "TENxhgmmBUS")
  ds[["EH2113"]]
  gunzip(paste(file_path, "2113", sep = "/"), ext = "")
  paste(file_path, "out_hgmm100", sep = "/")
}
