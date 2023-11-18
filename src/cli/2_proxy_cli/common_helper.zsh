#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}
import @/src/utils/debug_helper.zsh #{assert_not_empty}
import @/src/utils/ref_variable_helper.zsh # { assign_str_to_ref }
import @/src/utils/os_helper.zsh # {get_os_name}

##
# get the cli runtime space.
# @Use get_tmp_runtime_space
# @Echo "<a directory path>"
##
function get_proxy_cli_runtime_space() {
  local cliRuntimeDir="$(getCliRuntimeDirectory)/proxy_cli"
  if [[ ! -d ${cliRuntimeDir} ]]; then
    mkdir -p ${cliRuntimeDir}
  fi

  echo "${cliRuntimeDir}"
}

##
# set key map value.
# @use set_key_map_value_for_tmp <key> <value>
# @Return <boolean>
##
function set_key_map_value_for_proxy_cli() {
  local key="${1}"
  local value=$2
  local cacheSpaceName=$(getCliRuntimeDirectory)/tmp

  setStringValue "${key}" "${value}" "${cacheSpaceName}"

  return $?
}

##
# set key map value with reference.
# @Use set_key_map_value_with_ref_for_tmp <key> <value ref>
# @Return <boolean>
##
function set_key_map_value_with_ref_for_proxy_cli() {
  local key="${1}"
  local valueRef=$2
  local cacheSpaceName=$(getCliRuntimeDirectory)/proxy_cli

  setStringValueWithPointer "${key}" "${valueRef}" "${cacheSpaceName}"

  return $?
}

##
# get value with key for tmp cli
# @Use get_key_map_value_for_tmp <key>
# @Echo <value>
# @Return <boolean>
##
function get_key_map_value_for_proxy_cli() {
  local key="${1}"
  local cacheSpaceName=$(getCliRuntimeDirectory)/proxy_cli

  getStringValue "${key}" "${cacheSpaceName}"
  return $?
}

##
# check the cache key exists or not.
# @Use check_key_map_exists_for_proxy_cli <key>
# @Return <boolean>
##
function check_key_map_exists_for_proxy_cli() {
  local key="${1}"
  local cacheSpaceName=$(getCliRuntimeDirectory)/proxy_cli

  getStringValue "${key}" "${cacheSpaceName}"
  return $?
}

##
# get the proxy bin file path
# @use get_proxy_bin_file_path <output ref>
# @return <boolean>
##
function get_proxy_bin_file_path() {
  local outputRef=$1

  local currentCliPathRef=$(generate_unique_var_name)
  get_current_cli_path "${currentCliPathRef}"
  local currentCliPath=$(get_str_from_ref "${currentCliPathRef}")
  local binPath=${currentCliPath}/bin

  local osNameRef=$(generate_unique_var_name)
  get_os_name "${osNameRef}"
  local osName=$(get_str_from_ref "${osNameRef}")
  local result=''
  case "${osName}" in
    MacOS)
        result="${binPath}/v2ray-macos"
    ;;
    UbuntuOS|CentOS)

    ;;
    *)
      return "${FALSE}"
    ;;
  esac

  if [[ -z ${result} ]]; then
    assert_not_empty
    return "${FALSE}"
  else
    assign_str_to_ref "${result}" "$outputRef"
    return "${TRUE}"
  fi
}

