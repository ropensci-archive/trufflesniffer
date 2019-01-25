#' Scan for secrets in a package
#'
#' @export
#' @param dir (character) path to a package root. required
#' @param secrets (character) vector of secrets to look for. required
#' @return named list of all secrets, each either an empty list if none
#' found, or a named list of files and the line numbers secrets found on
#' @examples \dontrun{
#' pkgpath = tempdir()
#' snif_secrets_pkg(dir = pkgpath, secrets = c("mysecretkey"))
#' unlink(pkgpath)
#' }
snif_secrets_pkg <- function(dir = ".", secrets) {
  assert(dir, "character")
  pkg <- as_pkg(dir)
  r_path <- file.path(pkg$path, "R")
  out <- list()
  for (i in seq_along(secrets)) {
    out[[ secrets[i] ]] <- snif_one(r_path, secrets[i])
  }
  return(out)
}
