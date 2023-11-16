#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/load_env.zsh #{get_env}
import @/src/utils/cli_helper.zsh #{get_current_cli_path, get_str_from_ref}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, get_current_cli_name}
import @/src/utils/helper.zsh #{cli_exits}

##
# check the cli base64Decode was installed or not.
# @Use base64Decode_installation_checker
# @Return <boolean>
##
function base64Decode_cli_installation_checker() {
  log INFO "Checking if base64Decode CLI tool was installed or not."
  local cliNameRef=$(generate_unique_var_name)
  get_current_cli_name "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")
  return "${TRUE}"
}
