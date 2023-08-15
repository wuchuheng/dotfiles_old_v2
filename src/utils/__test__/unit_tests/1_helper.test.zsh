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

function get_runtime_space_by_unit_test_name_test() {
  local result=$(get_runtime_space_by_unit_test_name "get_a_part_of_code_test")
  local test_file_name=$(get_file_name_exclude_path "${global_test_file}")
  except_str "${APP_BASE_PATH}/src/runtime/test/unit_test/${test_file_name}/get_a_part_of_code_test" "$result"
}

testing_callback_handle "get_runtime_space_by_unit_test_name_test" "To test get_runtime_space_by_unit_test_name function"


function push_dir_to_test_conf_test() {
  local BASE_PATH=$(get_runtime_space_by_unit_test_name "${global_test_name}")
  local config_file=src/config/test_conf.zsh
  local readonly config_content=$(sed '$d' $config_file)
  new_dir="src/utils2/__test__"
  except_value="`cat << EOF
${config_content}
${new_dir}
)
EOF
`"

  push_dir_to_test_conf "${new_dir}"
  result=$(cat ${config_file})
  except_str "$except_value" "$result"
  cat > $config_file << EOF
${config_content}
)
EOF
}

testing_callback_handle "push_dir_to_test_conf_test" "To push_dir_to_test_conf function"

function get_full_path_test() {
  local result=$(get_full_path "tmp")
  except_str "$result" "${APP_BASE_PATH}/tmp"
}

testing_callback_handle "get_full_path_test" "To test get_full_path function"

function get_test_files_test() {
  local unit_test_path=src/utils/__test__
  local result=($(get_test_files "${unit_test_path}" 'unit_tests'))
  files_str=$(ls -ahl ${unit_test_path}/unit_tests | awk 'NR > 3 {print $9}')
  local except_value=()
  while IFS= read -r line; do
    except_value+=("${unit_test_path}/unit_tests/${line}")
  done <<< "$files_str"
  except_str ${#except_value[@]} ${#result[@]}
  except_value_len=${#except_value[@]}
  for (( i = 1; i <= except_value_len; i++)); do
    except_str "${except_value[$i]}" "${result[$i]}"
  done
}

testing_callback_handle "get_test_files_test" "To get_test_files function"

function get_all_file_by_path_test() {
  local BASE_PATH=$(get_runtime_space_by_unit_test_name "${global_test_name}")
  rm -rf "${BASE_PATH}"/*;
  local file1=${BASE_PATH}/file1;
  local file2=${BASE_PATH}/file2;
  local dir=${BASE_PATH}/dir1;
  touch "$file1" "$file2"
  mkdir -p "$dir"
  local all_file=($(get_all_file_by_path "${BASE_PATH}"))
  except_str ${#all_file[@]} 2
  except_str "${all_file[1]}" "file1"
  except_str "${all_file[2]}" "file2"
}

testing_callback_handle "get_all_file_by_path_test" "To test get_all_file_by_path function"

function get_a_part_of_code_test() {
  local BASE_PATH=$(get_runtime_space_by_unit_test_name "${global_test_name}")
  local test_file=${BASE_PATH}/code_for_test.txt
  cat > "${test_file}" << EOF
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
EOF
  local result=$(get_a_part_of_code "${test_file}" 10)
  local except_value="    5  | 5
    6  | 6
    7  | 7
    8  | 8
    9  | 9
 [0;31m[1m->[0m 10 | 10
    11 | 11
    12 | 12
    13 | 13
    14 | 14
    15 | 15"
  log_file=${BASE_PATH}/log.txt
  except_str "${result}" "${except_value}"
}

testing_callback_handle "get_a_part_of_code_test" "To test to get a part of conrent frome a file with a file path and a number line."

function get_file_name_exclude_path_test() {
  local file=$(get_file_name_exclude_path /1/2/3/file)
  except_str "$file" "file"
}

testing_callback_handle "get_file_name_exclude_path_test" "To test get_file_name_exclude_path function"
