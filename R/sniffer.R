#' sniffer - pretty print method
#'
#' @export
#' @param dir path to a package root
#' @return named list of all secrets, each either an empty list if none
#' found, or a named list of files and the line numbers secrets found on
#' @examples \dontrun{
#' # dir = tempdir()
#' path <- "/Users/sckott/github/ropensci/taxize"
#' sniffer(dir = path)
#' }
sniffer <- function(dir = ".") {
  res <- sniff_secrets_fixtures(dir)
  cat_results(res)
}
