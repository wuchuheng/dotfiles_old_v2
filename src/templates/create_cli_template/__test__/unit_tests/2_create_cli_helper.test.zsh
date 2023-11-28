#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, get_str_from_ref}


function get_cli_check_install_file_path_test() {
  globalCliInstallationCheckerProviderFilePath=''
  get_cli_check_install_file_path "1_tmp_cli" globalCliInstallationCheckerProviderFilePath
  local exceptStrValue="src/cli/1_tmp_cli/check_install/check_install.zsh"
  local receiveValue=${globalCliInstallationCheckerProviderFilePath:${#APP_BASE_PATH} + 1}
  except_str "${exceptStrValue}"  "${receiveValue}"
}

# TODO(ISSUE): except the print log for description is 'test get_cli_check_install_file_path_test' ,but 'get_cli_check_install_file_path_test' only in the unit test output
testing_callback_handle "get_cli_check_install_file_path_test" "test get_cli_check_install_file_path_test"

function get_cli_boot_config_json5_path_test() {
  local cliBootConfigJson5PathRef=$(generate_unique_var_name)
  get_cli_boot_config_json5_path "1_tmp_cli" "${cliBootConfigJson5PathRef}"
  local exceptStrValue="src/cli/1_tmp_cli/boot_config.json5"
  local cliBootConfigJson5Path=$(get_str_from_ref "${cliBootConfigJson5PathRef}")
  local receiveValue=${cliBootConfigJson5Path:${#APP_BASE_PATH} + 1}
  except_str "${exceptStrValue}"  "${receiveValue}"

}

testing_callback_handle "get_cli_boot_config_json5_path_test" "test get_cli_boot_config_json5_path"

