# last_index returns the index of the last instance of find in string,
# or 0 if find is not present
function last_index(string, find, k, ns, nf) {
    ns = length(string)
    nf = length(find)
    for (k = ns+1-nf; k >= 1; k--) {
        if (substr(string, k, nf) == find) {
            return k
        }
    }
    return 0
}
