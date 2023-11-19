#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/os_helper.zsh # {get_os_name}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref, assign_str_to_ref}
import @/src/utils/debug_helper.zsh #{assert_not_empty}
import @/src/utils/cli_helper.zsh #{get_current_cli_path, get_cli_path_by_name}
import @/src/cli/2_proxy_cli/common_helper.zsh # {get_proxy_bin_file_path}
import @/src/utils/load_env.zsh  #{get_env}

##
# decompose the linux proxy cli binary file.
# @use _decompose_linux_proxy_cli_binary_file
# @return <boolean>


##
# check the proxy config existed or create a new config.
# @use _check_proxy_config_or_create
# @return <boolean>
_check_proxy_config_or_create() {
  # get config file path
  local proxyCliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name proxy "${proxyCliPathRef}"
  local proxyCliPath=$(get_str_from_ref "${proxyCliPathRef}")
  local configJsonPath="${proxyCliPath}/proxy_config.json"

  # convert the env to base64Text
  local vmessUrl=$( get_env "PROXY_CLI_VMESS_URL" )
  if [[ -z "${vmessUrl}" ]]; then
    assert_not_empty "${vmessUrl}"
    return "${FALSE}"
  fi
  local base64Txt=${vmessUrl#vmess://}

  # get the base64 parser cli
  local base64DecodeCliRef=$(generate_unique_var_name)
  get_executable_cli qjs.base64Decode "${base64DecodeCliRef}"
  local base64DecodeCli=$(get_str_from_ref "${base64DecodeCliRef}")

  # parse the base64 text to json and save to the config file.
  eval "${base64DecodeCli} ${base64Txt} > ${configJsonPath}"

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
  # check the config or create
  _check_proxy_config_or_create
  if [[ $? -eq ${TRUE} ]];then
    assign_str_to_ref "${TRUE}" "${isInstallBrokenRef}"
    return ${FALSE}
  fi


  return "${TRUE}"
}
