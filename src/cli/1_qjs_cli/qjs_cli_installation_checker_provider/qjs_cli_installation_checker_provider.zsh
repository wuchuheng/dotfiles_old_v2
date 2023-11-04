#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/load_env.zsh #{get_env}

##
# check the cli qjs was installed or not.
# @Use qjs_installation_checker
# @Return <boolean>
##
function qjs_cli_installation_checker() {
  log INFO "Checking if qjs CLI tool was installed or not."
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
