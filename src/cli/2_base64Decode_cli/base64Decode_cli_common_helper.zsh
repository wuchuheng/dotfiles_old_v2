#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}

##
# get the cli runtime space.
# @Use get_tmp_runtime_space
# @Echo "<a directory path>"
##
function get_base64Decode_cli_runtime_space() {
  local cliRuntimeDir="$(getCliRuntimeDirectory)/base64Decode_cli"
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
function set_key_map_value_for_base64Decode_cli() {
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
function set_key_map_value_with_ref_for_base64Decode_cli() {
  local key="${1}"
  local valueRef=$2
  local cacheSpaceName=$(getCliRuntimeDirectory)/base64Decode_cli

  setStringValueWithPointer "${key}" "${valueRef}" "${cacheSpaceName}"

  return $?
}

##
# get value with key for tmp cli
# @Use get_key_map_value_for_tmp <key>
# @Echo <value>
# @Return <boolean>
##
function get_key_map_value_for_base64Decode_cli() {
  local key="${1}"
  local cacheSpaceName=$(getCliRuntimeDirectory)/base64Decode_cli

  getStringValue "${key}" "${cacheSpaceName}"
  return $?
}

##
# check the cache key exists or not.
# @Use check_key_map_exists_for_base64Decode_cli <key>
# @Return <boolean>
##
function check_key_map_exists_for_base64Decode_cli() {
  local key="${1}"
  local cacheSpaceName=$(getCliRuntimeDirectory)/base64Decode_cli

  getStringValue "${key}" "${cacheSpaceName}"
  return $?
}

