#!/usr/bin/env zsh

import @/src/utils/log.zsh # {log}
import @/src/utils/os_helper.zsh # {get_os_name}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/utils/debug_helper.zsh #{assert_not_empty}
import @/src/utils/cli_helper.zsh #{get_current_cli_path}
import @/src/cli/2_proxy_cli/common_helper.zsh # {get_proxy_bin_file_path}

##
# install the cli on macOS
# @use _proxy_cli_mac_installer
# @return <boolean>
##
_proxy_cli_mac_installer() {
  local currentCliPathRef=$(generate_unique_var_name)
  get_current_cli_path "${currentCliPathRef}"
  local currentCliPath=$(get_str_from_ref "${currentCliPathRef}")

  local binPath=${currentCliPath}/bin

  local binTarPath="${binPath}/v2ray-macos.tar.gz"

  local binRef=$(generate_unique_var_name)
  get_proxy_bin_file_path "${binRef}"
  local bin=$(get_str_from_ref "${binRef}")

  if [[ ! -f ${bin} ]]; then
    tar -zxvf ${binTarPath} -C ${binPath}
  fi

  if [[ ! -f ${bin} ]]; then
    log ERROR "Installation failed on macOS";
    return ${FALSE}
  else
    return ${TRUE}
  fi

  # if the proxy config was not existed in the <proxy cli>/config.json, then create it.
  local configPath="${currentCliPath}/config.json"
  if [[ ! -f ${configPath} ]]; then
    base64decode
  fi
}

##
# the provider entry to install proxy cli
# @return <boolean>
##
function proxy_cli_installer() {
  # if you want to stop the installation, set isInstallBrokenRef to ${TRUE}
  local isInstallBrokenRef=$1
  log DEBUG "Installing proxy CLI cli tool..."

  local osNameRef=$(generate_unique_var_name)
  get_os_name "${osNameRef}"
  local osName=$(get_str_from_ref "${osNameRef}")

  local currentCliPathRef=$(generate_unique_var_name)
  get_current_cli_path "${currentCliPathRef}"
  local currentCliPath=$(get_str_from_ref "${currentCliPathRef}")


  case "${osName}" in
    MacOS)
      _proxy_cli_mac_installer
      if [[ $? -eq ${FALSE} ]]; then
        local isInstallBrokenRef=$1
        assign_str_to_ref "${FALSE}" "${isInstallBrokenRef}"
        return ${FALSE}
      fi
    ;;
    UbuntuOS|CentOS)
      assert_not_empty "${currentCliPath}"
      log ERROR "Installation failed on UbuntuOS or CentOS";
      assign_str_to_ref "${FALSE}" "${isInstallBrokenRef}"
      return ${FALSE}
    ;;
  esac

  return "${TRUE}"
}
