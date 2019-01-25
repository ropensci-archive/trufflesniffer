# modified from devtools::as.package
as_pkg <- function(x = NULL) {
  if (is_pkg(x)) return(x)
  x <- pkg_file(path = x)
  load_pkg_desc(x)
}
is_pkg <- function(x) inherits(x, "package")
pkg_file <- function(..., path = ".") {
  if (!is.character(path) || length(path) != 1) {
    stop("`path` must be a string.", call. = FALSE)
  }
  path <- sub("/*$", "", normalizePath(path, mustWork = FALSE))
  if (!file.exists(path)) {
    stop("Can't find '", path, "'.", call. = FALSE)
  }
  if (!file.info(path)$isdir) {
    stop("'", path, "' is not a directory.", call. = FALSE)
  }
  while (!file.exists(file.path(path, "DESCRIPTION"))) {
    path <- dirname(path)
    if (identical(path, dirname(path))) {
      stop("Could not find package root.", call. = FALSE)
    }
  }
  file.path(path, ...)
}
load_pkg_desc <- function(path) {
  path_desc <- file.path(path, "DESCRIPTION")
  if (!file.exists(path_desc)) {
    stop("No description at ", path_desc, call. = FALSE)
  }
  desc <- as.list(read.dcf(path_desc)[1, ])
  names(desc) <- tolower(names(desc))
  desc$path <- path
  structure(desc, class = "package")
}
