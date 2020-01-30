trufflesniffer
===========



[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.com/ropenscilabs/trufflesniffer.svg?branch=master)](https://travis-ci.com/ropenscilabs/trufflesniffer)

Scan secrets in r scripts, packages, or projects


Package API:

 - `snif_secrets_pkg`
 - `snif_one`
 - `snif_secrets_fixtures`
 - `sniffer`

## Installation


```r
remotes::install_github("ropenscilabs/trufflesniffer")
```


```r
library("trufflesniffer")
```

## snif through a directory


```r
Sys.setenv(A_KEY = "a8d#d%d7g7g4012a4s2")
path <- file.path(tempdir(), "foobar")
dir.create(path)
# no matches
snif_one(path, Sys.getenv("A_KEY"))
#> named list()
# add files with the secret
cat(paste0("foo\nbar\nhello\nworld\n", 
    Sys.getenv("A_KEY"), "\n"), file = file.path(path, "stuff.R"))
# matches!
snif_one(path, Sys.getenv("A_KEY"))
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

snif out any secrets


```r
snif_secrets_pkg(dir = pkgpath, secrets = c("mysecretkey"))
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

snif out any secrets


```r
library(rlang)
Sys.setenv('MY_KEY' = 'a2s323223asd423adsf4')
snif_secrets_fixtures(pkgpath)
#> $MY_KEY
#> $MY_KEY$foo.yml
#> [1] 1
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/trufflesniffer/issues).
* License: MIT
* Get citation information for `trufflesniffer` in R doing `citation(package = 'trufflesniffer')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropenscilabs/trufflesniffer/blob/master/CODE_OF_CONDUCT.md
