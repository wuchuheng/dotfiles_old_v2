#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/handlers/global_current_test.zsh

foo=1
bar=2

result=$((${foo} + ${bar}))

echo ${result}