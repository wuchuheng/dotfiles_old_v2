#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to uninstall qjs cli
# @return <boolean>
##
function qjs_cli_uninstallation_provider() {
  log INFO "Uninstalling qjs CLI cli tool..."
  unalias "qjs"

  return "${TRUE}"
}

