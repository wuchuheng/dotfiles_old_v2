#!/usr/bin/env bash

set -e
VERSION=v0.0.45;
DOTFILES_REP="github.com/wuchuheng/dotfiles"
SAVED_DIRECTORY='dotfiles'
TRUE=0;
FALSE=1

##
# print the log in terminal
# @user log <message>
# @return TRUE|FALSE
##
function log() {
  printf  "INFO %s\n" "${@}"
}
##
# check the cli existed or not
# @use cli_exits <cli_name>
# @return TRUE|FALSE
##
function cli_exits() {
  if command -v "$@" >/dev/null 2>&1; then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}

##
# download dotfiles by git
# @use download_by_git
# @return TRUE|FALSE
##
function download_by_git() {
  git clone https://${DOTFILES_REP} ${SAVED_DIRECTORY} "${SAVED_DIRECTORY}"
  git checkout "${VERSION}"
}

##
# download dotfiles by curl
# @use download_by_curl
# @return TRUE|FALSE
##
function download_by_curl() {
  # check unzip or tar exit.
  if ! cli_exits tar && ! cli_exits unzip; then
    return "${FALSE}"
  fi

  if cli_exits tar; then
    local compressedFile="dotfiles-${VERSION}.tar.gz"
    local url="${DOTFILES_REP}/releases/download/v0.0.45/dotfiles-${VERSION}.tar.gz"
    log "Fetch the dotfiles from ${url}"
    curl -o "${compressedFile}" "$url"
    log "Decompress ${compressedFile}"
    tar -zxvf "${compressedFile}"
    rm -rf "${compressedFile}"
  elif cli_exits unzip; then
    local compressedFile="dotfiles-${VERSION}.zip"
    local url="${DOTFILES_REP}/releases/download/v0.0.45/dotfiles-${VERSION}.zip"
    log "Fetch the dotfiles from ${url}"
    curl -o "${compressedFile}" "$url"
    local compressedFile="dotfiles-${VERSION}.zip"
    unzip "${compressedFile}"
    rm -rf "${compressedFile}"
  fi

}


##
# download the dotfiles.
# @user download_dotfiles
# @return TRUE|FALSE
##
function download_dotfiles() {
  # check the dotfiles directory existed or not
  if [ -d "${SAVED_DIRECTORY}" ]; then
    # check the directory is empty.
    if [ "$(ls -A ${SAVED_DIRECTORY})" ]; then
      echo "The dotfiles directory is not empty, please remove it first."
      return "${FALSE}"
    fi
  else
    mkdir "${SAVED_DIRECTORY}"
  fi

  # if git existed, use git to download the dotfiles.
  if cli_exits git; then
    download_by_git
  # else if
  elif cli_exits curl; then
    download_by_curl
  else
    log "Please install git or curl first."
    return "${FALSE}"
  fi
}

download_dotfiles