# workspace 1.1.1

* Defer current_path update on class initialization to avoid default path set to package building path for global out path.

# workspace 1.1.0

* add function `is_workspace_loaded()`
* Default root path is using `workspace.outpath` option value with a functor so it can be updated later, removing the need for package Onload hook.

# workspace 1.0.1

* Default out path is working directory
* Root path can be set using a function

# workspace 1.0.0

* remove dependency to fastmap, use simple env
* Introduce `PathBuilder` class to manage path creation
* rename `load_workspace()` to `launch()`
* rename `add_path_prefix()` to `add_out_path_prefix()`
* add `global_out_path()` to get default path builder

# workspace 0.2.0

* Initial draft (not released)
