#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/load_env.zsh #{get_env}
import @/src/utils/cli_helper.zsh #{get_current_cli_path, get_str_from_ref}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, }

##
# check the cli qjs was installed or not.
# @Use qjs_installation_checker
# @Return <boolean>
##
function qjs_cli_installation_checker() {
  log INFO "Checking if qjs CLI tool was installed or not."
  local envType=$(get_env_type)
  local currentCliPathRef=$(generate_unique_var_name)
  get_current_cli_path "${currentCliPathRef}"
  local currentCliPath=$(get_str_from_ref "${currentCliPathRef}") # /..../src/cli/1_qjs_cli
  local binFile="${currentCliPath}/bin/qjs_$(get_OS_symbol)"
  if [[ -f ${binFile} ]]; then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}
