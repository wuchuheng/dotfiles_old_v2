#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import @/src/utils/cli_helper.zsh # {get_cli_name_by_number_cli_dir, load_all_cli_from_boot_config}
import @/src/templates/create_cli_template/create_cli_helper.zsh #{check_runtime_dir_or_create}

check_runtime_dir_or_create "1_qjs_cli"

