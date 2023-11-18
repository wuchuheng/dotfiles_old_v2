#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}
import @/src/utils/ref_variable_helper.zsh #{assign_str_to_ref, generate_unique_var_name, get_str_from_ref}
import @/src/utils/cli_helper.zsh # {get_cli_path_by_name}

##
# get the cli runtime space.
# @Use get_tmp_runtime_space
# @Echo "<a directory path>"
##
function get_qjs_cli_runtime_space() {
  local cliRuntimeDir="$(getCliRuntimeDirectory)/qjs_cli"
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
function set_key_map_value_for_qjs_cli() {
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
function set_key_map_value_with_ref_for_qjs_cli() {
  local key="${1}"
  local valueRef=$2
  local cacheSpaceName=$(getCliRuntimeDirectory)/qjs_cli

  setStringValueWithPointer "${key}" "${valueRef}" "${cacheSpaceName}"

  return $?
}

##
# get value with key for tmp cli
# @Use get_key_map_value_for_tmp <key>
# @Echo <value>
# @Return <boolean>
##
function get_key_map_value_for_qjs_cli() {
  local key="${1}"
  local cacheSpaceName=$(getCliRuntimeDirectory)/qjs_cli

  getStringValue "${key}" "${cacheSpaceName}"
  return $?
}

##
# check the cache key exists or not.
# @Use check_key_map_exists_for_qjs_cli <key>
# @Return <boolean>
##
function check_key_map_exists_for_qjs_cli() {
  local key="${1}"
  local cacheSpaceName=$(getCliRuntimeDirectory)/qjs_cli

  getStringValue "${key}" "${cacheSpaceName}"
  return $?
}

##
# get the quickjs bin file
# @use get_qjs_bin <string ref>
# @param $1 the bin file path
# @return <boolean>
##
function get_qjs_bin() {
  local qjsBinRef=$1
  local cliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name qjs "${cliPathRef}"
  local cliPath=$(get_str_from_ref "${cliPathRef}")

  local qjsBin=${cliPath}/bin/qjs_$(uname -s)_$(uname -m)
  assign_str_to_ref "${qjsBin}" "${qjsBinRef}"
  local ok=$?

  if [[ "${ok}" -eq "${TRUE}" ]]; then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}

##
# save the installed state
# @param $1 <boolean>
# @use set_installed_state <boolean>
# @return <boolean>
##
function set_installed_state() {
  local state=$1
}

