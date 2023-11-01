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
import ../utils/cli_helper.zsh # {get_sub_dir}
import ../utils/ref_variable_helper.zsh # {generate_unique_var_name}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{get_cli_installation_provider_file_path}



# get the cli list from cli directory.
local cliDirList=();
globalCliDirList=();
getCliDirList globalCliDirList;
cliDirList=("${globalCliDirList[@]}")
unset globalCliDirList

# to trigger the installation provider from cli dir
for numberCliDirName in "${cliDirList[@]}"; do
  local cliInstallationProviderFilePathRef=$(generate_unique_var_name)
  get_cli_installation_provider_file_path "${numberCliDirName}" "${cliInstallationProviderFilePathRef}"
  local installProviderPath=$(get_str_from_ref "${cliInstallationProviderFilePathRef}")
  source "${installProviderPath}"
done

