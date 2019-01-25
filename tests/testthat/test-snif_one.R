context("snif_one")

test_that("snif_one fails well", {
  expect_error(snif_one(), "argument \"path\" is missing")
  expect_error(snif_one(5), "path must be of class character")
  expect_error(snif_one("", 5), "secret_string must be of class character")
})

test_that("snif_one basic eg", {
  Sys.setenv(A_KEY = "a8d#d%d7g7g4012a4s2")
  path <- file.path(tempdir(), "foobar")
  dir.create(path)
  
  # no matches
  a <- snif_one(path, Sys.getenv("A_KEY"))
  expect_is(a, "list")
  expect_equal(length(a), 0)

  # add files with the secret
  cat(paste0("foo\nbar\nhello\nworld\n", 
    Sys.getenv("A_KEY"), "\n"), file = file.path(path, "stuff.R"))
  # matches!
  b <- snif_one(path, Sys.getenv("A_KEY"))
  expect_is(b, "list")
  expect_equal(length(b), 1)
  expect_named(b, "stuff.R")
  expect_equal(b[[1]], 5)
})
