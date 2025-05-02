# Workspace package

The workspace package provides a way to organize R projects when they share a common configuration (or init process).

The 'workspace' is a root directory containing subdirectories with R scripts (potentially on many sublevel directories).

This package allows scripts to be run in their own directory (i.e. as R working directory), allowing them to resolve relative paths from their location (more natural behaviour)
and to access to the workspace directory and way to access location outside the workspace.

It shares some common features with other packages like

- [rprojroot](https://rprojroot.r-lib.org/)
- [here](https://here.r-lib.org/)

But has a slightly different approach

- The workspace root is identified with an .Rworkspace file (to promote a standard layout)
- The .Rworkspace file can contain one or more files to loaded when the workspace is launched, allowing the project to be configured at the workspace level (complementary to site/user)

It also provides paths management functions, to allow reference to locations outside the workspace avoiding to manipulate full path.

## The workspace

The workspace is a directory, in which R scripts are organized as you want in subdirectories (obviously if they are not, no need for it).

Use the workspace allows any script inside it to determine the path of the root of the workspace (and get files from files) and to run one or more common setup scripts automatically. 

To create a workpace, just create a file named ".Rworkspace" at the root of the project, containing several subdirectories.
It's also possible to use the `init_workspace()` function to do this.

To use the setup feature, put the name of the script to be loaded on workspace launch as a line of ".Rworkspace" file (one script by line). Path of these scripts must be **relative to workspace root directory**.

For example, if a "setup.R" file is at the root of the workspace directory, just put in ".Rworkspace"

```
setup.R
```

Now you can run a script in a subdirectory, to launch the workspace from this script use

```R
workspace::launch()
```

The way the package run, the script doesnt need to know about how to find the root or what to load to configure the project because it's not its responsability. It only has to tell the workspace to do the job.

## Path functions

The workspace package provides  a way to handle external paths using a path builder.

There is a global path builder is available (accessible using `global_out_path()`) which is intended to handle the case when you want to refer to a common output directory (e.g. where all script output will be placed).

The principle is to allow scripts to refer to this external location but since the real location is only known when running, only relative paths have to be used in the scripts.

To use it, you have to define where this output location will be on the computer running the script, but to make it runnable in another computer (meaning often another location) it's
strongly recommended that you define it in a place not managed by a version control system (like git or subversion).
For example, it can be defined in a user-specific `.Rprofile` or in a script loaded during workspace setup (but ignored by version control so each installation must provide it's specific content).

```R
# Before the workspace package is loaded (in .Rprofile for example)
options(workspace.outpath="/my/output/path")

# After the package is loaded, the global out path has already been initialized
# You have to use `set_root_out_path()`
# For example in a script loaded by the workspace setup
set_root_out_path("/my/output/path")

```

Once the `workspace` package is loaded, you can use `my_path()` to get the path inside the output path

```R
my_path() # The current output path, -> /my/output/path
my_path("myfile") # -> /my/output/path/myfile
```

To avoid repetition, it's also possible to use suffix in the common output path

```R

init_path("subprojet1") # Common output path is now /my/output/path/subproject1
my_path("myfile") # /my/output/path/subproject1/myfile

init_path("subprojet2") # Common output path is now /my/output/path/subproject2
my_path("myfile") # /my/output/path/subproject2/myfile

```




