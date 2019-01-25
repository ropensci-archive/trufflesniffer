#' scan one secret string across many paths
#' 
#' @export
#' @param path (character) path to fixtures directory. required
#' @param secret_string (character) a character string to look for. required
#' @return a named list, with vector of line numbers for where string found;
#' if none found an empty list
#' @examples \dontrun{
#' Sys.setenv(A_KEY = "a8d#d%d7g7g4012a4s2")
#' path <- file.path(tempdir(), "foobar")
#' dir.create(path)
#' # no matches
#' snif_one(path, Sys.getenv("A_KEY"))
#' # add files with the secret
#' cat(paste0("foo\nbar\nhello\nworld\n", 
#'   Sys.getenv("A_KEY"), "\n"), file = file.path(path, "stuff.R"))
#' # matches!
#' snif_one(path, Sys.getenv("A_KEY"))
#' }
snif_one <- function(path, secret_string) {
  assert(path, "character")
  assert(secret_string, "character")
  stopifnot(nzchar(secret_string))

  all_paths <- list.files(path, full.names = TRUE)
  Filter(length, stats::setNames(
    lapply(all_paths, function(w) grep(secret_string, readLines(w))),
    basename(all_paths)
  ))
}
