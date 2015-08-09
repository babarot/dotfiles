# has_prefix tests whether the string s begins with pre.
function has_prefix(s, pre,        pre_len, s_len) {
    pre_len = length(pre)
    s_len   = length(s)

    return pre_len <= s_len && substr(s, 1, pre_len) == pre
}

# has_suffix tests whether the string s ends with suf.
function has_suffix(s, suf,        suf_len, s_len) {
    suf_len = length(suf)
    s_len   = length(s)

    return suf_len <= s_len && substr(s, s_len - suf_len + 1) == suf
}
