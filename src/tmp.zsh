#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/handlers/global_current_test.zsh
import @/src/utils/list_helper.zsh # {join}

my_array=(
  key1
  key2
  key3
)

outputResult=''
join "," my_array outputResult
echo $outputResult