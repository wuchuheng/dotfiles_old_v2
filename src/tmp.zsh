#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/handlers/global_current_test.zsh

my_array=(
  key1 value1
  key2 value2
  key3 value3
)

# Iterate over the array with keys and values
for key val in "${my_array[@]}"; do
  echo "Key: $key, Value: $val"
done
