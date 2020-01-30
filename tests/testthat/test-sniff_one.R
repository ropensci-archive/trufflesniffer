context("sniff_one")

test_that("sniff_one fails well", {
  expect_error(sniff_one(), "argument \"path\" is missing")
  expect_error(sniff_one(5), "path must be of class character")
  expect_error(sniff_one("", 5), "secret_string must be of class character")
})

test_that("sniff_one basic eg", {
  Sys.setenv(A_KEY = "a8d#d%d7g7g4012a4s2")
  path <- file.path(tempdir(), "foobar")
  dir.create(path)
  
  # no matches
  a <- sniff_one(path, Sys.getenv("A_KEY"))
  expect_is(a, "list")
  expect_equal(length(a), 0)

  # add files with the secret
  cat(paste0("foo\nbar\nhello\nworld\n", 
    Sys.getenv("A_KEY"), "\n"), file = file.path(path, "stuff.R"))
  # matches!
  b <- sniff_one(path, Sys.getenv("A_KEY"))
  expect_is(b, "list")
  expect_equal(length(b), 1)
  expect_named(b, "stuff.R")
  expect_equal(b[[1]], 5)
})
