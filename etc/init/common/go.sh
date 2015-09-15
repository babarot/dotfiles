#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# exit with true if you have go command
if has "go"; then
    log_pass "go: already installed"
    exit
fi

case "$(get_os)" in
    # Case of OS X
    osx)
        if has "brew"; then
            if brew install go; then
                log_pass "go: installed successfully"
            else
                log_fail "go: failed to install golang"
                exit 1
            fi
        else
            log_fail "error: require: Homebrew"
            exit 1
        fi
    ;;

    # Case of Linux
    linux)
        uri="https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz"
        tar="${uri##*/}"
        grt="/usr/local/go"
        dir="go"

        # exit with true if you have go command
        if has "go"; then
            log_pass "go: already installed"
            exit
        fi

        if has "wget"; then
            dler="wget"
        elif has "curl"; then
            dler="curl -O"
        else
            log_fail "error: require: wget or curl" 1>&2
            exit 1
        fi

        # Cleaning
        command mv -f "$grt"{,.$$} 2>/dev/null && :
        command mv -f "$tar"{,.$$} 2>/dev/null && :
        command mv -f "$dir"{,.$$} 2>/dev/null && :

        # Downloading
        log_echo "Downloading golang..."
        eval "$dler" "$uri"
        if [ $? -eq 0 -a -f "$tar" ]; then
            log_echo "Unzip $tar ..."
            tar xzf "$tar"
        else
            log_fail "error: failed to download from $uri" 1>&2
            exit 1
        fi

        if [ ! -d "$dir" ]; then
            log_fail "error: failed to expand $dir directory" 1>&2
            exit 1
        fi

        # Installing
        sudo cp -f -v "$dir"/bin/go "${PATH%%:*}"
        sudo mv -f -v "$dir" "$grt"
        sudo rm -f -v "$tar"

        # Result
        if eval "${PATH%%:*}/go version"; then
            log_pass "go: installed successfully"
        else
            log_fail "go: failed to install golang"
            exit 1
        fi
    ;;

    # Other platforms such as BSD are supported
    *)
        log_fail "error: this script is only supported osx and linux"
        exit 1
    ;;
esac
