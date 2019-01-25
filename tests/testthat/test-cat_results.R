context("cat_results")

test_that("cat_results fails well", {
  expect_error(cat_results(), "argument \"res\" is missing")
  expect_error(cat_results(5), "res must be of class list")
  expect_error(cat_results(mtcars), "res must be of class list")
})
