test_that("workspace_launch", {
  setwd("../ws1/project")
  workspace::launch()
  expect_true(is_workspace_booted())
  expect_true(get0("myMarvelousVariable", ifnotfound = NULL))
})
