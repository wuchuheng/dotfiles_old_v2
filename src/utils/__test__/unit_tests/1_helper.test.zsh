#!/usr/bin/env zsh

import @/src/handlers/testing_callback_handler.zsh
import @/src/utils/log.zsh
import @/src/utils/test_except.zsh

function get_all_sub_dir_by_path_test() {
  local BASE_PATH=$(get_runtime_space_by_unit_test_name "${global_test_name}")
  local dir1="${BASE_PATH}/dir1"
  local dir2="${BASE_PATH}/dir2"
  mkdir -p "$dir1"
  mkdir -p "$dir2"
  local result=($(get_all_sub_dir_by_path "${BASE_PATH}"))
  except_str "${#result[@]}" '2'
  except_str "${result[1]}" 'dir1'
  except_str "${result[2]}" 'dir2'
}

testing_callback_handle "get_all_sub_dir_by_path_test" "Test if you can get all the subdirectories unser a specifc path"

function split_str_test() {
  local result=($(split_str "hello_world" "_"))
  except_str "${#result[@]}" 2
  except_str "${result[1]}" "hello"
  except_str "${result[2]}" "world"
}

testing_callback_handle "split_str_test" "To test split_str function"

function get_max_number_file_by_path_test() {
  local BASE_PATH=$(get_runtime_space_by_unit_test_name "${global_test_name}")
  rm -rf "${BASE_PATH}/*"
  touch ${BASE_PATH}/{1,2,3,4}_file
  local result=$(get_max_number_file_by_path "${BASE_PATH}")
  except_str "$result" 4
}

testing_callback_handle "get_max_number_file_by_path_test" "To test get_max_number_file_by_path function"
