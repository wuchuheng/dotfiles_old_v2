#!/usr/bin/env zsh

import ../utils/cli_helper.zsh # {get_cli_name_by_number_cli_dir}
import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}

##
# check the cli by numberCliDir
# @Use check_cli_by_number_dir "<number cli dir>"
# @Return "<boolean>"
##
function check_cli_by_number_dir() {
  local numberCliDirName=$1
  local cliInstallationCheckerProviderFilePathRef=$(generate_unique_var_name)
  get_cli_check_install_file_path "${numberCliDirName}" "${cliInstallationCheckerProviderFilePathRef}"
  local cliInstallationCheckerProviderFilePath=$(get_str_from_ref "${cliInstallationCheckerProviderFilePathRef}")
  import "${cliInstallationCheckerProviderFilePath}"

  # get cli name without number.
  local cliNameRef=$(generate_unique_var_name)
  get_cli_name_by_number_cli_dir "${numberCliDirName}" "${cliNameRef}"
  local cliName=$(get_str_from_ref "${cliNameRef}")

  # trigger the installation checker.
  ${cliName}_cli_installation_checker

  if [[ $? == 0 ]]; then
    return ${TRUE}
  else
    return ${FALSE}
  fi
}
