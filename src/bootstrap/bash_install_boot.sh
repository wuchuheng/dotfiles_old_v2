#!/usr/bin/env bash
##
# the bootloader to install the dotfiles.
#
# @Author wuchuheng<root@wuchuheng.com>
# @Date 2023/10/21
##

APP_BASE_PATH=$(pwd)
source "${APP_BASE_PATH}"/src/vendor/dotfile_bash_module/src/lib.sh || exit 1
import ../bash_installer_dependencies/check_zsh_or_install.sh # {check_zsh_or_install}
import ../vendor/dotfile_bash_module/src/utils/load_env.sh # {load_env}

load_env "${APP_BASE_PATH}/.env"

# to install all dependencies before to trigger the install bootloader to install the dotfiles.
check_zsh_or_install; zshOK=$?

if [[ "${zshOK}" -eq "${FALSE}" ]]; then
  log "ERROR" "zsh is not installed, please install zsh first.";
  exit;
fi

# trigger the install bootloader to install the dotfiles.
zsh  -c "${APP_BASE_PATH}/src/bootstrap/zsh_install_boot.zsh"






