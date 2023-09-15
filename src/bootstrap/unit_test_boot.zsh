#!/usr/bin/env zsh

##
# The bootstrap for unit test.
#
# @User wuchuheng<root@wuchuheng.com>
# @Date 2023-07-14
##

# Declare a global variable in zsh while runtime for APP_PATH
typeset -g APP_BASE_PATH=$(pwd); source "${APP_BASE_PATH}"/src/utils/autoload.zsh || exit 1

import @/src/handlers/test_handler/test_handler.zsh
import @/src/config/test_conf.zsh
import @/src/utils/test_helper.zsh

all_test_files=()
for test_dir in "${ALL_TEST_DIR[@]}"; do
  all_test_files+=($(get_test_files "${test_dir}" 'unit_tests'))
done

test_handle "${all_test_files[@]}"
