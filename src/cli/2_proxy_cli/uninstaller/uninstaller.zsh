#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to uninstall proxy cli
# @return <boolean>
##
function proxy_cli_uninstaller() {
  log INFO "Uninstalling proxy CLI cli tool..."
  unalias "proxy"

  return "${TRUE}"
}
