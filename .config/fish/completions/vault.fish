
function __complete_vault
    set -lx COMP_LINE (string join ' ' (commandline -o))
    test (commandline -ct) = ""
    and set COMP_LINE "$COMP_LINE "
    /usr/local/bin/vault
end
complete -c vault -a "(__complete_vault)"

