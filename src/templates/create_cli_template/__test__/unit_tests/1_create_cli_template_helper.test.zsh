#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/utils/test_except.zsh
import ../../create_cli_template_helper.zsh

function get_input_cli_name_test() {
  echo "hello world" | get_input_cli_name CLI_NAME
  except_str "${CLI_NAME}" 'hello_world'
}

testing_callback_handle "get_input_cli_name_test" "Unit test get_input_cli_name_test"

