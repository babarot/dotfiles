# dirname returns all but the last element of pathname, typically the pathname's directory.
function dirname(pathname) {
    if (!sub(/\/[^\/]*\/?$/, "", pathname)) {
        return "."
    }

    if (pathname != "") {
        return pathname
    }

    return "/"
}

# basename returns the last element of pathname.
# use "../string/prefix.awk"
function basename(pathname, suffix) {
    sub(/\/$/, "", pathname)
    if (pathname == "") {
        return "/"
    }

    sub(/^.*\//, "", pathname)

    if (suffix != "" && has_suffix(pathname, suffix)) {
        pathname = substr(pathname, 1, length(pathname) - length(suffix))
    }

    return pathname
}

# isabs returns true if the path is absolute.
# use "../string/prefix.awk"
function isabs(pathname) {
    return length(pathname) > 0 && has_prefix(pathname, "/")
}
