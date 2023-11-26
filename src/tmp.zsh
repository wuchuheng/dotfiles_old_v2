#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import @/src/utils/cli_helper.zsh # {get_cli_path_by_name, load_all_cli_from_boot_config}
import @/src/utils/cli_helper.zsh #{get_current_cli_name, get_current_cli_path, load_cli_from_command_config}

load_all_cli_from_boot_config qjs