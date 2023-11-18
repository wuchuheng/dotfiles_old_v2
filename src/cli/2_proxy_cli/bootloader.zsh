#!/usr/bin/env zsh

# This is the entry file for proxy CLI tool
# Write the main logic of the CLI tool here
# Add appropriate comments to explain the purpose and functionality of the file

import @/src/utils/log.zsh #{log}
import ./common_helper.zsh #{get_proxy_bin_file_path}
import @/src/utils/ref_variable_helper.zsh # {assign_str_to_ref, generate_unique_var_name,get_list_from_ref }
import @/src/utils/log.zsh #{log}

function proxy_cli_boot() {
  local binRef=$(generate_unique_var_name)
  get_proxy_bin_file_path "${binRef}"
  local bin=$(get_str_from_ref "${binRef}")

  alias proxy=${bin}
  log INFO "proxy cli loaded"
}

