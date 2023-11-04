#!/usr/bin/env zsh

##
# The bootstrap for unit test.
#
# @User wuchuheng<root@wuchuheng.com>
# @Date 2023-11-04
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/handlers/test_handler/test_handler.zsh
import @/src/config/test_conf.zsh
import ../utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/utils/cli_helper.zsh #{getCliDirList}
import @/src/utils/test_helper.zsh #{get_test_files}
import @/src/utils/load_env.zsh # {set_env_type}
set_env_type 'test'

# get the cli list from cli directory.
local cliDirListRef=$(generate_unique_var_name)
getCliDirList ${cliDirListRef}
local cliDirList=($(get_str_from_ref "${cliDirListRef}"));

all_test_files=()
for numCliName in "${cliDirList[@]}"; do
  local testDir="src/cli/${numCliName}/__test__"
  all_test_files+=($(get_test_files "${testDir}" 'installation_tests'))
done

test_handle "${all_test_files[@]}"