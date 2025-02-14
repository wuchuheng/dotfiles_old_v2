#!/usr/bin/env zsh

# This script is used to bootstrap the dotfile on system.

source ${APP_BASE_PATH}/src/utils/autoload.zsh

import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{get_cli_uninstaller_file_path}
import ./boot_helper.zsh # { check_cli_by_number_dir }
import @/src/utils/cli_helper.zsh # {load_all_cli_from_boot_config, load_all_service_from_boot_config}
import @/src/utils/load_env.zsh # {set_env_type}
set_env_type 'prod'

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
  if [[ "${isInstallation}" -eq "${TRUE}" ]]; then

    # get cli name without number.
    local cliNameRef=$(generate_unique_var_name)
    get_cli_name_by_number_cli_dir "${numberCliDirName}" "${cliNameRef}"
    local cliName=$(get_str_from_ref "${cliNameRef}")

    # load all cli from boot config.
    load_all_cli_from_boot_config "${cliName}"
    # load all service from boot config.
    load_all_service_from_boot_config "${cliName}"
  fi
done
