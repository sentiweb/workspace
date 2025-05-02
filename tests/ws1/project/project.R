devtools::load_all("../..")

options("workspace_verbose"=TRUE)

launch()

testValue = get0("myMarvelousVariable", ifnotfound = NULL)
stopifnot(isTRUE(testValue))
