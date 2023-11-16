#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}

##
# the provider entry to uninstall base64Decode cli
# @return <boolean>
##
function base64Decode_cli_uninstaller() {
  log INFO "Uninstalling base64Decode CLI cli tool..."
  unalias "base64Decode"

  return "${TRUE}"
}

