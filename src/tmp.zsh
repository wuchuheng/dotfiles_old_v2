#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import @/src/utils/cli_helper.zsh # {get_cli_path_by_name}
import @/src/utils/ref_variable_helper.zsh # {generate_unique_var_name, get_str_from_ref}
import @/src/utils/swap_helper.zsh # {create_swap_file}

local proxyPathRef=$(generate_unique_var_name)
get_cli_path_by_name proxy "${proxyPathRef}"
local proxyPath=$(get_str_from_ref "${proxyPathRef}")

log INFO "proxy: ${proxyPath}"


