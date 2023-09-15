#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/utils/helper.zsh

str=':xxxloading:xxxget_all_sub_dir_by_path_test:xxx28:xxx40:xxxTest if you can get all the subdirectories unser a specifc path:xxx2'


listDecode "${str}" 'result'

echo "${#result}"

echo "${result[1]}"
echo "${result[2]}"
echo "${result[3]}"
echo "${result[4]}"
echo "${result[5]}"
echo "${result[6]}"
