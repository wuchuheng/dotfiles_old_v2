#!/usr/bin/env zsh

import @/src/utils/string_cache.zsh #{setStringValue, setStringValueWithPointer, getStringValue}
import @/src/utils/debug_helper.zsh #{assert_not_empty}
import @/src/utils/ref_variable_helper.zsh # { assign_str_to_ref, generate_unique_var_name }
import @/src/utils/os_helper.zsh # {get_os_name}
import @/src/utils/cli_helper.zsh # {get_cli_path_by_name}
import @/src/utils/load_env.zsh #{get_env}

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

##
# get the success log file path
# @use _get_log_file_path <cli name> <log type: success | error> <log file path ref>
# @return <boolean>
##
function _get_log_file_path() {
  assert_not_empty "$1"
  assert_not_empty "$2"
  [[ "$2" != "success" && "$2" != "error" ]] && assert_equal "true" "false"
  assert_not_empty "$3"
  local inputCliName="$1"

  local cliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name "${inputCliName}" "${cliPathRef}"
  local cliPath=$(get_str_from_ref "${cliPathRef}")
  local logType="$2"
  local logFile="${cliPath}/runtime/log/$(date +%Y-%m-%d)/${logType}.log"

  # if the log file is not exist, create it
  [[ ! -d $(dirname ${logFile}) ]] && mkdir -p $(dirname ${logFile})
  [[ ! -f ${logFile} ]] && touch ${logFile}

  local outputLogFileRef="$3"
  assign_str_to_ref "${logFile}" "${outputLogFileRef}"

  return $?
}

##
# get the success proxy log file path
# @use get_success_proxy_log_file_path <cli name> <log file path ref>
# @return <boolean>
##
function get_success_proxy_log_file_path() {
  assert_not_empty "$1"
  assert_not_empty "$2"

  local inputCliName="$1"
  local outputLogFileRef="$2"
  _get_log_file_path "${inputCliName}" "success" "${outputLogFileRef}"

  return $?
}

##
# get the error proxy log file path
# @use get_error_proxy_log_file_path <cli name> <log file path ref>
# @return <boolean>
##
function get_error_proxy_log_file_path() {
  assert_not_empty "$1"
  assert_not_empty "$2"

  local inputCliName="$1"
  local outputLogFileRef="$2"
  _get_log_file_path "${inputCliName}" "error" "${outputLogFileRef}"

  return $?
}

##
#
function print_proxy_command() {
  local httpPort=$(get_env "PROXY_CLI_HTTP_PORT" 2089)
  local sock5Port=$(get_env "PROXY_CLI_SOCK5_PORT" 2080)
  assert_not_empty "${httpPort}"
  assert_not_empty "${sock5Port}"
  echo "export http_proxy=http://127.0.0.1:${httpPort};export https_proxy=http://127.0.0.1:${httpPort};export ALL_PROXY=socks5://127.0.0.1:${sock5Port}"
}
