#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if [ ${EUID:-${UID}} != 0 ]; then
    log_info "${0:-zsh.sh} must be executed as user root."
    log_info "you should run 'su root; chsh -s \$(which zsh)'"
    exit
fi

if ! has "zsh"; then
    if is_osx; then
        if has "brew"; then
            brew install zsh
        elif has "port"; then
            sudo port install zsh-devel
        else
            log_fail "You need Homebrew or MacPorts"
            exit 1
        fi
    elif is_linux; then
        if has "apt-get"; then
            sudo apt-get -y install zsh
        elif has "yum"; then
            sudo yum -y install zsh
        else
            log_fail "You need apt-get or yum"
            exit 1
        fi
    else
        log_fail "supports only mac or linux"
        exit 1
    fi
fi

if ! contains "${SHELL:-}" "zsh"; then
    path="$(which zsh)"
    if [ -z "${path:-}" ]; then
        path="zsh"
    fi

    if [ -f "$path" -a -x "$path" ]; then
        if sudo chsh -s "$path"; then
            echo "[verbose] chsh -s $path"
        else
            log_fail "cannot set '$path' as \$SHELL"
            log_info "Is '$path' described in /etc/shells?"
            log_info "you should run 'chsh -l' now"
            exit 1
        fi
    else
        log_fail "$path: invalid path or something is wrong"
        exit 1
    fi
fi

log_pass "ok: changing SHELL to zsh"
