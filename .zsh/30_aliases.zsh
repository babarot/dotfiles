autoload -Uz zmv
alias zmv='noglob zmv -W'

alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

alias du='du -h'
alias job='jobs -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use plain vim.
alias suvim='vim -N -u NONE -i NONE'

# if (( $+commands[kubectl] )); then
#   alias k=kubectl
# fi

# Global aliases
alias -g L='| less'
alias -g G='| grep'
alias -g X='| xargs'
alias -g N=" >/dev/null 2>&1"
alias -g N1=" >/dev/null"
alias -g N2=" 2>/dev/null"
alias -g VI='| xargs -o vim'
alias -g CSV="| sed 's/,,/, ,/g;s/,,/, ,/g' | column -s, -t"
alias -g H='| head'
alias -g T='| tail'

alias -g CP='| pbcopy'
alias -g CC='| tee /dev/tty | pbcopy'
alias -g P='$(kubectl get pods | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk "{print \$1}")'
alias -g F='| fzf --height 30 --reverse --multi --cycle'

awk_alias2() {
  local -a options fields words
  while (( $#argv > 0 ))
  do
    case "$1" in
      -*)
        options+=("$1")
        ;;
      <->)
        fields+=("$1")
        ;;
      *)
        words+=("$1")
        ;;
    esac
    shift
  done
  if (( $#fields > 0 )) && (( $#words > 0 )); then
    awk '$'$fields[1]' ~ '${(qqq)words[1]}''
  elif (( $#fields > 0 )) && (( $#words == 0 )); then
    awk '{print $'$fields[1]'}'
  fi
}
alias -g A="| awk_alias2"

# list galias
alias galias="alias | command grep -E '^[A-Z]'"
alias yy="fc -ln -1 | tr -d '\n' | pbcopy"

if (( $+commands[iap_curl] )); then
  alias iap='iap_curl $(iap_curl --list | fzf --height 30% --reverse)'
fi

gchange() {
  if ! type gcloud &>/dev/null; then
    echo "gcloud not found" >&2
    return 1
  fi
  gcloud config configurations activate $(gcloud config configurations list | fzf-tmux --reverse --header-lines=1 | awk '{print $1}')
}


alias chrome-insecure="open -a Google\ Chrome --args --disable-web-security --allow-running-insecure-content --user-data-dir=''"
alias week='date +%V'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='xcode-select --install; sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; gem update; gem cleanup'

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"


emptytrash() {
  sudo rm -rfv /Volumes/*/.Trashes
  sudo rm -rfv ~/.Trash
  sudo rm -rfv /private/var/log/asl/*.asl
  sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
}

alias fs="du -hs "
alias kj="killjobs"
killjobs(){
  kill $(jobs | awk '{b=substr($1,2,1); c="%"; print c b}')
}

brew-force-update() {
  brew cleanup -s
  brew update
  for c in $(brew cask list); do
    info=$(brew cask info $c)
    installed_ver=$(echo "$info" | cut -d$'\n' -f1 | tr -d ' ' | cut -d':' -f 2)
    current_ver=$(echo "$info" | cut -d$'\n' -f3 | cut -d' ' -f 1 | rev | cut -d'/' -f 1 | rev)
    if [ "$installed_ver" != "$current_ver" ]; then
        echo "$c is installed '$installed_ver', current is '$current_ver'"
        brew cask reinstall $c
    fi
  done
}
# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# replaced with ohmyzsh extract plugin
# extract () {
#   if [ -f $1 ] ; then
#     case $1 in
#       *.tar.bz2)        tar xjf $1        ;;
#       *.tar.gz)         tar xzf $1        ;;
#       *.bz2)            bunzip2 $1        ;;
#       *.rar)            unrar x $1        ;;
#       *.gz)             gunzip $1         ;;
#       *.tar)            tar xf $1         ;;
#       *.tbz2)           tar xjf $1        ;;
#       *.tgz)            tar xzf $1        ;;
#       *.zip)            unzip $1          ;;
#       *.Z)              uncompress $1     ;;
#       *.7z)             7zr e $1          ;;
#       *)                echo "'$1' cannot be extracted via extract()" ;;
#     esac
#   else
#     echo "'$1' is not a valid file"
#   fi
# }

whatsOnPort () {
  for port in "$@"
  do
    lsof -n -i:"$port" | grep LISTEN;
    sleep 1
  done
}


start-docker(){
  docker-machine start
  eval "$(docker-machine env)"
}

did() {
  dpa | grep $1 | awk '{ print $1 }'
}

dpa() {
  docker ps -a
}

diclean() {
  docker rmi -f $(docker images --filter 'dangling=true' -q --no-trunc)
}

dstart() {
  echo "restarting $1"
  docker restart "$(did $1)" &> /dev/null;
  sleep 1;
  echo "$(dstatus $1)";
}

dstop() {
  docker stop "$(did $1)"
}

dstatus () {
  if [ $# -eq 0 ]; then
    docker ps -a --format 'table {{ .Names }}\t{{ .ID }}\t{{ .Status }}'
  else
    local mystatus="$(docker ps -a | grep $1 | awk '{$3=$4=$5=$6=$12=$13=""; print $0}')";
    local tempstatus="$(echo $mystatus | awk '{print $3}')";
    local is_open=0;
    echo "$mystatus"
    [[ "$tempstatus" == 'Up' ]] && local is_open=1;
    return "$is_open"
  fi
}

dclean() {
  docker rm -v $(docker ps -q -f status=exited)
}

dlogs() {
  dstatus "$1";
  local continue_when="$?";
  local when_count=0;
  if [[ "${@:2}" == "-f" ]]; then
    local last_start=$(date +%s)
    local attempt_num=0
    while [ $when_count -lt 7 ];do
      if [[ true || $* == *--since-restart* ]]; then
        docker logs "$(did $1)" "${@:2}" --since "$last_start";
      else
        docker logs "$(did $1)" "${@:2}";
      fi
      echo "***";
      echo "* Restarting in 5 seconds";
      echo "***";

      sleep 5;
      dstatus "$1";
      if [[ "$?" -ne "0" ]]; then
        when_count=0;
      else
        when_count="$when_count"+1;
      fi
    done

    echo "***";
    echo "* Exiting because $1 is down";
    echo "***";
  else
    docker logs "$(did $1)" "${@:2}"
  fi
}

dnuke() {
  docker rm `docker ps -aq --no-trunc --filter "status=exited"`
  docker rmi `docker images --filter 'dangling=true' -q --no-trunc`
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  docker volume rm $(docker volume ls -q)
  docker container rm $(docker container ls -q)
}

####################
# fs Watch Helpers #
####################

declare -i last_called=0
declare -i throttle_by=5

@throttle() {
  local -i now=$(date +%s)
  if (($now - $last_called >= $throttle_by))
  then
    "$@"
  fi
  last_called=$(date +%s)
}


@debounce() {
  local pid=$$
  if [[ ! -f ~/.executing-$pid ]]
  then
    touch ~/.executing-$pid
    "$@"
    retVal="$?"
    {
      sleep "$throttle_by"
      if [[ -f ~/.on-finish-$pid ]]
      then
        "$@"
        rm -f ~/.on-finish-$pid
      fi
      rm -f ~/.executing-$pid
    } &
    return $retVal
  elif [[ ! -f ~/.on-finish-$pid ]]
  then
    touch ~/.on-finish-$pid
  fi
}

watch() {
  if [[ ! "$(which fswatch)" ]]; then
    echo please install fs watch with
    echo brew install fswatch
    exit 0
  fi
  local localpath="$1"; shift
  local rest="$*"
  echo watching "$localpath"
  fswatch -0 -o --event Updated "$localpath" | xargs -0 -I file zsh -c "@debounce eval $rest";
}

#!/usr/bin/env bash

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# # Use Git’s colored diff when available
# hash git &>/dev/null;
# if [ $? -eq 0 ]; then
# 	function diff() {
# 		git diff --no-index --color-words "$@";
# 	}
# fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}";
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}";
	local ip=$(ipconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript;
	else # pipe
		python -mjson.tool | pygmentize -l javascript;
	fi;
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# UTF-8-encode a string of Unicode symbols
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# # `s` with no arguments opens the current directory in Sublime Text, otherwise
# # opens the given location
# function s() {
# 	if [ $# -eq 0 ]; then
# 		subl .;
# 	else
# 		subl "$@";
# 	fi;
# }

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
	if [ $# -eq 0 ]; then
		vim .;
	else
		vim "$@";
	fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tree() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}
