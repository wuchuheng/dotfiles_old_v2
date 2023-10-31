#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, assign_str_to_ref, get_str_from_ref}

# the demo testing
function generate_unique_var_name_test() {
  local receiveVal=$( generate_unique_var_name )
  local exceptVal="src_utils___test___unit_tests_4_ref_variable_helper_test_zsh_9"
  except_str "${exceptVal}" "${receiveVal}"
}

# call hello_world_test() function，and pass the testing callback with the testing name and testing description.
testing_callback_handle "generate_unique_var_name_test" "Unit test src/utils/__test__/unit_tests/4_ref_variable_helper.test.zsh"

function assign_str_to_ref_test() {
  local strRefName=$( generate_unique_var_name )
  local exceptVal="hello world"
  assign_str_to_ref "${exceptVal}" "${strRefName}"
  local receiveValue=''
  eval " receiveValue=\"\${$strRefName}\" "
  except_str "${exceptVal}" "${receiveValue}"
}
testing_callback_handle "assign_str_to_ref_test" "Unit test the function assign_str_to_ref_test"

function get_str_from_ref_test() {
  local strRefName=$( generate_unique_var_name )
  local exceptVal="hello world"
  assign_str_to_ref "${exceptVal}" "${strRefName}"
  local receiveValue=$(get_str_from_ref "${strRefName}")
  except_str "${exceptVal}" "${receiveValue}"

}
testing_callback_handle "get_str_from_ref_test" "Unit test the function get_str_from_ref_test"

