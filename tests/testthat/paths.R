library(testthat)
library(workspace)
test_that("path_builder", {

  b = PathBuilder$new("/my/path")
  expect_equal(b$get_root(), "/my/path")

  expect_null(b$get_suffix())

  expect_length(b$get_prefixes(), 0)

  expect_equal(b$path(), "/my/path/")
  expect_equal(b$path("titi"), "/my/path/titi")

  b$set_suffix("toto")
  expect_equal(b$path("titi"), "/my/path/toto/titi")


})
