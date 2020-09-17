trufflesniffer
===========



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.com/ropensci/trufflesniffer.svg?branch=master)](https://travis-ci.com/ropensci/trufflesniffer)

Scan secrets in r scripts, packages, or projects


Package API:

 - `sniff_one`
 - `sniff_secrets_fixtures`
 - `sniff_secrets_pkg`
 - `sniffer`

## Installation


```r
remotes::install_github("ropensci/trufflesniffer")
```


```r
library("trufflesniffer")
```

## sniff through a directory


```r
Sys.setenv(A_KEY = "a8d#d%d7g7g4012a4s2")
path <- file.path(tempdir(), "foobar")
dir.create(path)
# no matches
sniff_one(path, Sys.getenv("A_KEY"))
#> named list()
# add files with the secret
cat(paste0("foo\nbar\nhello\nworld\n", 
    Sys.getenv("A_KEY"), "\n"), file = file.path(path, "stuff.R"))
# matches!
sniff_one(path, Sys.getenv("A_KEY"))
#> $stuff.R
#> [1] 5
```

## look across package in general

make a fake package


```r
foo <- function(key = NULL) {
  if (is.null(key)) key <- "mysecretkey"
}
package.skeleton(name = "mypkg", list = "foo", path = tempdir())
pkgpath <- file.path(tempdir(), "mypkg")
# check that you have a pkg at mypkg
list.files(pkgpath)
#> [1] "DESCRIPTION"        "man"                "NAMESPACE"         
#> [4] "R"                  "Read-and-delete-me"
```

sniff out any secrets


```r
sniff_secrets_pkg(dir = pkgpath, secrets = c("mysecretkey"))
#> $mysecretkey
#> $mysecretkey$foo.R
#> [1] 3
```



## check in test fixtures

make a fake package with tests and fixtures


```r
foo <- function(key = NULL) {
  if (is.null(key)) key <- "a2s323223asd423adsf4"
}
package.skeleton("herpkg", list = "foo", path = tempdir())
pkgpath <- file.path(tempdir(), "herpkg")
dir.create(file.path(pkgpath, "tests/testthat"), recursive = TRUE)
dir.create(file.path(pkgpath, "tests/fixtures"), recursive = TRUE)
cat("library(vcr)
vcr::vcr_configure('../fixtures', 
  filter_sensitive_data = list('<<mytoken>>' = Sys.getenv('MY_KEY'))
)\n", file = file.path(pkgpath, "tests/testthat/helper-herpkg.R"))
cat("a2s323223asd423adsf4\n", 
  file = file.path(pkgpath, "tests/fixtures/foo.yml"))
# check that you have a pkg at herpkg
list.files(pkgpath)
#> [1] "DESCRIPTION"        "man"                "NAMESPACE"         
#> [4] "R"                  "Read-and-delete-me" "tests"
list.files(file.path(pkgpath, "tests/testthat"))
#> [1] "helper-herpkg.R"
cat(readLines(file.path(pkgpath, "tests/testthat/helper-herpkg.R")),
  sep = "\n")
#> library(vcr)
#> vcr::vcr_configure('../fixtures', 
#>   filter_sensitive_data = list('<<mytoken>>' = Sys.getenv('MY_KEY'))
#> )
list.files(file.path(pkgpath, "tests/fixtures"))
#> [1] "foo.yml"
readLines(file.path(pkgpath, "tests/fixtures/foo.yml"))
#> [1] "a2s323223asd423adsf4"
```

sniff out any secrets


```r
Sys.setenv('MY_KEY' = 'a2s323223asd423adsf4')
sniff_secrets_fixtures(pkgpath)
#> $MY_KEY
#> $MY_KEY$foo.yml
#> [1] 1
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/trufflesniffer/issues).
* License: MIT
* Get citation information for `trufflesniffer` in R doing `citation(package = 'trufflesniffer')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
