#!/usr/bin/env zsh

# This is the entry file for base64Decode CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}

function base64Decode_cli_boot() {
  alias base64Decode='echo "hello base64Decode"'
  log INFO "Loaded base64Decode cli."
}

