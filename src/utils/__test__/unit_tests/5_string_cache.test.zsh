#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler/testing_callback_handler.zsh #{testing_callback_handle}
import @/src/utils/test_except.zsh # {except_str}
import @/src/utils/string_cache.zsh # {setStringValue, setStringValueWithPointer, getStringValue, globalKeyMapValueCacheDirName}
import @/src/utils/ref_variable_helper.zsh #{generate_unique_var_name, assign_str_to_ref}


function setStringValue_test() {
  setStringValue 'testKey1' 'testValue'
  local cacheFile="src/runtime/${globalKeyMapValueCacheDirName}/testKey1"
  log INFO "cacheFile: ${cacheFile}"
  except_str 'testValue' $( cat ${cacheFile})
}
testing_callback_handle "setStringValue_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

function setStringValueWithPointer_test() {
  local exceptedValue='hello world'
  local exceptedValueRef=$(generate_unique_var_name)
  assign_str_to_ref "${exceptedValue}" "${exceptedValueRef}"
  local keyName="setStringValueTestKey"
  setStringValueWithPointer "${keyName}" "${exceptedValueRef}"
  except_str "${exceptedValue}" "$(cat src/runtime/${globalKeyMapValueCacheDirName}/${keyName})"
}
testing_callback_handle "setStringValueWithPointer_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

funtion getStringValue_test() {
  local exceptedValue='hello world'
  local keyName='getStringValueTestKey'
  echo ${exceptedValue} > src/runtime/${globalKeyMapValueCacheDirName}/${keyName}
  local receiveValue=$( getStringValue ${keyName} )
  except_str "${exceptedValue}" "${receiveValue}"
}
testing_callback_handle "getStringValue_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

function setStringValueWithSpace_test() {
  local spaceDir='test/keyMapValueCacheTest/spaceTestDir'
  setStringValue 'testKey1' 'testValue' "${spaceDir}"
  local targetFile="src/runtime/${spaceDir}/testKey1"
  except_str 'testValue' "$( cat  ${targetFile})"
}
testing_callback_handle "setStringValueWithSpace_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

function setStringWithPointerTest() {
  local spaceDir='test/keyMapValueCacheTest/spaceTestDir'
  local exceptValue='hello world'
  local exceptValueRef=$(generate_unique_var_name)
  assign_str_to_ref "${exceptValue}" "${exceptValueRef}"
  local keyName="setStringValueTestKey1"
  setStringValueWithPointer "${keyName}" "${exceptValueRef}" "${spaceDir}"
  local targetFile="src/runtime/${spaceDir}/${keyName}"
  except_str "${exceptValue}" "$(cat ${targetFile})"
}
testing_callback_handle "setStringWithPointerTest" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"

function get_string_value_with_space_test() {
  local spaceDir='test/keyMapValueCacheTest/spaceTestDir'
  local exceptedValue='hello world'
  local keyName='getStringValueTestKey2'
  echo ${exceptedValue} > src/runtime/${spaceDir}/${keyName}
  local receiveValue=$( getStringValue ${keyName} "${spaceDir}" )
  except_str "${exceptedValue}" "${receiveValue}"
}
testing_callback_handle "get_string_value_with_space_test" "Unit test src/utils/__test__/unit_tests/5_string_cache.test.zsh"
