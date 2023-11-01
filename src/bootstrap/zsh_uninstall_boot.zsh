#!/usr/bin/env zsh

##
# This script is used to uninstall all cli
# @Author wuchuheng<root@wuchuheng.com>
# @Date 2023/11/01 18:53
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import ../utils/log.zsh # {log}
import ../utils/cli_helper.zsh # {get_sub_dir, get_cli_name_by_number_cli_dir}
import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{get_cli_uninstallation_provider_file_path}
import @/src/utils/load_env.zsh # {set_env_type}
set_env_type 'uninstall'

# get the cli list from cli directory.

local cliDirListRef=$(generate_unique_var_name)
getCliDirList ${cliDirListRef}
local cliDirList=($(get_str_from_ref "${cliDirListRef}"));

# to trigger the installation provider from cli dir
for numberCliDirName in "${cliDirList[@]}"; do
  local cliInstallationCheckerProviderFilePathRef=$(generate_unique_var_name)
  get_cli_installation_checker_provider_file_path "${numberCliDirName}" "${cliInstallationCheckerProviderFilePathRef}"
  local cliInstallationCheckerProviderFilePath=$(get_str_from_ref "${cliInstallationCheckerProviderFilePathRef}")
  import "@/${cliInstallationCheckerProviderFilePath}"

  # get cli name without number.
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${numberCliDirName}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")

  # trigger the installation checker.
  ${cliName}_installation_checker
  local isInstallation=$?
  # if the cli was not installed, then install it.
  if [[ "${isInstallation}" -eq "${TRUE}" ]]; then
    local cliUninstallationProviderFilePathRef=$(generate_unique_var_name)
    get_cli_uninstallation_provider_file_path "${numberCliDirName}" "${cliUninstallationProviderFilePathRef}"
    local uninstallProviderPath=$(get_str_from_ref "${cliUninstallationProviderFilePathRef}")
    import "@/${uninstallProviderPath}"

    # trigger the installation provider.
    ${cliName}_uninstallation_provider
  fi
done

