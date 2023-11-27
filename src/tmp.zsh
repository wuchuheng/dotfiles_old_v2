#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import @/src/utils/cli_helper.zsh # {get_cli_path_by_name, load_all_cli_from_boot_config}

local qjsExecutableCliRef=$(generate_unique_var_name)
get_executable_cli qjs.qjs "${qjsExecutableCliRef}"
qjsPath=$( get_str_from_ref "${qjsExecutableCliRef}" )

echo "${qjsPath}"
