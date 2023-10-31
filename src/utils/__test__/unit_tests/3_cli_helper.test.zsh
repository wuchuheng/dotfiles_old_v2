#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/cli_helper.zsh # {get_cli_name_by_number_cli_dir}

function get_cli_name_by_number_cli_dir_test() {
  local testNumberCliDir='3_tmp_cli'
  globalCliDirNameStrRef=''
  get_cli_name_by_number_cli_dir "${testNumberCliDir}" globalCliDirNameStrRef
  local receiveStrValue="${globalCliDirNameStrRef}"
  unset globalCliDirNameStrRef
  except_str 'tmp_cli' "${receiveStrValue}"
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "get_cli_name_by_number_cli_dir_test" "Unit test src/utils/__test__/unit_tests/3_cli_helper.test.zsh"

