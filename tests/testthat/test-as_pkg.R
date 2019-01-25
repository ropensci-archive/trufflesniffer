context("as_pkg")

test_that("as_pkg fails well", {
  expect_error(as_pkg(), "`path` must be a string")
})

test_that("as_pkg basic eg", {
  pkg_name <- "trufflesniffer"
  pkgpath <- system.file(package = pkg_name)
  a <- as_pkg(pkgpath)
  
  expect_is(a, "package")
  expect_is(unclass(a), "list")
  expect_equal(a$package, pkg_name)
})
