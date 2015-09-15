#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# If you don't have git or don't find git preserved
# in a directory with the path,
# to install it after the platforms are detected
if ! has "git"; then

    # Install git
    case "$(get_os)" in
        # Case of OS X
        osx)
            if has "brew"; then
                log_echo "Install git with Homebrew"
                brew install git
            elif "port"; then
                log_echo "Install git with MacPorts"
                sudo port install git
            else
                log_fail "error: require: Homebrew or MacPorts"
                exit 1
            fi
            ;;

        # Case of Linux
        linux)
            if has "yum"; then
                log_echo "Install git with Yellowdog Updater Modified"
                sudo yum -y install git
            elif "port"; then
                log_echo "Install git with Advanced Packaging Tool"
                sudo apt-get -y install git
            else
                log_fail "error: require: YUM or APT"
                exit 1
            fi
            ;;

        # Other platforms such as BSD are supported
        *)
            log_fail "error: this script is only supported osx and linux"
            exit 1
            ;;
    esac
fi

log_pass "git: installed successfully"
