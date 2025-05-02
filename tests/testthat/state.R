test_that("workspace_state", {
  r = as.integer(runif(1, min=1, max=100000))
  workspace_state(test_workspace_state=r)
  s = workspace_state()
  expect_equal(s[["test_workspace_state"]], r)
})
