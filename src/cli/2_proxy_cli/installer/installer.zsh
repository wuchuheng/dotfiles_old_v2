#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to install proxy cli
# @return <boolean>
##
function proxy_cli_installer() {
  # if you want to stop the installation, set isInstallBrokenRef to ${TRUE}
  local isInstallBrokenRef=$1

  log INFO "Installing proxy CLI cli tool..."

  return "${TRUE}"
}

