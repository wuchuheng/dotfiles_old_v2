#!/usr/bin/env zsh

##
# The bootstrap for unit test.
#
# @User wuchuheng<root@wuchuheng.com>
# @Date 2023-10-25 02:18
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import ../utils/log.zsh # {log}
import ../utils/cli_helper.zsh # {get_sub_dir, get_cli_name_by_number_cli_dir}
import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{get_cli_installation_provider_file_path}

# get the cli list from cli directory.
local cliDirList=();
globalCliDirList=();
getCliDirList globalCliDirList;
cliDirList=("${globalCliDirList[@]}")
unset globalCliDirList

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
  if [[ "${isInstallation}" -eq "${FALSE}" ]]; then
    local cliInstallationProviderFilePathRef=$(generate_unique_var_name)
    get_cli_installation_provider_file_path "${numberCliDirName}" "${cliInstallationProviderFilePathRef}"
    local installProviderPath=$(get_str_from_ref "${cliInstallationProviderFilePathRef}")
    import "@/${installProviderPath}"

    # trigger the installation provider.
    ${cliName}_installation_provider
  fi
done
