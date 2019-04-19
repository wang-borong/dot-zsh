# Returns whether the given command is executable or aliased.
_has() {
    return $( whence $1 >/dev/null )
}

# Functions which modify the path given a directory, but only if the directory
# exists and is not already in the path.
_prepend_to_path() {
    if [ -d $1 -a -z ${path[(r)$1]} ]; then
        path=($1 $path);
    fi
}

_append_to_path() {
    if [ -d $1 -a -z ${path[(r)$1]} ]; then
        path=($path $1);
    fi
}

_force_prepend_to_path() {
    path=($1 ${(@)path:#$1})
}

_append_paths_if_nonexist() {
    for p in $@; do
        if [[ ! -L $p ]]; then
            _prepend_to_path $p
        fi
    done
}
