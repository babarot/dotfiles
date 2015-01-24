#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -u
set -e

antigen_dir=${ANTIGEN:-$HOME/.antigen}

# A system that judge if this script is necessary or not
# {{{
is_osx() { [[ "$OSTYPE" =~ ^darwin ]] || return 1; }
is_ubuntu() { [[ "$(cat /etc/issue 2>/dev/null)" =~ Ubuntu ]] || return 1; }
if ! type git >/dev/null 2>&1 || [[ -d $antigen_dir ]]; then
    exit
fi
#}}}

#
# Testing the judgement system
# {{{
if [[ -n ${DEBUG:-} ]]; then echo "$0" && exit 0; fi
#}}}

    echo -n 'Install antigen zsh plugin manager? (y/N) '
    read
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        #[[ -e $antigen_dir ]] && rm -rf "$antigen_dir"
        git clone https://github.com/zsh-users/antigen "$antigen_dir"
    fi

# vim:fdm=marker
