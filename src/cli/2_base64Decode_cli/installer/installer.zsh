#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to install base64Decode cli
# @return <boolean>
##
function base64Decode_cli_installer() {
  # if you want to stop the installation, set isInstallBrokenRef to ${TRUE}
  local isInstallBrokenRef=$1

  log INFO "Installing base64Decode CLI cli tool..."

  return "${TRUE}"
}

