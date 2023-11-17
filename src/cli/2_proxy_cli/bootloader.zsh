#!/usr/bin/env zsh

# This is the entry file for proxy CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}

function proxy_cli_boot() {
  alias proxy='echo "hello proxy"'
  log INFO "Loaded proxy cli."
}

