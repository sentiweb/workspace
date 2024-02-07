devtools::load_all("../..")

options("workspace_verbose"=TRUE)

load_workspace()

testValue = get0("myMarvelousVariable", ifnotfound = NULL)
stopifnot(isTRUE(testValue))
