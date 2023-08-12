#!/usr/bin/env zsh

declare -A -g BIN_REGISTER_CONF=(
  # to get a width of a wide string in the current terminal.
  ['wst']="src/vendor/wst/bin/wst_$(get_OS_symbol)"
)