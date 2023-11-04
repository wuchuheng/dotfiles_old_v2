#!/usr/bin/env zsh

##
# The bootloader to install all cli.
#
# @User wuchuheng<root@wuchuheng.com>
# @Date 2023-10-25 02:18
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{get_cli_uninstallation_provider_file_path}
import ./boot_helper.zsh # { check_cli_by_number_dir }
import @/src/services/insert_dotfile_config_into_zshrc_service.zsh #{insertDotfileConfigIntoZshrcService}
import @/src/utils/cli_helper.zsh #{getCliDirList}
import @/src/utils/load_env.zsh # {set_env_type}
set_env_type 'install'

# get the cli list from cli directory.
local cliDirListRef=$(generate_unique_var_name)
getCliDirList ${cliDirListRef}
local cliDirList=($(get_str_from_ref "${cliDirListRef}"));

# to trigger the installation provider from cli dir
for numberCliDirName in "${cliDirList[@]}"; do
  # check the cli is installation or not.
  check_cli_by_number_dir "${numberCliDirName}"
  local isInstallation=$?
  # if the cli was not installed, then install it.
  if [[ "${isInstallation}" -eq "${FALSE}" ]]; then
    local cliInstallationProviderFilePathRef=$(generate_unique_var_name)
    get_cli_installation_provider_file_path "${numberCliDirName}" "${cliInstallationProviderFilePathRef}"
    local installProviderPath=$(get_str_from_ref "${cliInstallationProviderFilePathRef}")

    # import the installation provider file.
    import "${installProviderPath}"

    # get cli name without number.
    local cliNameRef=$(generate_unique_var_name)
    get_cli_name_by_number_cli_dir "${numberCliDirName}" "${cliNameRef}"
    local cliName=$(get_str_from_ref "${cliNameRef}")

    # trigger the installation provider.
    local isInstallBrokenRef=$(generate_unique_var_name)
    ${cliName}_installation_provider "${isInstallBrokenRef}"
    local isInstallBroken=$(get_str_from_ref "${isInstallBrokenRef}")
    if [[ ${isInstallBroken} -eq ${TRUE} ]]; then
      break;
    fi
  fi
done

# Insert the dotfile configuration into the ~/.zshrc
insertDotfileConfigIntoZshrcService

# Start zsh
zsh
