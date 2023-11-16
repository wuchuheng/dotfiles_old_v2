#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to install qjs cli
# @return <boolean>
##
function qjs_cli_installer() {
  # if you want to stop the installation, set isInstallBrokenRef to ${TRUE}
  local isInstallBrokenRef=$1

  log INFO "Installing qjs CLI cli tool..."

  return "${TRUE}"
}

