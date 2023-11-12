#!/usr/bin/env bash

set -e
VERSION=v0.0.45;
DOTFILES_REP="github.com/wuchuheng/dotfiles"
SAVED_DIRECTORY='dotfiles'
TRUE=0;
FALSE=1
IS_INSTALLATION_ZSH=${FALSE}
SUPPORTED_OS_LIST=(MacOS CentOS UbuntuOS)

##
# get the os symbol
# @use get_os_symbol
# @print <UbuntuOS|CentOS|MacOS|unknown>
function get_os_symbol() {
  case "$(uname -s)" in
    Linux*)
      if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [ "$ID" = "ubuntu" ]; then
          echo "UbuntuOS"
        elif [ "$ID" = "centos" ]; then
          echo "CentOS"
        else
          echo "$ID" # or you could default to just "Linux"
        fi
      else
        echo "Linux"
      fi
      ;;
    Darwin*)
      echo "MacOS"
      ;;
    *)
      echo "unknown:$(uname -s)"
      ;;
  esac
}

##
# print the log in terminal
# @user log <message>
# @return TRUE|FALSE
##
function log() {
  printf  "\033[0;32mINFO\033[0m %s\n" "${@}"
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
  log "Fetch the repository from ${DOTFILES_REP} by git."
  git clone --recurse-submodules https://${DOTFILES_REP} "${SAVED_DIRECTORY}"
}

##
# check tar and unzip existed or not
# @use check_tar_unzip_exits
# @return TRUE|FALSE
##
function check_tar_unzip_exits() {
  if ! cli_exits tar && ! cli_exits unzip; then
    log "Please install tar or unzip"
    return "${FALSE}"
  fi
}

##
# get the download tar file
# @use get_download_tar_file
# @print <string>
##
function get_download_tar_url() {
    echo "https://${DOTFILES_REP}/releases/download/${VERSION}/dotfiles-${VERSION}.tar.gz"
}

##
# get the tar file name
# @use get_tar_file_name
# @print <string>
##
function get_tar_file_name() {
    echo "dotfiles-${VERSION}.tar.gz"
}

##
# get zip file name
# @use get_zip_file_name
# @print <string>
##
function get_zip_file_name() {
    echo "dotfiles-${VERSION}.zip"
}

##
# get the download zip url
# @use get_download_zip_url
# @print <string>
##
function get_download_zip_url() {
 echo "https://${DOTFILES_REP}/releases/download/${VERSION}/dotfiles-${VERSION}.zip"
}

##
# download dotfiles by curl
# @use download_by_curl
# @return TRUE|FALSE
##
function download_by_curl() {
  # check unzip or tar exit
  check_tar_unzip_exits || return "${FALSE}"

  if cli_exits tar; then
    local compressedFile=$(get_tar_file_name)
    local url=$(get_download_tar_url)
    log "Fetch the dotfiles from ${url} by curl"
    curl -L -o "${compressedFile}" "$url"

    log "decompress ${compressedFile} with tar"
    tar -zxvf "${compressedFile}" -C "${SAVED_DIRECTORY}"

    log "Remove ${compressedFile}"
    rm -rf "${compressedFile}"
  elif cli_exits unzip; then
    local compressedFile="$(get_zip_file_name)"

    local url="$(get_download_zip_url)"
    log "Fetch the dotfiles from ${url} by curl"
    curl -L -o "${compressedFile}" "$url"

    log "decompress ${compressedFile} with unzip"
    unzip "${compressedFile}" -d "${SAVED_DIRECTORY}"

    log "Remove ${compressedFile}"
    rm -rf "${compressedFile}"
  fi
}

##
# wget download a file
# @use wget_file <url> <saved file name>
# @return <boolean>
##
function wget_file() {
  local url="$1"
  local savedFileName="$2"
  log "Fetch the dotfiles from ${url} by wget"
  wget -O "${savedFileName}" "${url}"
  if [[ $? -eq 0 ]]; then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}

##
# download dotfile by wget
# @use download_by_wget
# @return TRUE|FALSE
##
function download_by_wget() {
  check_tar_unzip_exits || return "${FALSE}"

  if cli_exits tar; then
    local compressedFile=$(get_tar_file_name)
    local url=$(get_download_tar_url)
    wget_file "${url}" "${compressedFile}"

    log "decompress ${compressedFile} with tar"
    tar -zxvf "${compressedFile}" -C "${SAVED_DIRECTORY}"

    log "Remove ${compressedFile}"
    rm -rf "${compressedFile}"
  elif cli_exits unzip; then
    local compressedFile="$(get_zip_file_name)"
    local url="$(get_download_zip_url)"

    wget_file "${url}" "${compressedFile}"

    log "decompress ${compressedFile} with unzip"
    unzip "${compressedFile}" -d "${SAVED_DIRECTORY}"

    log "Remove ${compressedFile}"
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
  elif cli_exits wget; then
    download_by_wget
  else
    log "Please install git or curl first."
    return "${FALSE}"
  fi
}

##
# check zsh existed or not
# @use check_existed_zsh_or_install
# @return <boolean>
##
function check_existed_zsh_or_install() {
  if ! cli_exits zsh; then
      local currentOS=$(get_os_symbol)
      # check the current OS was supported or not
      local isSupportedOS=${FALSE}
      for os in "${SUPPORTED_OS_LIST[@]}"; do
          if [[ ${currentOS} == ${os} ]]; then
            isSupportedOS=${TRUE}
            break
          fi
      done
      if [[ ${isSupportedOS} -eq ${FALSE}  ]]; then
        log "Your OS is not supported, please install zsh by yourself."
        exit;
      fi

    log "Install zsh."
    case ${currentOS} in
      MacOS)
        brew install zsh
        ;;
      CentOS)
        yum install -y zsh
        ;;
      UbuntuOS)
        apt install -y tar
        apt install -y zsh
        ;;
    esac
    # check the zsh installation is success or not
    if ! cli_exits zsh; then
      log "Install zsh failed, please install zsh by yourself."
      exit;
    else
      IS_INSTALLATION_ZSH=${TRUE}
    fi

    return "${TRUE}"
  fi
}

download_dotfiles
check_existed_zsh_or_install
cd "${SAVED_DIRECTORY}"
bash src/bootstrap/bash_install_boot.sh