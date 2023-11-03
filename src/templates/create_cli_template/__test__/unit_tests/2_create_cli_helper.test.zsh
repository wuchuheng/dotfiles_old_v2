#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}


function get_cli_installation_checker_provider_file_path_test() {
  globalCliInstallationCheckerProviderFilePath=''
  get_cli_installation_checker_provider_file_path "1_tmp_cli" globalCliInstallationCheckerProviderFilePath
  local exceptStrValue="src/cli/1_tmp_cli/tmp_cli_installation_checker_provider/tmp_cli_installation_checker_provider.zsh"
  local receiveValue=${globalCliInstallationCheckerProviderFilePath:${#APP_BASE_PATH} + 1}
  except_str "${exceptStrValue}"  "${receiveValue}"
}

# TODO(ISSUE): except the print log for description is 'test get_cli_installation_checker_provider_file_path_test' ,but 'get_cli_installation_checker_provider_file_path_test' only in the unit test output
testing_callback_handle "get_cli_installation_checker_provider_file_path_test" "test get_cli_installation_checker_provider_file_path_test"

