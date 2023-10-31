#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name}

# the demo testing
function generate_unique_var_name_test() {
  local receiveVal=$( generate_unique_var_name )
  local exceptVal="src_utils___test___unit_tests_4_ref_variable_helper_test_zsh_9"
  except_str "${exceptVal}" "${receiveVal}"
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "generate_unique_var_name_test" "Unit test src/utils/__test__/unit_tests/4_ref_variable_helper.test.zsh"

