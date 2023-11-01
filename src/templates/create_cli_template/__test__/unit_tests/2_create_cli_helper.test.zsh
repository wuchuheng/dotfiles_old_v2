#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}


function get_cli_installation_checker_provider_file_path_test() {
  globalCliInstallationCheckerProviderFilePath=''
  get_cli_installation_checker_provider_file_path "1_tmp_cli" globalCliInstallationCheckerProviderFilePath
  local exceptStrValue="src/cli/1_tmp_cli/tmp_cli_installation_checker_provider/tmp_cli_installation_checker_provider.zsh"
  except_str "${exceptStrValue}" "${globalCliInstallationCheckerProviderFilePath:${#APP_BASE_PATH + 1}}"
}

testing_callback_handle "get_cli_installation_checker_provider_file_path_test" "Unit test src/templates/create_cli_template/__test__/unit_tests/2_create_cli_helper.test.zsh"

