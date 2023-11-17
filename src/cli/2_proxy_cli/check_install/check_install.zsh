#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/load_env.zsh #{get_env}
import @/src/utils/cli_helper.zsh #{get_current_cli_path, get_str_from_ref}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, }

##
# check the cli proxy was installed or not.
# @Use proxy_installation_checker
# @Return <boolean>
##
function proxy_cli_installation_checker() {
  log DEBUG "Checking if proxy CLI tool was installed or not."
  local currentCliPathRef=$(generate_unique_var_name)
  get_current_cli_path "${currentCliPathRef}"
  local currentCliPath=$(get_str_from_ref "") # /..../src/cli/proxy
  local envType=$(get_env_type)
  case $envType in
      prod)
        return "${TRUE}"
      ;;
      install)
        return "${FALSE}"
      ;;
      uninstall)
        return "${TRUE}"
      ;;
      *)
        return "${TRUE}"
      ;;
  esac
}
