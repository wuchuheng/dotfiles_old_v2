#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}
import @/src/utils/debug_helper.zsh #{assert_not_empty}
import @/src/utils/ref_variable_helper.zsh # { assign_str_to_ref, generate_unique_var_name }
import @/src/utils/os_helper.zsh # {get_os_name}
import @/src/utils/cli_helper.zsh # {get_cli_path_by_name}


##
# get the proxy config path
# @use get_proxy_config_path <cli name> <config path ref>
# @return <boolean>
# @example: get_proxy_config_path 'qjs' 'configPathRef'
##
function get_proxy_config_path() {
  assert_not_empty "$1"
  assert_not_empty "$2"
  local inputCliName="$1"

  local cliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name "${inputCliName}" "${cliPathRef}"
  local cliPath=$(get_str_from_ref "${cliPathRef}")
  local configJson5File="${cliPath}/proxy_config.json5"

  local outputConfigPathRef="$2"
  assign_str_to_ref "${configJson5File}" "${outputConfigPathRef}"

  return $?
}