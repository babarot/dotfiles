#!/bin/bash

function GVim()
{
	if $(echo $OSTYPE | grep -q -E '^darwin'); then
		local gvim_path='/Applications/MacVim.app/Contents/MacOS/Vim'
		if [ -x "$gvim_path" ]; then
			"$gvim_path" -g "$@" >/dev/null 1>&2
		fi
	fi
}

GVim ${@+"$@"}
