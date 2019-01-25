#' Scan for secrets in a package's fixtures
#'
#' @export
#' @param dir path to a package root
#' @return named list of all secrets, each either an empty list if none
#' found, or a named list of files and the line numbers secrets found on
#' @examples \dontrun{
#' # dir = tempdir()
#' path <- "/Users/sckott/github/ropensci/taxize"
#' snif_secrets_fixtures(dir = path)
#' }
snif_secrets_fixtures <- function(dir = ".") {
  assert(dir, "character")
  pkg <- as_pkg(dir)
  helper_file <- list.files(file.path(pkg$path, "tests/testthat"), 
    pattern = "helper-", full.names = TRUE)
  if (length(helper_file) == 0) stop("no helper file found")
  pd <- utils::getParseData(parse(helper_file))
  pd <- pd[!pd$token == "expr", ]
  row.names(pd) <- NULL
  z <- which(pd$text == "Sys.getenv")
  keys <- gsub("'", "", vapply(z, function(w) 
    utils::getParseText(pd, w + 2), ""))
  secrets <- as.list(vapply(keys, function(z) Sys.getenv(z), ""))

  # look for secrets
  vcrconfline <- which(pd$text == "vcr_configure")
  str_consts <- which(pd$token == "STR_CONST")
  vcrconf_path <- gsub("\"|'", "", 
    utils::getParseText(pd, str_consts[which(str_consts > vcrconfline)[1]]))
  fixtures_path <- file.path(pkg$path, "tests", basename(vcrconf_path))
  out <- list()
  for (i in seq_along(secrets)) {
    out[[ names(secrets)[i] ]] <- snif_one(fixtures_path, secrets[[i]])
  }
  return(out)
}
