#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/templates/create_cli_template/create_cli_helper.zsh #{getCliInstallationCheckerProviderFilePath}
import @/src/utils/test_except.zsh # {except_str}

function proxy_cli_uninstallation_test() {
  except_str "1"  "1"
}

testing_callback_handle "proxy_cli_uninstallation_test" "test proxy_cli_uninstallation_test"

