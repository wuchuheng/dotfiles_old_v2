#!/usr/bin/env zsh

declare -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

import ./create_cli_template_helper.zsh

# get the cli name from user's input
get_cli_name CLI_NAME



