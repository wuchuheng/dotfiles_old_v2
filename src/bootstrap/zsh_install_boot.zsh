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


# get the cli list from cli directory.
local cliDirList=();
globalCliDirList=();
getCliDirList globalCliDirList;
cliDirList=("${globalCliDirList[@]}")
unset globalCliDirList

# to trigger the installation provider from cli dir
for numberCliDirName in "${cliDirList[@]}"; do
  local cliDirPath=$(getCliDirectory)
  globalCliDirNameRef=''
  get_cli_name_by_number_cli_dir "${numberCliDirName}" globalCliDirNameRef
  local installProviderPath="${cliDirPath}"/${numberCliDirName}/${globalCliDirNameRef}_installation_provider/${globalCliDirNameRef}_installation_provider.zsh
  source "${installProviderPath}"
done

