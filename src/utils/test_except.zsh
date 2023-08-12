#!/usr/bin/env zsh

import @/src/utils/helper.zsh


##
# 断言字符
# except_string "excepted str" "received str"
##
function except_str() {
  local prefix_path_len=${#APP_BASE_PATH}
  ((prefix_path_len++))
  local frame=${#funcstack}
  frame=$((frame - 1))
  local prev_idx=$(( ${#funcfiletrace[@]} - 4 ))
  local prev_file_line="${funcfiletrace[$prev_idx]}"
  local file_info=($(split_str "${prev_file_line}" ':'))
  local prev_line=${file_info[2]}
  local prev_file=${file_info[1]}
  local is_ok=0
  if [[ "$1" == "$2" ]]; then
    is_ok=1
  fi
  test_name="test_name:${global_test_name}"
  if [[ ${is_ok} -eq 1 ]]; then
    # printf "$(bg_green_print " PASS ") ${current_file}:${line} $test_name \n"
    return 0
  else
    local relative_file=${prev_file:${#APP_BASE_PATH} + 1}
    printf "$(bg_red_print " FAIL ") ${relative_file}:${prev_line}\n"
    printf "    $(pink_print '●') $(pink_print "${global_test_name}")\n"
    printf "    Expected: $(green_print "$1")\n"
    printf "    Received: $(red_print "$2")\n\n"
    get_a_part_of_code ${prev_file} ${prev_line}
    global_is_pass=1
    return 1
  fi
}

