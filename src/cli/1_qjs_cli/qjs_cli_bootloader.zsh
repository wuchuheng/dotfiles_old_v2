#!/usr/bin/env zsh

# This is the entry file for qjs CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, get_str_from_ref}
import ./qjs_cli_common_helper.zsh #{get_qjs_bin}

function qjs_cli_boot() {
  local qjsBinRef=$(generate_unique_var_name)
  get_qjs_bin "${qjsBinRef}"
  local qjsBin=$(get_str_from_ref "${qjsBinRef}")
  if [[ -f "${qjsBin}" ]]; then
    alias qjs="${qjsBin}"
    log INFO "Loaded qjs cli."
  else
    log ERROR "Failed to load qjs"
  fi
}

