#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/cli_helper.zsh # {get_cli_name_by_number_cli_dir, get_cli_binary_name}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, get_str_from_ref}

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

function get_cli_path_by_name_test() {
  local cliNameRef=$(generate_unique_var_name)
  get_cli_path_by_name qjs "${cliNameRef}"
  local cliNamePath=$(get_str_from_ref "${cliNameRef}")
  except_str "${APP_BASE_PATH}/src/cli/1_qjs_cli" "${cliNamePath}"
}

testing_callback_handle "get_cli_path_by_name_test" "Unit test src/utils/__test__/unit_tests/3_cli_helper.test.zsh"


function get_cli_binary_name_test() {
  local qjsBinaryNameRef=$(generate_unique_var_name)
  local cliName=qjs
  get_cli_binary_name "${cliName}" "${qjsBinaryNameRef}"
  local qjsBinaryName=$(get_str_from_ref "${qjsBinaryNameRef}")

  local osName=$(uname -s)
  local hardwareName=$(uname -m)
  local qjsBinaryNameExpected="${cliName}_${osName}_${hardwareName}"

  except_str "${qjsBinaryNameExpected}" "${qjsBinaryName}"
}

testing_callback_handle get_cli_binary_name_test ''

function get_executable_cli_test() {
  local qjsExecutableCliRef=$(generate_unique_var_name)
  get_executable_cli qjs "${qjsExecutableCliRef}"
  local qjsExecutableCli=$(get_str_from_ref "${qjsExecutableCliRef}")

  local cliName=qjs
  local cliPathRef=$(generate_unique_var_name)
  get_cli_path_by_name "${cliName}" "${cliPathRef}"
  local cliPath=$(get_str_from_ref "${cliPathRef}")

  except_str "${cliPath}/bin/${cliName}_$(uname -s)_$(uname -m)" "${qjsExecutableCli}"
}
testing_callback_handle get_executable_cli_test ''
