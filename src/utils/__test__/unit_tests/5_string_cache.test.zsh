#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh #{testing_callback_handle}
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/string_cache.zsh # {setStringValue, setStringValueWithPointer, getStringValue}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, assign_str_to_ref}


function setStringValue_test() {
  setStringValue 'testKey1' 'testValue'
  except_str 'testValue' $( cat src/runtime/cache/testKey1 )
}
testing_callback_handle "setStringValue_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

function setStringValueWithPointer_test() {
  local exceptedValue='hello world'
  local exceptedValueRef=$(generate_unique_var_name)
  assign_str_to_ref "${exceptedValue}" "${exceptedValueRef}"
  local keyName="setStringValueTestKey"
  setStringValueWithPointer "${keyName}" "${exceptedValueRef}"
  except_str "${exceptedValue}" "$(cat src/runtime/cache/${keyName})"
}
testing_callback_handle "setStringValueWithPointer_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

funtion getStringValue_test() {
  local exceptedValue='hello world'
  local keyName='getStringValueTestKey'
  echo ${exceptedValue} > src/runtime/cache/${keyName}
  local receiveValue=$( getStringValue ${keyName} )
  except_str "${exceptedValue}" "${receiveValue}"
}
testing_callback_handle "getStringValue_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"