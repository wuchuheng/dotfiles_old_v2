#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}


function getCliInstallationCheckerProviderFilePathTest() {
  globalCliInstallationCheckerProviderFilePath=''
  getCliInstallationCheckerProviderFilePath "1_tmp_cli" globalCliInstallationCheckerProviderFilePath
  local exceptStrValue="1_tmp_cli/tmp_cli_installation_checker_provider/tmp_cli_installation_checker_provider.zsh"
  except_str "${exceptStrValue}" "${globalCliInstallationCheckerProviderFilePath}"
}

testing_callback_handle "getCliInstallationCheckerProviderFilePathTest" "Unit test src/templates/create_cli_template/__test__/unit_tests/2_create_cli_helper.test.zsh"

