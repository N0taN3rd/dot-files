#!/usr/bin/env bash

aptUpdate() {
  sudo apt update
  sudo apt-fast upgrade
}

aptInstall() {
  sudo apt-fast install "$@"
}

aptAutoRemove() {
  sudo apt autoremove
}

aptAutoClean() {
  sudo apt autoclean
}

upup() {
  local DEEP="$1"
  [ -z "$DEEP" ] && { DEEP=1; }
  for _ in $(seq 1 $DEEP); do
    cd ../ || break
  done
}

alias up="upup"

tarDirs() {
  local dirs
  dirs=$(find . -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
  for d in $dirs; do
    if [[ "$d" != ".git" ]]; then
      tar cvzf "$d".tar.gz "$d"
    fi
  done
}

targz() {
  local tmpFile="${1%/}.tar"
  tar -cvf "${tmpFile}" "${1}" || return 1

  local size
  size=$(stat -c"%s" "${tmpFile}" 2>/dev/null)

  local cmd=""
  if ((size < 52428800)) && hash zopfli 2>/dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2>/dev/null; then
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  echo "Compressing .tar using \`${cmd}\`…"
  "${cmd}" -v "${tmpFile}" || return 1
  [ -f "${tmpFile}" ] && rm "${tmpFile}"
  echo "${tmpFile}.gz created successfully."
}

smallerPDF() {
  local farg="$1"
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${farg/.pdf/-c.pdf}" "$1"
}

gotoDir() {
  echo "Which Direcrory: "
  touch "$PWD/quit.txt"
  local cdDir
  select DIRECTORY in ls -d */; do
    case $DIRECTORY in
    *)
      if [[ "$DIRECTORY" == *quit.txt** ]]; then
        echo "Exiting"
        cdDir="exit"
      else
        cdDir="$DIRECTORY"
        echo "You picked $DIRECTORY ($REPLY)"
      fi
      break
      ;;
    esac
  done
  rm "$PWD/quit.txt"
  if [[ "$cdDir" != "exit" ]]; then
    if [[ -d "$cdDir" ]]; then
      echo "You picked $cdDir"
      cd "$cdDir" || echo "Could not cd into $cdDir"
    else
      echo "Could not cd into $cdDir"
    fi
  fi
}

extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [[ -f $1 ]]; then
      case $1 in
      *.tar.bz2) tar xvjf ./"$1" ;;
      *.tar.gz) tar xvzf ./"$1" ;;
      *.tar.xz) tar xvJf ./"$1" ;;
      *.lzma) unlzma ./"$1" ;;
      *.bz2) bunzip2 ./"$1" ;;
      *.rar) unrar x -ad ./"$1" ;;
      *.gz) gunzip ./"$1" ;;
      *.tar) tar xvf ./"$1" ;;
      *.tbz2) tar xvjf ./"$1" ;;
      *.tgz) tar xvzf ./"$1" ;;
      *.zip) unzip ./"$1" ;;
      *.Z) uncompress ./"$1" ;;
      *.7z) 7z x ./"$1" ;;
      *.xz) unxz ./"$1" ;;
      *.exe) cabextract ./"$1" ;;
      *) echo "extract: '$1' - unknown archive method" ;;
      esac
    else
      echo "$1 - file does not exist"
    fi
  fi
}

installDeb() {
  sudo gdebi "$1"
}

makeScriptRunnable() {
  chmod +x "$1"
}

newFile() {
  touch "$1"
}

newShellScript() {
  newFile "$1"
  makeScriptRunnable "$1"
}

newDir() {
  mkdir --parents "$1"
}

man() {
  env \
    LESS_TERMCAP_mb="$(printf '\e[1;31m')" \
    LESS_TERMCAP_md="$(printf '\e[1;31m')" \
    LESS_TERMCAP_me="$(printf '\e[0m')" \
    LESS_TERMCAP_se="$(printf '\e[0m')" \
    LESS_TERMCAP_so="$(printf '\e[1;44;33m')" \
    LESS_TERMCAP_ue="$(printf '\e[0m')" \
    LESS_TERMCAP_us="$(printf '\e[1;32m')" \
    man "$@"
}

whois() {
  local domain
  domain=$(echo "$1" | awk -F/ '{print $3}') # get domain from URL
  if [[ -z $domain ]]; then
    domain="$1"
  fi
  echo "Getting whois record for: $domain …"

  # avoid recursion
  # this is the best whois server
  # strip extra fluff
  /usr/bin/whois -h whois.internic.net "$domain" | sed '/NOTICE:/q'
}

trim_string() {
  # Usage: trim_string "   example   string    "
  : "${1#"${1%%[![:space:]]*}"}"
  : "${_%"${_##*[![:space:]]}"}"
  printf '%s' "$_"
}

