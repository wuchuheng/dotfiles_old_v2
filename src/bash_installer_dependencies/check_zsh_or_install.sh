#!/usr/bin/env bash

import ../vendor/dotfile_bash_module/src/utils/log.sh # {log}
import ../vendor/dotfile_bash_module/src/utils/cache.sh # {save_cache}

##
# check the zsh is exist or not.
# @Use _check_zsh_exit
# @Return <boolean>
##
function _check_zsh_exit() {
  command_to_check="zsh"

  # Check if the command exists
  if command -v "$command_to_check" &> /dev/null; then
    return ${TRUE}
  else
    return ${FALSE}
  fi
}

##
# install zsh in mac OS
# @Use _install_zsh_in_mac_os
# @Return <boolean>
##
function _install_zsh_in_mac_os() {
  brew install zsh
  if [[ $? -eq ${TRUE} ]]; then
    save_cache "IS_INSTALL_ZSH" "${TRUE}"
  fi
}

##
# check the zsh is exist or install.
# @Use check_zsh_or_install
# @Return <boolean>
##
function check_zsh_or_install() {
  if _check_zsh_exit; then
    log INFO "zsh is existed."
    return "${TRUE}"
  fi
  log INFO "zsh is not exist, install zsh now."
  local OSSymbol=$(get_os_symbol)

  case $OSSymbol in
    # Mac OS
    darwin|darwin_arm64)
      _installZSHINnMacOS
    ;;
    *)
      log ERROR "The current system is not supported.";
      return "${FALSE}"
    ;;
  esac

  return "${TRUE}"
}