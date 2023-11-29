#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/os_helper.zsh # {get_os_name}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref, assign_str_to_ref}
import @/src/utils/debug_helper.zsh #{assert_not_empty}
import @/src/utils/cli_helper.zsh #{get_current_cli_path, get_cli_path_by_name}
import @/src/utils/load_env.zsh  #{get_env}


##
# check the proxy config existed or create a new config.
# @use _check_proxy_config_or_create <cli name>
# @return <boolean>
_check_proxy_config_or_create() {
  assert_not_empty "$1"
  local cliName="$1"
  # get config file path
  local proxyCliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name "${cliName}" "${proxyCliPathRef}"
  local proxyCliPath=$(get_str_from_ref "${proxyCliPathRef}")
  local configJsonPath="${proxyCliPath}/proxy_config.json5"

  # convert the env to base64Text
  local vmessUrl=$( get_env "PROXY_CLI_CONFIG" )
  if [[ -z "${vmessUrl}" ]]; then
    assert_not_empty "${vmessUrl}"
    return "${FALSE}"
  fi
  local base64Txt=${vmessUrl}

  # get the base64 parser cli
  local base64DecodeCliRef=$(generate_unique_var_name)
  get_executable_cli qjs.decodeBase64 "${base64DecodeCliRef}"
  local decodeBase64Cli=$(get_str_from_ref "${base64DecodeCliRef}")

  # parse the base64 text to json and save to the config file.
  eval "${decodeBase64Cli} ${base64Txt} > ${configJsonPath}"

  return ${TRUE}
}

##
# check the proxy log file exited or try to create
# @use _check_proxy_log_existed_or_create <cli name>
# @return <boolean>
##
function _check_proxy_log_existed_or_create() {
  assert_not_empty "$1"
  local cliName="$1"
  # get config file path
  local proxyCliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name "${cliName}" "${proxyCliPathRef}"
  local proxyCliPath=$(get_str_from_ref "${proxyCliPathRef}")
  local logFilePath="${proxyCliPath}/proxy.log"

  if [[ ! -f "${logFilePath}" ]]; then
    touch "${logFilePath}"
  fi

  return ${TRUE}
}


##
# the provider entry to install proxy cli
# @return <boolean>
##
function proxy_cli_installer() {
  # if you want to stop the installation, set isInstallBrokenRef to ${TRUE}
  local isInstallBrokenRef=$1
  log DEBUG "Installing proxy CLI cli tool..."
  local cliName='proxy'
  # check the config or create
  _check_proxy_config_or_create "${cliName}"
  if [[ $? -eq ${TRUE} ]];then
    assign_str_to_ref "${TRUE}" "${isInstallBrokenRef}"
    return ${FALSE}
  fi

  return "${TRUE}"
}
