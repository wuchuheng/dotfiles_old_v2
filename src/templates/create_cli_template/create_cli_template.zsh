#!/usr/bin/env zsh

declare -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import ./create_cli_template_helper.zsh # {get_input_cli_name, check_if_cli_name_is_exist}
import ../../utils/log.zsh # {log}
import ./create_cli_helper.zsh # {create_cli}

# get the cli name from user's input
get_input_cli_name CLI_NAME

# check if the cli name is exist
check_if_cli_name_is_exist "${CLI_NAME}"; ok=$?

if [[ ${ok} -eq ${TRUE} ]]; then
    log ERROR "${CLI_NAME} is already exist."
    exit;
fi

create_cli "${CLI_NAME}"

