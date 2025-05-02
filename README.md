# Workspace package

The workspace package propose a way to organize R project when they share a common configuration (or init process).

The 'workspace' is a root directory containing sub-directories with R scripts (potentially on many sublevel directories).

This packages allows scripts to be run in their own directory (i.e. as R working directory), allowing them to resolve relative path from their location (more natural behaviour)
and to access to the workspace directory and way to access location outside the workspace.

It shares some common features with other packages like
- [rprojroot](https://rprojroot.r-lib.org/)
- [here](https://here.r-lib.org/)

But has a different approach

- The workspace root is identified with an .Rworkspace file (to promote a standard layout)
- The .Rworkspace file can contains one or several files to load at launch, allowing to setup the project at the workspace level (complementary to site/user)

It also provides paths management functions, to allow to refer to locations outside the workspace avoiding to manipulate full path.


## The workspace

The workspace is a directory, with R scripts organized as you want in subdirectories.

To use the workspace allow each script to determine where is the root of the workspace (and get files from files) and to run one or more common setup scripts.

To create a workpace, just create a file named ".Rworkspace" at the root of the project, containing several subdirectories.
It's also possible to use the `init_workspace()` function to do this.

To use the setup feature, put the name of the script to load as a line of ".Rworkspace" file.

Now you can run a script in a subdirectory, to launch the workspace from this script use

```R
workspace::launch()
```

## Path functions

The workspace package proposes a way to handle external path using a path builder.

An global path builder is available (`global_out_path()`) intending to manage the case when you want to refer to a common output directory (for example where all scripts output will be placed).

The principle is to allow scripts to refer to this external location but only known the real location when running, only relative path has to be used in the scripts.

To use it, you have to define where will be this location on the computer running the script, but to make it runnable in another computer (meaning often another location) it's
strongly recommended to define it in a place not managed by a versioning system (like git or subversion).
For example, it can be defined in a user-specific .Rprofile or in a  scripts loaded during workspace setup (but ignored by git/)

```R
options(workspace.outpath="/my/output/path")
```

Once `workspace` package is loaded, you can use `my_path()` to get the path inside the output path

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




