#!/usr/bin/env zsh

##
# @Use _get_func_name:get__runtime_space <cli name>
# @Echo <string>
# @Return <boolean>
##
funtion get_func_name:get__runtime_space() {
  local cliName=$1

  echo "get_${cliName}_runtime_space"
  return "${TRUE}"
}

##
# @Use _get_func_name:set_key_map_value_for <cli name>
# @Echo <string>
# @Return <boolean>
##
function get_func_name:set_key_map_value_for() {
  local cliName=$1

  echo "set_key_map_value_for_${cliName}"

  return "${TRUE}"
}

##
# @Use _get_func_name:set_key_map_value_with_ref_for <cli name>
# @Echo <string>
# @Return <boolean>
##
function get_func_name:set_key_map_value_with_ref_for() {
  local cliName=$1

  echo "set_key_map_value_with_ref_for_${cliName}"

  return "${TRUE}"
}

##
# @Use _get_func_name:get_key_map_value_for <cli name>
# @Echo <string>
# @Return <boolean>
##
function get_func_name:get_key_map_value_for() {
  local cliName=$1

  echo "get_key_map_value_for_${cliName}"
  return "${TRUE}"
}

##
#@Use _get_func_name:check_key_map_exists_for <cli name>
# @Echo <string>
# @Return <boolean>
##
function get_func_name:check_key_map_exists_for() {
  local cliName=$1

  echo "check_key_map_exists_for_${cliName}"
  return "${TRUE}"
}
